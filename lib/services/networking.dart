import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper({required this.url, this.parameters});

  final String url;
  final Map<String, dynamic>? parameters;

  Future getData([String? token]) async {

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token' ;
    }

    http.Response response = await http.get(Uri.parse(url).replace(queryParameters: parameters),
      headers: headers,
    );
    String data = response.body;
    var decodedData = jsonDecode(data);
    return decodedData;
  }

  Future postData([String? token]) async {

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token' ;
    }

    http.Response response = await http.post(Uri.parse(url),
      body: jsonEncode(parameters),
      headers: headers,
    );

    String data = response.body;
    var decodedData = jsonDecode(data);
    return decodedData;
  }

  Future putData([String? token]) async {

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token' ;
    }

    http.Response response = await http.put(Uri.parse(url),
      body: jsonEncode(parameters),
      headers: headers,
    );

    String data = response.body;
    var decodedData = jsonDecode(data);
    return decodedData;
  }

  Future deleteData([String? token]) async {

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token' ;
    }

    http.Response response = await http.delete(Uri.parse(url),
        body: jsonEncode(parameters),
        headers: headers);

    String data = response.body;
    var decodedData = jsonDecode(data);
    return decodedData;
  }

  Future patchData([String? token]) async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token' ;
    }

    http.Response response = await http.patch(Uri.parse(url),
        body: jsonEncode(parameters),
        headers: headers);

    String data = response.body;
    var decodedData = jsonDecode(data);
    return decodedData;
  }
}