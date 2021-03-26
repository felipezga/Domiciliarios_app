
class LoginResponseModel {
  final String token;
  final String error;

  LoginResponseModel({this.token, this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] != null ? json["token"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'password': password.trim(),
    };

    return map;
  }
}

class User {
  int userId;
  String name;
  String email;
  String token;
  final String error;

  User({this.userId, this.name, this.email, this.token, this.error,});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        //userId: responseData["userId"] != null ? responseData["userId"] : "",
        //name: responseData["name"] != "Felipe" ? responseData["name"] : "",
        //email: responseData["email"] != null ? responseData["email"] : "",
        token: responseData["token"] != null ? responseData["token"] : "",
        error: responseData["error"] != null ? responseData["error"] : ""
    );
  }
}