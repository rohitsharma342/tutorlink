import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../models/user.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/language_switcher.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../dashboard/dashboard_screen.dart';

class LoginRegistrationScreen extends StatefulWidget {
  const LoginRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<LoginRegistrationScreen> createState() => _LoginRegistrationScreenState();
}

class _LoginRegistrationScreenState extends State<LoginRegistrationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _otpController = TextEditingController();
  
  bool _isLoading = false;
  bool _showOtpField = false;
  bool _acceptedTerms = false;
  UserRole _selectedRole = UserRole.student;
  UserGender _selectedGender = UserGender.male;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Directionality(
      textDirection: languageProvider.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: LanguageSwitcher(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildHeader(localization),
              const SizedBox(height: 40),
              _buildTabBar(localization),
              const SizedBox(height: 20),
              _buildTabBarView(localization),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localization) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.school,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          localization.translate('welcome_back'),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          localization.translate('sign_in_continue'),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(AppLocalizations localization) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        tabs: [
          Tab(text: localization.translate('login')),
          Tab(text: localization.translate('register')),
        ],
      ),
    );
  }

  Widget _buildTabBarView(AppLocalizations localization) {
    return SizedBox(
      height: 600,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildLoginForm(localization),
          _buildRegistrationForm(localization),
        ],
      ),
    );
  }

  Widget _buildLoginForm(AppLocalizations localization) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            labelText: localization.translate('email'),
            prefixIcon: Icons.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localization.translate('email_required');
              }
              if (!RegExp(r'^[\w-\.]+@[\w-]+\.[a-z]{2,4}\$').hasMatch(value)) {
                return localization.translate('invalid_email');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            labelText: localization.translate('password'),
            prefixIcon: Icons.lock,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localization.translate('password_required');
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: localization.translate('sign_in'),
            onPressed: _isLoading ? null : _handleLogin,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 20),
          _buildDivider(localization),
          const SizedBox(height: 20),
          _buildGoogleSignInButton(localization),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm(AppLocalizations localization) {
    return Form(
      child: Column(
        children: [
          CustomTextField(
            controller: _nameController,
            labelText: localization.translate('full_name'),
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _emailController,
            labelText: localization.translate('email'),
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _phoneController,
            labelText: localization.translate('phone_number'),
            prefixIcon: Icons.phone,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            labelText: localization.translate('password'),
            prefixIcon: Icons.lock,
            isPassword: true,
          ),
          const SizedBox(height: 16),
          _buildRoleSelector(localization),
          const SizedBox(height: 16),
          _buildGenderSelector(localization),
          const SizedBox(height: 16),
          if (_showOtpField) _buildOtpField(localization),
          _buildTermsCheckbox(localization),
          const SizedBox(height: 24),
          CustomButton(
            text: localization.translate('create_account'),
            onPressed: _isLoading || !_acceptedTerms ? null : _handleRegistration,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector(AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate('select_role'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<UserRole>(
                title: Text(localization.translate('student')),
                value: UserRole.student,
                groupValue: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ),
            Expanded(
              child: RadioListTile<UserRole>(
                title: Text(localization.translate('tutor')),
                value: UserRole.tutor,
                groupValue: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderSelector(AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate('gender'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<UserGender>(
                title: Text(localization.translate('male')),
                value: UserGender.male,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ),
            Expanded(
              child: RadioListTile<UserGender>(
                title: Text(localization.translate('female')),
                value: UserGender.female,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpField(AppLocalizations localization) {
    return Column(
      children: [
        Text(
          localization.translate('enter_otp'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        PinCodeTextField(
          appContext: context,
          length: 6,
          onChanged: (value) {},
          controller: _otpController,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: 50,
            fieldWidth: 45,
            activeColor: AppColors.primary,
            selectedColor: AppColors.primary,
            inactiveColor: Colors.grey[300]!,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTermsCheckbox(AppLocalizations localization) {
    return Row(
      children: [
        Checkbox(
          value: _acceptedTerms,
          onChanged: (value) {
            setState(() {
              _acceptedTerms = value!;
            });
          },
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: Text(
            localization.translate('accept_terms'),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(AppLocalizations localization) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            localization.translate('or'),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildGoogleSignInButton(AppLocalizations localization) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _handleGoogleSignIn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1573804633927-bfcbcd909acd?w=24&h=24',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 12),
              Text(
                localization.translate('continue_with_google'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signInWithEmail(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_phoneController.text.isNotEmpty && !_showOtpField) {
        setState(() {
          _showOtpField = true;
          _isLoading = false;
        });
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.registerWithEmail(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _selectedRole,
        _selectedGender,
        phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signInWithGoogle();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}