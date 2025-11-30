import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            index: 0,
            onPressed: () {
              if (onTap != null) {
                onTap!(0);
              } else {
                Get.offAllNamed('/home');
              }
            },
          ),
          _buildNavItem(
            icon: Icons.restaurant_menu_outlined,
            activeIcon: Icons.restaurant_menu,
            index: 1,
            onPressed: () {
              if (onTap != null) {
                onTap!(1);
              } else {
                Get.toNamed('/');
              }
            },
          ),
          _buildNavItem(
            icon: Icons.favorite_border,
            activeIcon: Icons.favorite,
            index: 2,
            onPressed: () {
              if (onTap != null) {
                onTap!(2);
              }
            },
          ),
          _buildNavItem(
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long,
            index: 3,
            onPressed: () {
              if (onTap != null) {
                onTap!(3);
              } else {
                Get.toNamed('/delivery');
              }
            },
          ),
          _buildNavItem(
            icon: Icons.headset_mic_outlined,
            activeIcon: Icons.headset_mic,
            index: 4,
            onPressed: () {
              if (onTap != null) {
                onTap!(4);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required VoidCallback onPressed,
  }) {
    final isActive = currentIndex == index;
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.white.withOpacity(0.2) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isActive ? activeIcon : icon,
          color: AppColors.white,
          size: 28,
        ),
      ),
    );
  }
}
