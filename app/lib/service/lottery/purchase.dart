import 'package:http/http.dart' as http;

class Postlottery {
  Future<http.Response> getCustomerData() async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/customers'),
    );
    return response;
  }
}
/* int pid
  int cid
  intlid
  created
  update
*/ 