import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'profile_model.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  XFile? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const Color _navy = Color(0xFF0F3F7F);
  static const BorderRadius _fieldRadius = BorderRadius.all(Radius.circular(8));

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileModel>();
    _nameController.text = profile.name;
    _numberController.text = profile.phoneNumber;
  }

  Future<void> _changeProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _updateProfile() async {
    final currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) {
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirm Update'),
          content: const Text('Do you want to save these profile changes?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (confirmed == true) {
      final String name = _nameController.text.trim();
      final String number = _numberController.text.trim();
      context.read<ProfileModel>().updateProfile(
            name: name.isEmpty ? null : name,
            phoneNumber: number.isEmpty ? null : number,
            photoPath: _selectedImage?.path,
          );
      if (mounted) Navigator.of(context).pop();
    }
  }

  InputDecoration _fieldDecoration({String? label, Widget? prefix}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF6F7FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      prefixIcon: prefix,
      border: OutlineInputBorder(
        borderRadius: _fieldRadius,
        borderSide: const BorderSide(color: _navy, width: 2),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: _fieldRadius,
        borderSide: BorderSide(color: _navy, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: _fieldRadius,
        borderSide: BorderSide(color: _navy, width: 2.4),
      ),
      labelStyle: const TextStyle(color: Color(0xFFB4B4B8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE5E7EB)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar with camera overlay
                SizedBox(
                  height: 125,
                  width: 125,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: _selectedImage != null
                              ? FileImage(File(_selectedImage!.path))
                              : context.watch<ProfileModel>().avatarImage,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 6,
                        bottom: 8,
                        child: InkWell(
                          onTap: _changeProfilePicture,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E7EB),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, size: 18, color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: _fieldDecoration(label: 'Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Mobile field (+63 prefix)
                TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: _fieldDecoration(
                    label: 'Mobile Number',
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('+63', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 20,
                            child: const VerticalDivider(width: 1.5, thickness: 1.5, color: _navy),
                          ),
                        ],
                      ),
                    ),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Please enter your mobile number';
                    if (!RegExp(r'^\d{10}$').hasMatch(text)) {
                      return 'Enter exactly 10 digits (PH mobile)';
                    }
                    if (!text.startsWith('9')) {
                      return 'PH mobiles after +63 must start with 9';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: _navy,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Update', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}
