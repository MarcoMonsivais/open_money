class User {
  final bool success;
  final String accessToken;
  final String? data;

  const User({
    required this.success,
    required this.accessToken,
    this.data,
  });

  factory User.fromJson(Map<String, dynamic> json) {

    String accessTMP = '', dataTMP = '';
    bool successTMP = false;

    try {
      accessTMP = json['access_token'];
      successTMP = json['success'];
    } catch(onError){
      print(onError);
    }

    try {
      dataTMP = json['data'];
    } catch(onError){
      print(onError);
    }

    return User(
      success: successTMP,
      accessToken: accessTMP,
      data: dataTMP
    );
  }
}