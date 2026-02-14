import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/models/recipe.dart';
import '../../core/mock/mock_recipes.dart';
import '../recipe/recipe_detail_page.dart';

class FoodRoulettePage extends StatefulWidget {
  const FoodRoulettePage({super.key});

  @override
  State<FoodRoulettePage> createState() => _FoodRoulettePageState();
}

class _FoodRoulettePageState extends State<FoodRoulettePage> {
  static const primaryGreen = Color(0xFF60EB73);
  
  // 1. ดึงรายการ Recipe จาก mockRecipeList ที่คุณสร้างไว้
  final List<Recipe> recipes = mockRecipeList;

  // 2. Controller สำหรับ Slot Machine
  final FixedExtentScrollController _controller = FixedExtentScrollController();
  bool _isSpinning = false;

  void _spin() {
    if (_isSpinning || recipes.isEmpty) return;

    setState(() => _isSpinning = true);

    // สุ่มหาเป้าหมาย
    int randomTargetIndex = Random().nextInt(recipes.length);
    int currentItem = _controller.selectedItem;

    // คำนวณให้หมุนจาก "บนลงล่าง" (ค่า Index ลดลง)
    int lapCount = 25; // จำนวนรอบที่หมุน
    int totalItems = currentItem - (recipes.length * lapCount) - randomTargetIndex;

    _controller.animateToItem(
      totalItems,
      duration: const Duration(seconds: 5),
      curve: Curves.decelerate, // หมุนแบบค่อยๆ ช้าลงตอนจบ
    ).then((_) {
      setState(() => _isSpinning = false);
      
      // แสดงผลลัพธ์เป็น Object Recipe
      _showResultDialog(recipes[randomTargetIndex]);
    });
  }

  void _showResultDialog(Recipe recipe) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการกดปิดสุ่มสี่สุ่มห้าขณะแอปประมวลผล
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Destiny has spoken!", textAlign: TextAlign.center),
        
        // 1. ต้องใส่ MainAxisSize.min เพื่อให้ Column หดตัวตามเนื้อหา ไม่พยายามขยายเต็มจอ
        content: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            // 2. หุ้ม Image ด้วย Container หรือ SizedBox และระบุขนาดให้ชัดเจน
            Container(
              width: 200,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade200, // สีสำรองระหว่างรอรูปโหลด
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                // 3. ใส่ loadingBuilder เพื่อป้องกัน Error ตอนรูปกำลังโหลด
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.restaurant, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              recipe.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Category: ${recipe.category}",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Column(
            children: [
              // 1. ปุ่มใหม่: พาไปหน้ารายละเอียดสูตรอาหาร
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: primaryGreen),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // ปิด Dialog ก่อนแล้วค่อยไปหน้าถัดไป
                    Navigator.pop(context); 
                    
                    // 🚀 Navigator ไปหน้า RecipeDetailPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(recipe: recipe),
                      ),
                    );
                  },
                  icon: const Icon(Icons.menu_book, color: Colors.black),
                  label: const Text(
                    "View Recipe Details", 
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              
              const SizedBox(height: 8), // เว้นระยะห่างระหว่างปุ่ม

              // 2. ปุ่มเดิม: ปุ่ม Perfect! (ตกลง)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Perfect!", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // คำนวณความกว้างหน้าจอ - 30
    double rouletteWidth = MediaQuery.of(context).size.width - 30;

    // เช็ค
    if (recipes.isEmpty) {
      return const Scaffold(body: Center(child: Text("No recipes found!")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("The Destiny Menu"),
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center( // 👈 1. หุ้มด้วย Center เพื่อคุมตำแหน่งแนวนอน
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 👈 2. จัดกลางแนวตั้ง (หรือใช้ Spacer แบบเดิมก็ได้)
          crossAxisAlignment: CrossAxisAlignment.center, // 👈 3. จัดกลางแนวนอนของทุก Widget ใน Column
          children: [
            // เปลี่ยนจาก SizedBox เป็น Spacer หรือ Padding ที่เท่ากับด้านล่างเพื่อให้สมดุล
            const SizedBox(height: 60), 
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "UNVEIL YOUR\nCULINARY FATE", // ตามที่ปรับ 2 บรรทัด
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Use destiny to show your menu",
              style: TextStyle(color: Colors.grey, fontSize: 16, fontStyle: FontStyle.italic),
            ),

            const Spacer(), // 👈 ดัน Slot Machine ไว้ตรงกลาง

            // 🎰 Rectangle Roulette
            _buildRouletteBox(rouletteWidth), // แยก Widget ออกมาให้ Code สะอาดขึ้น

            const Spacer(), // 👈 ดันปุ่มลงไปด้านล่าง

            // ปุ่ม Spin
            Padding(
              padding: const EdgeInsets.only(bottom: 60), // 👈 ปรับให้เท่ากับข้างบน (60) จะดูสมดุลมาก
              child: ElevatedButton(
                onPressed: _spin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSpinning ? Colors.grey : primaryGreen,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                  elevation: 6,
                ),
                child: Text(
                  _isSpinning ? "SPINNING..." : "LET'S SPIN!",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // ถ้าชื่อยาวให้มีจุดไข่ปลา
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 🎰 Widget สำหรับตัวกล่อง Slot Machine
  Widget _buildRouletteBox(double width) {
    return Container(
      height: 250,
      width: width, // รับค่าความกว้างที่คำนวณมา (MediaQuery - 30)
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primaryGreen, width: 4),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 2,
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. ส่วนของรายการเมนูที่หมุนวน
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: 70, // ความสูงของแต่ละเมนู
            physics: const FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildLoopingListDelegate(
              children: recipes.map((r) => _buildMenuItem(r.title)).toList(),
            ),
          ),
          
          // 2. แถบไฮไลต์เป้าหมายตรงกลาง (Overlay)
          IgnorePointer(
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.1),
                border: const Border.symmetric(
                  horizontal: BorderSide(color: primaryGreen, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}