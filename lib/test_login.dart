import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    print('🔵 Testing API connection...');
    print('📡 Sending request to: https://fakestoreapi.com/auth/login');
    
    final response = await http.post(
      Uri.parse('https://fakestoreapi.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': 'mor_2314',
        'password': '83r5^_',
      }),
    );
    
    print('🟢 Status Code: ${response.statusCode}');
    print('🟢 Response Body: ${response.body}');
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ SUCCESS! Login works perfectly! 🎉');
    } else {
      print('❌ Failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('🔴 ERROR: $e');
    print('❌ Network error - please check your internet connection.');
  }
}