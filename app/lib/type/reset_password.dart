class ResetPassowrd {
    String username;
    String password;
    String repeatPassword;

    ResetPassowrd({
        required this.username,
        required this.password,
        required this.repeatPassword,
    });

    Map<String, dynamic> toJson() {
        return {
            'username': username,
            'password': password,
            'repeatPassword': repeatPassword,
        };
    }
}
