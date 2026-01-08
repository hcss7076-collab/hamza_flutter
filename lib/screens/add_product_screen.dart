import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String _productName = '';
  String _price = '';
  String _description = '';
  String _category = '';
  int _quantity = 0;
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('حدث خطأ في اختيار الصورة')));
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر مصدر الصورة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('الكاميرا'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('المعرض'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إضافة منتج جديد',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // صورة المنتج
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'إضافة صورة المنتج',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // اسم المنتج
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'اسم المنتج',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'أدخل اسم المنتج' : null,
                onSaved: (value) => _productName = value!,
              ),

              const SizedBox(height: 16),

              // السعر
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'السعر (ريال يمني)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'أدخل السعر';
                  }
                  if (double.tryParse(value) == null) {
                    return 'سعر غير صالح';
                  }
                  return null;
                },
                onSaved: (value) => _price = value!,
              ),

              const SizedBox(height: 16),

              // الوصف
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'الوصف',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
              ),

              const SizedBox(height: 16),

              // التصنيف
              DropdownButtonFormField<String>(
                value: _category.isEmpty ? null : _category,
                items: const [
                  DropdownMenuItem(
                    value: 'مواد غذائية',
                    child: Text('مواد غذائية'),
                  ),
                  DropdownMenuItem(
                    value: 'مواد تنظيف',
                    child: Text('مواد تنظيف'),
                  ),
                  DropdownMenuItem(value: 'مشروبات', child: Text('مشروبات')),
                  DropdownMenuItem(value: 'أخرى', child: Text('أخرى')),
                ],
                onChanged: (value) => setState(() => _category = value ?? ''),
                validator: (value) =>
                    value == null || value.isEmpty ? 'اختر التصنيف' : null,
                decoration: const InputDecoration(
                  labelText: 'التصنيف',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // الكمية
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'الكمية',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'أدخل الكمية';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'كمية غير صالحة';
                  }
                  return null;
                },
                onSaved: (value) => _quantity = int.parse(value!),
              ),

              const SizedBox(height: 24),

              // زر الحفظ
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Navigator.pop(context, {
                      'name': _productName,
                      'price': _price,
                      'description': _description,
                      'category': _category,
                      'quantity': _quantity,
                      'imagePath': _imageFile?.path,
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'حفظ المنتج',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
