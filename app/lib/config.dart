class AppConfig {
  // final String baseUrl = "10.0.2.2:3000";
  final String baseUrl = "locatto-67775182631.europe-west1.run.app";
  final String jwtSecret = "locatto_secret_key";
  final String tokenStorageName = "LottocatToken";
  final String userIdStorage = "user_id";

  String getBaseUrl() {
    return baseUrl;
  }

  String getJwtSecret() {
    return jwtSecret;
  }

  String getTokenStoragename() {
    return tokenStorageName;
  }

  String getUserIdStorage() {
    return userIdStorage;
  }
}
