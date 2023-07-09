import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();
  late SharedPreferences _prefs;

  factory UserPreferences() => _instance;

  UserPreferences._internal();

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get token => _prefs.getString('token') ?? '';
  String get id => _prefs.getString('id') ?? '';
  String get email => _prefs.getString('email') ?? '';
  String get password => _prefs.getString('password') ?? '';
  String get name => _prefs.getString('name') ?? '';
  String get ci => _prefs.getString('ci') ?? '';
  String get address => _prefs.getString('address') ?? '';
  String get phone => _prefs.getString('phone') ?? '';
  String get photo => _prefs.getString('photo') ?? '';
  String get personId => _prefs.getString('personId') ?? '';

  String get lastPasswordChange => _prefs.getString('lastPasswordChange') ?? '';

  set token(String token) => _prefs.setString('token', token);
  set id(String id) => _prefs.setString('id', id);
  set email(String email) => _prefs.setString('email', email);
  set password(String password) => _prefs.setString('password', password);
  set name(String name) => _prefs.setString('name', name);
  set ci(String ci) => _prefs.setString('ci', ci);
  set address(String address) => _prefs.setString('address', address);
  set phone(String phone) => _prefs.setString('phone', phone);
  set photo(String photo) => _prefs.setString('photo', photo);
  set personId(String personId) => _prefs.setString('personId', personId);

  set lastPasswordChange(String lastPasswordChange) =>
      _prefs.setString('lastPasswordChange', lastPasswordChange);

  // void setUser(
  //     {required String? email,
  //     required String? name,
  //     required String? photo,
  //     required String? token}) {
  //   _prefs.setString('email', email ?? '');
  //   _prefs.setString('name', name ?? '');
  //   _prefs.setString('photo', photo ?? '');
  //   _prefs.setString('token', token ?? '');
  // }

  static void saveUserPreferences(Map<String, dynamic> dataMap) {
    final prefs = UserPreferences();

    prefs.token = dataMap['token'];
    prefs.id = dataMap['_id'];
    prefs.email = dataMap['email'];
    prefs.name = dataMap['name'];
    prefs.ci = dataMap['ci'];
    prefs.address = dataMap['address'];
    prefs.phone = dataMap['phone'];
    prefs.photo = dataMap['photo'];
    prefs.personId = dataMap['personId'];
    prefs.lastPasswordChange =
        DateTime.parse(dataMap['lastPasswordChange']).toLocal().toString();

    prefs.password = dataMap['password'];
  }

  void clearUser() {
    _prefs.setString('token', '');
    _prefs.setString('id', '');
    _prefs.setString('email', '');
    _prefs.setString('name', '');
    _prefs.setString('ci', '');
    _prefs.setString('address', '');
    _prefs.setString('phone', '');
    _prefs.setString('photo', '');
    _prefs.setString('password', '');
    _prefs.setString('personId', '');
  }
}
