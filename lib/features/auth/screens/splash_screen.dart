import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../../core/screens/main_screen.dart';
import 'login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _hasNavigated = false; // Evitar múltiples navegaciones

  @override
  void initState() {
    super.initState();
    _initAnimation();
    // Esperar 2.5 segundos y luego verificar estado
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _checkAuthStatus();
      }
    });
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
  }

  Future<void> _checkAuthStatus() async {
    if (_hasNavigated) return;

    // Leer el estado actual
    final authState = ref.read(authProvider);

    // Si aún está cargando, esperar un poco más
    if (authState.isLoading) {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
    }

    // Verificar nuevamente después de esperar
    final finalState = ref.read(authProvider);

    if (finalState.isLoading) {
      // Si después de esperar sigue cargando, esperar una vez más
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
    }

    // Leer estado final
    final state = ref.read(authProvider);

    if (_hasNavigated) return;
    _hasNavigated = true;

    if (state.isAuthenticated && state.user != null) {
      // Usuario autenticado - navegar al MainScreen con menú
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      }
    } else {
      // Usuario no autenticado - navegar al login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: child,
              ),
            );
          },
          child: _buildLogo(),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 175,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'GAGALOM',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
