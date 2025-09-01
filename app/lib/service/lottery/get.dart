import 'package:http/http.dart' as http;

class Lotteryget {
  Future<http.Response> getCustomerData() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/customers'),
    );
    return response;
  }
}
/* int lid 
  int lottery_number
  period
  created
  update*/