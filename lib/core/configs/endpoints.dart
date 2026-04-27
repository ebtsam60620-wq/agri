class EndPoints {
  // Base URLs
  static const String baseURL = 'https://asklany-agari-backend.hf.space/v1';
  static const String webSocketBaseURL = 'https://asklany-agari-backend.hf.space/';
  static const String uploads = '/upload';
  // Auth
  static const String signup = '/auth/register';
  static const String login = '/auth/login';
  
  static const String sendOTPCode = '/auth/resend-otp';
  static const String verifyPhone = '/auth/resend-otp';

  static const String forgotPassword = '/auth/forgot-password';
  static const String passwordReset = '/auth/reset-password';

  static const String updateToken = '/auth/refresh';
  
  static const String logout = '/auth/logout';
  static const String getme = '/auth/me';
  static const String getPatient = '/patient';
  static const String getProvider = '/provider';

  static const String getTerms = '/data-management/terms-and-conditions';
  static const String getDisclaimer = '/data-management/disclaimer';

  // address
  static const String addresses = '/addresses';
  static const String addressesCoordinates = '/addresses/by-coordinates';
  // Service
  static const String searchProvider = '/users/search/nearby';
  //  auth User
  static const String userDataDetails = '/patient';
  static const String userMedications =
      '/data-management/patient-data/medications';
  static const String userChronicDiseases =
      '/data-management/patient-data/chronic-diseases';
  static const String userSurgeries = '/data-management/patient-data/surgeries';
  static const String userMedicalConditions =
      '/data-management/patient-data/medical-conditions';
  //  auth Provider
  static const String providerDataDetails = '/provider';
  static const String providerSpecialties = '/data-management/specialties';
  static const String providerCategories =
      '/data-management/provider-categories';

  // User Profile
  static const String getProfile = '';
  static const String updateProfile = '/auth/update-profile';
  static const String changePhone = '';
  static const String confirmChangePhoneOTP = '';
  static const String updateFcm = '/notifications/firebase-token';

  // /me endpoints - Personal account management
  static const String updateAvater = '/auth/me/avatar';
  static const String deleteAccount = '/auth/me/account';

  // Sessions
  static const String sessions = '/sessions';
  static String sessionsByPatient(String patientId) =>
      '/sessions/patient/$patientId';
  //wallet
  static const String balance = '/wallet/balance';
  static const String walletTransactions = '/wallet/transactions';
  static const String requestWithdraw = '/wallet/withdraw-request';

  //soket io
  static const String socketBaseURL = 'ws://75.119.138.130:3000';
  static const String socketLoction = '/location';

  //requests
  static const String requests = '/requests';

  static const String ratings = '/ratings';
  static const String favourites = '/favourites';

  // Notifications
  static const String notifications = '/notifications';
  static const String markNotificationsRead = '/notifications/mark-read';

  static const String markAllNotificationsRead = '/notifications/mark-all-read';
}
