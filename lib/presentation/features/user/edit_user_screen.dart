import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../data/datasources/api_client.dart';
import '../../../data/models/user.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/utils/responsive_utils.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;
  late final TextEditingController _streetController;
  late final TextEditingController _numberController;
  late final TextEditingController _zipController;
  late final TextEditingController _latController;
  late final TextEditingController _longController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _emailController = TextEditingController(text: u.email);
    _usernameController = TextEditingController(text: u.username);
    _passwordController = TextEditingController(text: u.password);
    _firstNameController = TextEditingController(text: u.name.firstname);
    _lastNameController = TextEditingController(text: u.name.lastname);
    _phoneController = TextEditingController(text: u.phone);
    _cityController = TextEditingController(text: u.address.city);
    _streetController = TextEditingController(text: u.address.street);
    _numberController =
        TextEditingController(text: u.address.number.toString());
    _zipController = TextEditingController(text: u.address.zipcode);
    _latController = TextEditingController(text: u.address.geolocation.lat);
    _longController = TextEditingController(text: u.address.geolocation.long);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _zipController.dispose();
    _latController.dispose();
    _longController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final api = getIt<ApiClient>();
      final updated = await api.updateUser(
        widget.user.id,
        User(
          id: widget.user.id,
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          name: Name(
            firstname: _firstNameController.text.trim(),
            lastname: _lastNameController.text.trim(),
          ),
          phone: _phoneController.text.trim(),
          address: Address(
            city: _cityController.text.trim(),
            street: _streetController.text.trim(),
            number: int.tryParse(_numberController.text.trim()) ?? 0,
            zipcode: _zipController.text.trim(),
            geolocation: GeoLocation(
              lat: _latController.text.trim(),
              long: _longController.text.trim(),
            ),
          ),
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully')),
      );
      Navigator.of(context).pop<User>(updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing16 =
        ResponsiveUtils.getResponsiveSpacing(context, AppDimensions.spacing16);
    final spacing12 =
        ResponsiveUtils.getResponsiveSpacing(context, AppDimensions.spacing12);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Section(title: 'Account'),
              _LabeledField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress),
              SizedBox(height: spacing12),
              _LabeledField(label: 'Username', controller: _usernameController),
              SizedBox(height: spacing12),
              _LabeledField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true),
              SizedBox(height: spacing16),
              _Section(title: 'Profile'),
              _LabeledField(
                  label: 'First name', controller: _firstNameController),
              SizedBox(height: spacing12),
              _LabeledField(
                  label: 'Last name', controller: _lastNameController),
              SizedBox(height: spacing12),
              _LabeledField(
                  label: 'Phone',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone),
              SizedBox(height: spacing16),
              _Section(title: 'Address'),
              _LabeledField(label: 'City', controller: _cityController),
              SizedBox(height: spacing12),
              _LabeledField(label: 'Street', controller: _streetController),
              SizedBox(height: spacing12),
              _LabeledField(
                  label: 'Number',
                  controller: _numberController,
                  keyboardType: TextInputType.number),
              SizedBox(height: spacing12),
              _LabeledField(label: 'Zipcode', controller: _zipController),
              SizedBox(height: spacing12),
              Row(
                children: [
                  Expanded(
                      child: _LabeledField(
                          label: 'Lat', controller: _latController)),
                  SizedBox(width: spacing12),
                  Expanded(
                      child: _LabeledField(
                          label: 'Long', controller: _longController)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  const _LabeledField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.productBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Required';
            }
            return null;
          },
        ),
      ],
    );
  }
}
