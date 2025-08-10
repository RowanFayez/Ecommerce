import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../data/datasources/api_client.dart';
import '../../../data/models/user.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/services/local_user_store.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController(text: '0');
  final _zipController = TextEditingController();
  final _latController = TextEditingController(text: '0');
  final _longController = TextEditingController(text: '0');

  bool _saving = false;

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
    setState(() => _saving = true);
    try {
      final api = getIt<ApiClient>();
      final newUser = User(
        id: 0,
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
      );

      final created = await api.signup(newUser);

      // Store locally to allow dataset-fallback login
      getIt<LocalUserStore>().add(created);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User created')),
      );
      Navigator.of(context).pop<User>(created);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
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
        title: const Text('Create User'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _L(
                  label: 'Email',
                  c: _emailController,
                  type: TextInputType.emailAddress),
              SizedBox(height: spacing12),
              _L(label: 'Username', c: _usernameController),
              SizedBox(height: spacing12),
              _L(label: 'Password', c: _passwordController, obscure: true),
              SizedBox(height: spacing16),
              _L(label: 'First name', c: _firstNameController),
              SizedBox(height: spacing12),
              _L(label: 'Last name', c: _lastNameController),
              SizedBox(height: spacing12),
              _L(
                  label: 'Phone',
                  c: _phoneController,
                  type: TextInputType.phone),
              SizedBox(height: spacing16),
              _L(label: 'City', c: _cityController),
              SizedBox(height: spacing12),
              _L(label: 'Street', c: _streetController),
              SizedBox(height: spacing12),
              _L(
                  label: 'Number',
                  c: _numberController,
                  type: TextInputType.number),
              SizedBox(height: spacing12),
              _L(label: 'Zipcode', c: _zipController),
              SizedBox(height: spacing12),
              Row(
                children: [
                  Expanded(child: _L(label: 'Lat', c: _latController)),
                  SizedBox(width: spacing12),
                  Expanded(child: _L(label: 'Long', c: _longController)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _L extends StatelessWidget {
  final String label;
  final TextEditingController c;
  final TextInputType? type;
  final bool obscure;
  const _L(
      {required this.label, required this.c, this.type, this.obscure = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: c,
          keyboardType: type,
          obscureText: obscure,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.productBackground,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
