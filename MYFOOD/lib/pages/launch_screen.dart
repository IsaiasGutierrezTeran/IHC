import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    // Navegar a la pantalla de bienvenida después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed('/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo del corazón con cubiertos
            CustomPaint(
              size: const Size(150, 150),
              painter: HeartLogoPainter(),
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
                      color: AppColors.secondary,
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
          ],
        ),
      ),
    );
  }
}

// Painter para dibujar el logo del corazón con cubiertos
class HeartLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Dibujar corazón
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

    // Cuchara (izquierda)
    path.moveTo(size.width * 0.25, size.height * 0.45);
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.25, size.height * 0.45),
      radius: 15,
    ));
    path.moveTo(size.width * 0.25, size.height * 0.45);
    path.lineTo(size.width * 0.25, size.height * 0.65);

    // Tenedor (derecha)
    path.moveTo(size.width * 0.75, size.height * 0.35);
    path.lineTo(size.width * 0.75, size.height * 0.65);
    path.moveTo(size.width * 0.70, size.height * 0.35);
    path.lineTo(size.width * 0.70, size.height * 0.45);
    path.moveTo(size.width * 0.80, size.height * 0.35);
    path.lineTo(size.width * 0.80, size.height * 0.45);

    // Gota en el centro superior
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
