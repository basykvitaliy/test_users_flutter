enum BottomNavTabs {
  main,
  notification,
  add,
  peoples,
  profile,
}
enum SingingCharacter {
  male,
  female,
  other,
}
enum Social {
  pinterest,
  youtube,
  twitter,
  facebook,
  telegram,
  whatsapp,
  instagram,
  behance,
  linkedin,
}
enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
  error,
  firebaseError
}

class LayoutConstants {
  static const snackBarRadius = 10.0;
}

class Keys {
  static const isDarkTheme = "isDarkTheme";
}

class BaseUrl {
  static const BASE_URL = "https://reqres.in/api/";
}

class EndPoint {
  static const users = "users/";
}
