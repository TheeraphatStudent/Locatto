import 'package:http/http.dart' as http;

class CustomerGetData { 
  Future<http.Response> getCustomerData() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/customers'));
    return response;
  }
}