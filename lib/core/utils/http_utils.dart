import 'package:http/http.dart' as http;

Future<String?> getURLContent(url) async {
  try {
    var response = await http.get(Uri.parse(url));
    return response.body;
  } catch (e) {
    return null;
  }
}
