import 'package:dio/dio.dart';
import 'services/weather_service_dio.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  try {
    print('กำลังดึงข้อมูลด้วย Dio...');
    final weather = await fetchWeatherWithDio('Bangkok');
    print('✅ โหลดข้อมูลสำเร็จ!');
    print('cityName: ${weather.cityName}');
    print('temperature: ${weather.temperature}');
    print('description: ${weather.description}');
    print('feelsLike: ${weather.feelsLike}');
  } on Exception catch (e) {
    print('❌ Error: $e');
  }
}
