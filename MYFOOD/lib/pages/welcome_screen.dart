import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo
              CustomPaint(
                size: const Size(120, 120),
                painter: HeartLogoWhitePainter(),
              ),
              const SizedBox(height: 24),
              // Texto MYFOOD
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'MY',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    TextSpan(
                      text: 'FOOD',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bienvenido a la mejor app de driver de nuestro\nrestaurante',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Botones
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed('/onboarding'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Iniciar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Get.toNamed('/onboarding'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    backgroundColor: AppColors.primaryLight.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class HeartLogoWhitePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Corazón
    path.moveTo(size.width * 0.5, size.height * 0.35);
    path.cubicTo(
      size.width * 0.2, size.height * 0.1,
      -size.width * 0.05, size.height * 0.4,
      size.width * 0.5, size.height * 0.8,
    );
    path.moveTo(size.width * 0.5, size.height * 0.35);
    path.cubicTo(
      size.width * 0.8, size.height * 0.1,
      size.width * 1.05, size.height * 0.4,
      size.width * 0.5, size.height * 0.8,
    );

    // Cuchara
    path.moveTo(size.width * 0.25, size.height * 0.45);
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.25, size.height * 0.45),
      radius: 12,
    ));
    path.moveTo(size.width * 0.25, size.height * 0.45);
    path.lineTo(size.width * 0.25, size.height * 0.65);

    // Tenedor
    path.moveTo(size.width * 0.75, size.height * 0.35);
    path.lineTo(size.width * 0.75, size.height * 0.65);
    path.moveTo(size.width * 0.70, size.height * 0.35);
    path.lineTo(size.width * 0.70, size.height * 0.45);
    path.moveTo(size.width * 0.80, size.height * 0.35);
    path.lineTo(size.width * 0.80, size.height * 0.45);

    // Gota
    final dropPath = Path();
    dropPath.moveTo(size.width * 0.5, size.height * 0.15);
    dropPath.quadraticBezierTo(
      size.width * 0.45, size.height * 0.22,
      size.width * 0.5, size.height * 0.28,
    );
    dropPath.quadraticBezierTo(
      size.width * 0.55, size.height * 0.22,
      size.width * 0.5, size.height * 0.15,
    );

    canvas.drawPath(path, paint);
    canvas.drawPath(dropPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
