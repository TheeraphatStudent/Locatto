class AppConfig {
  final String baseUrl = "127.0.0.1:3000";
  final String jwtSecret = "locatto_secret_key";

  String getBaseUrl() {
    return baseUrl;
  }

  String getJwtSecret() {
    return jwtSecret;
  }
}
