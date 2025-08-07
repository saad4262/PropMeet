
// import 'dart:convert';
// import 'dart:io';

// import 'package:http/http.dart' as http;
// import 'package:propmeet/shared/utils/api_handler.dart';

// class ApiService {
//   static Future<List<dynamic>?> fetchPosts() async {
//     return await ApiHandler.safeApiCall(() async {
//       final response = await http
//           .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
//           .timeout(Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw HttpException('Failed to load posts');
//       }
//     });
//   }
// }
