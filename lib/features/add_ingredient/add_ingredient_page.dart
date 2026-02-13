import 'package:flutter/material.dart';

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

  final List<String> _categories = ["Protein", "Carbohydrate", "Vegetable", "Fruit", "Drink", "Other"];

  void _setQuickExpiry(int days) {
    setState(() {
      _expiryDate = DateTime.now().add(Duration(days: days));
    });
    // สั่ง validate ใหม่เพื่อลบสีแดงออกทันทีที่เลือก
    _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    // ดึงค่าสี Error มาตรฐานของ Theme มาใช้เพื่อให้แดงเหมือนกันเป๊ะ
    final errorColor = Theme.of(context).colorScheme.error;
    final errorStyle = TextStyle(color: errorColor, fontSize: 12);

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
              const Text("Ingredient name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              // 1. Name Field
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

              // 2. Category Field
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
                            menuHeight: 300,
                            inputDecorationTheme: InputDecorationTheme(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              // ปรับขอบให้เป็นสีแดงตามสถานะ state.hasError
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: state.hasError ? errorColor : Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: state.hasError ? errorColor : Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: state.hasError ? errorColor : primaryGreen, width: 2),
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

              // 3. Expiry Date Field
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

              // 4. Quick Select
              const Text("Don't know expiry date? Quick select:", 
                style: TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _quickDateBtn("None", 0),
                ],
              ),

              const SizedBox(height: 40),

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
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickDateBtn(String label, int days) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.green.shade700,
        side: BorderSide(color: Colors.green.shade200),
      ),
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
      // บันทึกข้อมูลได้เมื่อผ่าน Validation ทั้งหมด (ชื่อ, ประเภท, และวันหมดอายุอย่างใดอย่างหนึ่ง)
      Navigator.pop(context);
    }
  }
}