import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/menu_controller.dart' as menu;
import 'controllers/cart_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/delivery_controller.dart';
import 'pages/launch_screen.dart';
import 'pages/welcome_screen.dart';
import 'pages/onboarding_screen.dart';
import 'pages/login_screen.dart';
import 'pages/home_page.dart';
import 'pages/cart_screen.dart';
import 'pages/checkout_screen.dart';
import 'pages/tracking_screen.dart';
import 'pages/delivery_orders_screen.dart';
import 'pages/delivery_tracking_screen.dart';
import 'pages/ubicacion.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MyFood - Delivery',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false, // Quitar banner de debug
      initialRoute: '/home',
      getPages: [
        // Rutas de Inicio
        GetPage(
          name: '/launch',
          page: () => const LaunchScreen(),
        ),
        GetPage(
          name: '/welcome',
          page: () => const WelcomeScreen(),
        ),
        GetPage(
          name: '/onboarding',
          page: () => const OnboardingScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => menu.MenuController());
            Get.lazyPut(() => CartController());
            Get.lazyPut(() => OrderController());
            Get.lazyPut(() => DeliveryController());
          }),
        ),
        // Rutas Cliente (original)
        GetPage(
          name: '/',
          page: () => const HomePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => menu.MenuController());
            Get.lazyPut(() => CartController());
            Get.lazyPut(() => OrderController());
            Get.lazyPut(() => DeliveryController());
          }),
        ),
        GetPage(
          name: '/cart',
          page: () => const CartScreen(),
        ),
        GetPage(
          name: '/checkout',
          page: () => const CheckoutScreen(),
        ),
        GetPage(
          name: '/tracking',
          page: () => const TrackingScreen(),
        ),
        // Rutas Repartidor (Delivery)
        GetPage(
          name: '/delivery',
          page: () => const DeliveryOrdersScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => DeliveryController());
          }),
        ),
        GetPage(
          name: '/delivery-tracking',
          page: () => const DeliveryTrackingScreen(),
        ),
        GetPage(
          name: '/ubicacion',
          page: () => const UbicacionScreen(),
        ),
      ],
    );
  }
}

