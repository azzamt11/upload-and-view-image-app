import 'dart:convert';
import 'dart:typed_data';

class Functions {

  Uint8List convertBase64Image(String base64String) {
    Uint8List bytes= const Base64Decoder().convert(base64String.split(',').last);
    return bytes;
  }

  Uint8List convertStringToUin8List(String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    return unit8List;
  }

  String convertUin8ListToString(Uint8List uin8list) {
    return String.fromCharCodes(uin8list);
  }


}