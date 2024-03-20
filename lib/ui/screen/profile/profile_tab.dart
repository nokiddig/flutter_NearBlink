import '../../../model/follow.dart';
import '../../../services/save_account.dart';
import '../../../ui/screen/blog/blog_detail.dart';
import '../../../ui/screen/blog/create_blog.dart';
import '../../../ui/screen/profile/edit_profile.dart';
import '../../../utils/constant/my_const.dart';
import 'package:flutter/material.dart';

import '../../../model/account.dart';
import '../../../model/blog.dart';
import '../../../repository/account_repository.dart';
import '../../../repository/blog_repository.dart';
import '../../../repository/follow_repository.dart';

class ProfileTab extends StatefulWidget {
  ProfileTab({super.key, required this.email});
  String email = "";
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  AccountRepository accountViewModel = AccountRepository();
  BlogRepository blogViewModel = BlogRepository();
  
  @override
  Widget build(BuildContext context) {
    Future<Account?> currentAccount = accountViewModel.getByEmail(widget.email);
    Stream<List<Blog>> blogStream = blogViewModel.getBlogsByEmail(widget.email);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder(
                future: currentAccount,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      SizedBox(height: 200, child: _TopPortion(snapshot.data)),
                      SizedBox(
                        height: 220,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                snapshot.data?.name ?? "Richie Lorie",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              if(widget.email != SaveAccount.currentEmail)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    genFollowButton(widget.email),
                                    const SizedBox(width: 16.0),
                                    FloatingActionButton.extended(
                                      onPressed: () {},
                                      heroTag: 'Block',
                                      elevation: 0,
                                      backgroundColor: Colors.red,
                                      label: const Text("Block"),
                                      icon: const Icon(Icons.block),
                                    ),
                                  ],
                                )
                              else
                                const Text(
                                  'Have a good day!',
                                  style: TextStyle(
                                    color: Colors.blue, // Màu chữ
                                    fontSize: 24, // Kích thước chữ
                                    fontWeight: FontWeight.bold, // Độ đậm
                                    fontStyle: FontStyle.italic, // Kiểu chữ nghiêng
                                    decoration: TextDecoration.underline, // Gạch chân chữ
                                    decorationColor: Colors.red, // Màu của gạch chân
                                    decorationStyle: TextDecorationStyle.dashed, // Kiểu của gạch chân
                                  ),
                                ),
                              const SizedBox(height: 16),
                              _ProfileInfoRow(widget.email, blogStream)
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              ),
              StreamBuilder(
                  stream: blogStream, builder: (context, snapshot) {
                    List<Blog> blogs = snapshot.data ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: blogs.length,
                        itemBuilder: (context, index) {
                          return ABlogDetail(blogs[index]);
                        },
                    );
                  },),
            ],
          ),
        ),
          Positioned(
            top: 16,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 16,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (context) => const EditProfile(),);
                Navigator.push(context, route);
              },
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => const CreateBlog(),);
          Navigator.push(context, route);
        },
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget genFollowButton(String followingEmail) {
    FollowRepository viewmodel = FollowRepository();
    return StreamBuilder<bool>(
      stream: viewmodel.checkFollow( SaveAccount.currentEmail!, followingEmail),
      builder: (context, snapshot) {
        bool state = false;
        String followText = "Follow";
        Color backgroundColor = DefaultSelectionStyle.defaultColor;
        IconData iconData = Icons.person_add_alt_1;
        if (snapshot.hasData){
          if (snapshot.data == true){
            state = snapshot.data!;
            followText = "Followed";
            backgroundColor = Colors.green;
            iconData = Icons.person_2_outlined;
          }
        }

        return FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              if (state == true){
                viewmodel.delete(followingEmail);
              }
              else{
                viewmodel.add(Follow("id", SaveAccount.currentEmail!, followingEmail));
              }
            });
          },
          elevation: 0,
          heroTag: 'Follow',
          label: Text(followText),
          icon: Icon(iconData),
          backgroundColor: backgroundColor,
        );
      }
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String email;
  Stream<List<Blog>> blogStream;
  FollowRepository followViewmodel = FollowRepository();
  

  _ProfileInfoRow(this.email, this.blogStream);

  @override
  Widget build(BuildContext context) {
    final List<ProfileInfoItem> _items = [
      ProfileInfoItem("Posts", blogStream.map((event) => event.length)),
      ProfileInfoItem("Followers", followViewmodel.countFollower(email)),
      ProfileInfoItem("Following", followViewmodel.countFollowing(email)),
    ];
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
            child: Row(
              children: [
                if (_items.indexOf(item) != 0) const VerticalDivider(),
                Expanded(child: _singleItem(context, item)),
              ],
            )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<int>(
          stream: item.value,
          builder: (context, snapshot) {
            if (snapshot.hasData){
              return Text(
                snapshot.data.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              );
            }
            else {
              return const Center(child: CircularProgressIndicator());
            }
            
          }
        ),
      ),
      Text(
        item.title,
        style: Theme.of(context).textTheme.caption,
      )
    ],
  );
}

class ProfileInfoItem {
  final String title;
  Stream<int> value;
  ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  Account? account;
  AccountRepository viewModel = AccountRepository();

  _TopPortion(Account? this.account, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              account?.avatarPath == "" ? STRING_CONST.NETWORKIMAGE_DEFAULT
                                  : (account?.avatarPath ?? STRING_CONST.NETWORKIMAGE_DEFAULT)
                          )
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
