import 'package:http/http.dart' as http;

class Delete {
  Future<http.Response> getCustomerData() async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/api/customers'),
    );
    return response;
  }
}
