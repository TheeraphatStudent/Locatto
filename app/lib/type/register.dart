class Register {
    String fullname;
    String telno;
    String cardId;
    String email;
    String img;
    String username;
    String password;
    String credit;

    Register({
        required this.fullname,
        required this.telno,
        required this.cardId,
        required this.email,
        required this.img,
        required this.username,
        required this.password,
        required this.credit,
    });

    Map<String, dynamic> toJson() {
        return {
            'fullname': fullname,
            'telno': telno,
            'cardId': cardId,
            'email': email,
            'img': img,
            'username': username,
            'password': password,
            'credit': credit,
        };
    }
}
