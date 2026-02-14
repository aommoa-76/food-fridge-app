import 'dart:io'; // สำหรับ File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // อย่าลืม import ตัวนี้

class AddIngredientPage extends StatefulWidget {
  const AddIngredientPage({super.key});

  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  static const primaryGreen = Color(0xFF60EB73);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  
  String? _selectedCategory;
  DateTime? _expiryDate;
  
  // 📸 ตัวแปรสำหรับเก็บรูปภาพ
  File? _image; 
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = ["Protein", "Carbohydrate", "Vegetable", "Fruit", "Drink", "Other"];

  // ฟังก์ชันเลือกรูปภาพ
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // แสดง Modal เลือกแหล่งที่มาของรูป
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _setQuickExpiry(int days) {
    setState(() {
      _expiryDate = DateTime.now().add(Duration(days: days));
    });
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    final errorStyle = TextStyle(color: errorColor, fontSize: 12);

    double pictureWidth = MediaQuery.of(context).size.width - 30;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Ingredient"),
        backgroundColor: primaryGreen,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼️ ส่วนแสดงและเลือกรูปภาพ
              Center(
                child: GestureDetector(
                  onTap: () => _showImageSourceActionSheet(context),
                  child: Stack(
                    children: [
                      Container(
                        width: pictureWidth,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primaryGreen.withOpacity(0.5), width: 2),
                          image: _image != null 
                            ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover) 
                            : null,
                        ),
                        child: _image == null 
                          ? const Icon(Icons.add_a_photo, size: 40, color: Colors.green) 
                          : null,
                      ),
                      if (_image != null)
                        Positioned(
                          right: -10,
                          top: -10,
                          child: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => setState(() => _image = null),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(child: Text("Tap to add photo", style: TextStyle(color: Colors.grey, fontSize: 12))),
              
              const SizedBox(height: 20),

              const Text("Ingredient name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "e.g. eggs, milk, tomatoes",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.fastfood),
                ),
                validator: (value) => (value == null || value.isEmpty) ? "Please enter ingredient name" : null,
              ),

              const SizedBox(height: 20),

              const Text("Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              FormField<String>(
                validator: (_) => _selectedCategory == null ? "Please select a category" : null,
                builder: (FormFieldState<String> state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return DropdownMenu<String>(
                            width: constraints.maxWidth,
                            inputDecorationTheme: InputDecorationTheme(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: state.hasError ? errorColor : Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: state.hasError ? errorColor : Colors.grey),
                              ),
                            ),
                            onSelected: (val) {
                              setState(() => _selectedCategory = val);
                              state.didChange(val);
                            },
                            dropdownMenuEntries: _categories.map((cat) {
                              return DropdownMenuEntry<String>(
                                value: cat,
                                label: cat,
                                style: MenuItemButton.styleFrom(minimumSize: Size(constraints.maxWidth, 45)),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 8),
                          child: Text(state.errorText!, style: errorStyle),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text("Expiry Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              FormField<DateTime>(
                validator: (_) => _expiryDate == null ? "Please pick a date or use quick select" : null,
                builder: (FormFieldState<DateTime> state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: state.hasError ? errorColor : Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(Icons.calendar_today, color: state.hasError ? errorColor : Colors.grey),
                        title: Text(
                          _expiryDate == null ? "Select Date" : _expiryDate.toString().split(" ")[0],
                          style: TextStyle(color: state.hasError ? errorColor : Colors.black87),
                        ),
                        onTap: () async {
                          await _pickDate();
                          state.didChange(_expiryDate);
                        },
                        trailing: Icon(Icons.arrow_drop_down, color: state.hasError ? errorColor : Colors.grey),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 8),
                          child: Text(state.errorText!, style: errorStyle),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 15),

              const Text("Quick select:", style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _quickDateBtn("None", 0),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: _submitForm,
                child: const Text("SAVE TO FRIDGE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickDateBtn(String label, int days) {
    return OutlinedButton(
      onPressed: () => _setQuickExpiry(days),
      child: Text(label),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _expiryDate ?? DateTime.now(),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // เมื่อกด Save คุณสามารถเข้าถึงรูปภาพได้จากตัวแปร _image
      print("Image path: ${_image?.path}");
      Navigator.pop(context);
    }
  }
}