class ApiEndpoints {
  static const _auth = '/auth';
  static const _credits = '/credits';
  static const _images = '/images';
  static const _profile = '/profile';

  // Auth endpoints
  static const signUp = '$_auth/signup';
  static const signIn = '$_auth/signin';
  static const signOut = '$_auth/signout';
  static const resetPassword = '$_auth/reset-password';

  // User endpoints
  static const getProfile = '$_profile';
  static const updateProfile = '$_profile/update';
  static const deleteProfile = '$_profile/delete';

  // Credit endpoints
  static const creditBalance = '$_credits/balance';
  static const purchaseCredits = '$_credits/purchase';
  static const creditHistory = '$_credits/history';

  // Image endpoints
  static const generateImage = '/generate-image-openai';
  static const checkImageStatus = '/check-image-status';
  static const userImages = '$_images?user_images=true';
  static const allImages = _images;
  static const imageDetails = _images; // ?id=<image_id>
}
