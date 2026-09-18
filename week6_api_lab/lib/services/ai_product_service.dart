import 'dart:convert';
import 'dart:async';
import 'dart:io'; // จำเป็นต้องใช้สำหรับ SocketException
import 'package:http/http.dart' as http;

// --- ส่วนที่ 1: Model Class ---
class AiProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  AiProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      // ใช้ num แล้ว toDouble() เพื่อป้องกัน error หาก API ส่งมาเป็น int ในบางครั้ง
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

// --- ส่วนที่ 2: ฟังก์ชันสำหรับดึงข้อมูล ---

/// ดึงรายการสินค้าทั้งหมด (List)
Future<List<AiProduct>> fetchAiProducts() async {
  final url = Uri.parse('https://fakestoreapi.com/products');
  try {
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);
      return decodedData.map((item) => AiProduct.fromJson(item)).toList();
    } else {
      throw 'เซิร์ฟเวอร์ตอบกลับผิดพลาด (รหัส: ${response.statusCode})';
    }
  } on TimeoutException {
    throw 'การเชื่อมต่อใช้เวลานานเกินไป กรุณาลองใหม่อีกครั้ง';
  } on SocketException {
    throw 'ไม่สามารถเข้าถึงอินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อของท่าน';
  } on http.ClientException {
    throw 'เครือข่ายขัดข้อง ไม่สามารถดึงข้อมูลได้';
  } on FormatException {
    throw 'รูปแบบข้อมูลจากเซิร์ฟเวอร์ไม่ถูกต้อง';
  } catch (e) {
    throw 'เกิดข้อผิดพลาดที่ไม่คาดคิด: $e';
  }
}

/// ดึงข้อมูลสินค้าเพียงรายการเดียวตาม ID
Future<AiProduct> fetchAiProductById(int id) async {
  final url = Uri.parse('https://fakestoreapi.com/products/$id');
  
  try {
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final dynamic decodedData = jsonDecode(response.body);
      if (decodedData == null) {
        throw 'ไม่พบข้อมูลสินค้าชิ้นนี้';
      }
      return AiProduct.fromJson(decodedData);
    } else if (response.statusCode == 404) {
      throw 'ไม่พบสินค้าที่ท่านระบุ (404 Not Found)';
    } else {
      throw 'เซิร์ฟเวอร์ตอบกลับผิดพลาด (รหัส: ${response.statusCode})';
    }
  } on TimeoutException {
    throw 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง';
  } on SocketException {
    throw 'กรุณาตรวจสอบอินเทอร์เน็ตของท่าน';
  } on http.ClientException {
    throw 'การเชื่อมต่อกับเซิร์ฟเวอร์ผิดพลาด';
  } on FormatException {
    throw 'ข้อมูลสินค้ามีรูปแบบไม่ถูกต้อง';
  } catch (e) {
    throw 'ไม่สามารถโหลดข้อมูลสินค้าได้: $e';
  }
}
