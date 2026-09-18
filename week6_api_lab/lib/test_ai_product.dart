import 'services/ai_product_service.dart';

void main() async {
  try {
    print('กำลังโหลดข้อมูลสินค้าทั้งหมด...');
    List<AiProduct> products = await fetchAiProducts();
    print('✅ โหลดข้อมูลสำเร็จ: ${products.length} รายการ');
    for (var i = 0; i < 3; i++) {
      print('${i + 1}. ${products[i].title} - \$${products[i].price}');
    }
    print('... (แสดงแค่ 3 รายการแรก)');
  } catch (error) {
    print('❌ Error: $error'); 
  }
}
