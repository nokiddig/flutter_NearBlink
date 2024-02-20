import 'package:blog_app/services/save_account.dart';
import 'package:blog_app/utils/constain/my_const.dart';
import 'package:flutter/material.dart';

import '../../../model/account.dart';
import '../../../repository/account_repository.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
  int selectedGender = 0; // nam
  final _formKey = GlobalKey<FormState>();

  AccountRepository accountViewModel = AccountRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit profile"),
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder(
            future: accountViewModel.getByEmail(SaveAccount.currentEmail ?? ""),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Account account = snapshot.data!;
                _nameController.text = account.name;
                _avatarController.text = account.avatarPath;
                selectedGender = account.gender;
                return Column(
                  children: [
                    const Text("Preview"),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        _avatarController.text,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.network(STRING_CONST.NETWORKIMAGE_DEFAULT),
                      ),
                    ),
                    Text(_nameController.text),
                    UI_CONST.SIZEDBOX30,
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: "John...",
                        labelText: "Name",
                        icon: Icon(Icons.text_fields),
                        border: OutlineInputBorder(),
                      ),
                      controller: _nameController,
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{5,200}$');
                        return regex.hasMatch(value ?? "")
                            ? null
                            : "5-200 characters.";
                      },
                    ),
                    UI_CONST.SIZEDBOX15,
                    TextFormField(
                      scrollController: ScrollController(),
                      maxLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: "Avatar path...",
                        labelText: "Avatar",
                        icon: Icon(Icons.image_outlined),
                        border: OutlineInputBorder(),
                      ),
                      controller: _avatarController,
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{5,}$');
                        return regex.hasMatch(value ?? "")
                            ? null
                            : "Not null.";
                      },
                    ),
                    UI_CONST.SIZEDBOX15,
                    Column(
                      children: <Widget>[
                        RadioListTile(
                          title: const Text('Male'),
                          value: 0,
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = int.parse(value.toString());
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('Female'),
                          value: 1,
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = int.parse(value.toString());
                            });
                          },
                        ),
                      ],
                    ),
                    UI_CONST.SIZEDBOX15,
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          editProfile(account);
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Submit"),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  void editProfile(Account account) {
    AccountRepository accountViewModel = AccountRepository();
    account.avatarPath = _avatarController.text;
    account.name = _nameController.text;
    account.gender = selectedGender;
    accountViewModel.edit(account);
  }
}
