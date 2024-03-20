import '../services/firebase_authentication.dart';
import '../utils/constant/string_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

 class  SaveAccount {
  static String? currentEmail;
  String? _email;
  String? _pass;
  bool? _isCheckedSave;
  late SharedPreferences _preferences;
  static final SaveAccount _instance = SaveAccount._internal();

  factory SaveAccount(){
    return _instance!;
  }

  SaveAccount._internal(){
    init();
  }

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _email = await _preferences.getString(STRING_CONST.SAVE_EMAIL);
    _pass = await _preferences.getString(STRING_CONST.SAVE_PASS);
    _isCheckedSave = await _preferences.getBool(STRING_CONST.SAVE_ISCHECKED);
    currentEmail = await getUserEmail();
  }

  void save(String email, String pass, bool isChecked) async {
    await _preferences.setString(STRING_CONST.SAVE_EMAIL, email);
    await _preferences.setString(STRING_CONST.SAVE_PASS, pass);
    await _preferences.setBool(STRING_CONST.SAVE_ISCHECKED, isChecked);
    init();
  }

  void clear() {
    _preferences.clear();
  }

  Future<SaveAccount> loadAccount() async {
    final saveAccount = SaveAccount();
    await saveAccount.init();
    return saveAccount;
  }

  String get email => _email ?? "";

  String get pass => _pass ?? "";

  bool get isCheckedSave => _isCheckedSave ?? false;

  @override
  String toString() {
    return "info1252: ${_email} - ${_pass} - ${_isCheckedSave}";
  }
}