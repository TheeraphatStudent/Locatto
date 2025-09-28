import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';
import '../config.dart';

class UploadService {
  final AppConfig config = AppConfig();

  Future<Map<String, dynamic>> uploadFile(String? filePath, Uint8List? bytes, String fileName) async {
    var uri = Uri.http(config.getBaseUrl(), '/upload');
    var request = http.MultipartRequest('POST', uri);

    if (bytes != null) {
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
    } else if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath, filename: fileName));
    } else {
      throw Exception('No file provided');
    }

    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      try {
        var jsonData = json.decode(responseData);
        return jsonData;
      } catch (e) {
        return {'message': 'Upload successful', 'data': responseData};
      }
    } else {
      var errorData = await response.stream.bytesToString();
      throw Exception('Upload failed with status ${response.statusCode}: $errorData');
    }
  }
}