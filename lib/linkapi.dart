class AppLink {
  static const String server = "";
  static const String imageststatic = "";

//========================== Image ============================
  static const String imagestCategories = "$imageststatic/categories";
  static const String imagestItems = "$imageststatic/items";
// =============================================================
//
  static const String test = "$server/test.php";
  static const String updatename = "$server/update_name.php";

  static const String notification = "$server/notification.php";

// ================================= Auth ========================== //

  static const String signUp = "$server/auth/signup.php";
  // static const String login = "$server/auth/login.php";
  static const String welcome = "$server/auth/login.php";
  static const String otpcode = "$server/auth/otpcode.php";
  static const String resend = "$server/auth/resend.php";

  // ================================= Map ========================== //

  static const String riderequest = "$server/ride_est/add.php";
  static const String riderequestfemale = "$server/ride_est/add_female.php";
  static const String deleteride = "$server/ride_est/delete.php";
  static const String mytripuser = "$server/ride_est/mytripuser.php";
  static const String canceltrip = "$server/ride_est/canceluser.php";
  static const String driverview =
      "$server/ride_est/viewdriverforpassengare.php";

// ================================= bookingsv2 ========================== //
  static const String cites = "$server/ride_est/viewcites.php";
  static const String routes = "$server/ride_est/viewroutes.php";
  static const String trips = "$server/ride_est/viewtrips.php";
  static const String bookingsb = "$server/ride_est/bookingsb.php";
  static const String token = "$server/ride_est/token.php";
  static const String mytripsv2 = "$server/ride_est/mytripsv2.php";
  static const String canceltripv2 = "$server/ride_est/user_cancel.php";

// Home

// items

// Favorite

  // Cart

  // Address

  // Coupon

  static const String checkcoupon = "$server/coupon/checkcoupon.php";

  // Checkout
}
