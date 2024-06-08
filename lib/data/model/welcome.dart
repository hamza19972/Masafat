class welcomeModle {
  int? userId;
  String? userName;
  String? userSurename;
  String? userPhone;
  String? userGender;
  String? userCreatetime;
  String? userOtp;
  String? userApproved;

  welcomeModle(
      {this.userId,
      this.userName,
      this.userSurename,
      this.userPhone,
      this.userGender,
      this.userCreatetime,
      this.userOtp,
      this.userApproved});

  welcomeModle.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userSurename = json['user_surename'];
    userPhone = json['user_phone'];
    userGender = json['user_gender'];
    userCreatetime = json['user_createtime'];
    userOtp = json['user_otp'];
    userApproved = json['user_approved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_surename'] = this.userSurename;
    data['user_phone'] = this.userPhone;
    data['user_gender'] = this.userGender;
    data['user_createtime'] = this.userCreatetime;
    data['user_otp'] = this.userOtp;
    data['user_approved'] = this.userApproved;
    return data;
  }
}
