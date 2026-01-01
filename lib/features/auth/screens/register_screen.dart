import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/screens/main_screen.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _selectedGender;
  String? _selectedAgeRange;

  final List<String> _genders = ['Men', 'Women'];
  final List<String> _ageRanges = ['18-24', '25-34', '35-44', '45-54', '55+'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Crear Cuenta',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.408,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // First Name
                    TextFormField(
                      controller: _firstNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Tu nombre',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    TextFormField(
                      controller: _lastNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Apellido',
                        hintText: 'Tu apellido',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El apellido es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                        hintText: 'tu@email.com',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El email es requerido';
                        }
                        if (!value.contains('@')) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    Consumer(
                      builder: (context, ref, _) {
                        final error = ref.watch(authErrorProvider);
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            hintText: 'Mínimo 8 caracteres',
                            errorText: error,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La contraseña es requerida';
                            }
                            if (value.length < 8) {
                              return 'Mínimo 8 caracteres';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Gender Selection
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Género',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _genders.map((gender) {
                        final isSelected = _selectedGender == gender;
                        final genderSpanish = gender == 'Men' ? 'Hombre' : 'Mujer';
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: gender == _genders.first ? 8 : 0,
                            ),
                            child: FilterChip(
                              label: Text(genderSpanish),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedGender = selected ? gender : null;
                                });
                              },
                              backgroundColor: theme.colorScheme.surface,
                              selectedColor: theme.colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Age Range Selection
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Rango de Edad',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedAgeRange,
                      decoration: const InputDecoration(
                        labelText: 'Selecciona tu rango de edad',
                      ),
                      items: _ageRanges.map((ageRange) {
                        return DropdownMenuItem(
                          value: ageRange,
                          child: Text(ageRange),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedAgeRange = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 49,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Continuar'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Login Link
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: -0.408,
                            ),
                            children: [
                              const TextSpan(text: "¿Ya tienes cuenta? "),
                              TextSpan(
                                text: 'Iniciar Sesión',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona tu género')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await ref.read(authProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          gender: _selectedGender?.toLowerCase(),
          ageRange: _selectedAgeRange,
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      // Navegar al MainScreen con menú de navegación y limpiar el stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
        (route) => false,
      );
    }
  }
}
