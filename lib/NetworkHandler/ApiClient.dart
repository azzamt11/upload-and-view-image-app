import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {

  final String token = '1|n36pv1P4ImAuww5hJeWLgMcMpcXSZJkX3VbTChdP';

  Future<String> postImage(String imageString) async{
    print('postImage in progress');
    try {
      var response= await http.post(
        Uri.parse("http://azzam-universal-api.herokuapp.com/api/posts"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'Application/json',
        },
        body: jsonEncode({"post_body":"image post","post_type":0,"post_attribute_2":imageString, "post_attribute_3": "string"}),
      );
      var decodedResponse= json.decode(response.body);
      print(decodedResponse);
      return decodedResponse;
    } catch(error) {
      print(error);
      return '';
    }
  }

  Future<String> getImage(String id) async{
    print('getImage in progress');
    try {
      var response= await http.get(
        Uri.parse("http://azzam-universal-api.herokuapp.com/api/posts/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'Application/json',
        },
      );
      var decodedResponse= json.decode(response.body);
      String finalResponse= decodedResponse['post'][0]['post_attribute_2'].toString();
      print(decodedResponse.toString());
      return finalResponse;
    } catch(error) {
      print(error);
      return '';
    }
  }
}
