import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static String get _apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=th');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // เพิ่มเงื่อนไขกรณี statusCode == 404
        throw Exception('ไม่พบเมืองที่คุณค้นหา กรุณาตรวจสอบชื่อเมืองอีกครั้ง');
      }
      
      // กรณี Error อื่นๆ
      throw Exception('เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ (รหัส: ${response.statusCode})');

    } on TimeoutException {
      throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
    } on http.ClientException {
      throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
    } on FormatException {
      // เพิ่มการดักจับ FormatException แยกต่างหาก
      throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ผิดรูปแบบ');
    } catch (e) {
      // ดักจับ Error ที่ไม่ได้คาดคิดอื่นๆ
      throw Exception('เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ: $e');
    }
  }
}
