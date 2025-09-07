class AppConfig {
  final String baseUrl = "10.0.2.2:3000";
  final String jwtSecret = "locatto_secret_key";
  final String tokenStorageName = "LottocatToken";

  String getBaseUrl() {
    return baseUrl;
  }

  String getJwtSecret() {
    return jwtSecret;
  }

  String getTokenStoragename() {
    return tokenStorageName;
  }
}
