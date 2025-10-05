import 'package:flutter/material.dart';
import 'package:propmeet/shared/config/app_assets/app_assets.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class UserAgentsCards extends StatelessWidget {
  final String? imagePath;
  final String? name;
  final String? distance;
  final bool? isVerified;

  const UserAgentsCards({
    super.key,
    this.imagePath,
    this.name,
    this.distance,
    this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(color: AppColors.silverColor.withOpacity(0.9), width: 3),
          right: BorderSide(color: AppColors.silverColor.withOpacity(0.9), width: 3),
          bottom: BorderSide(color: AppColors.silverColor.withOpacity(0.9), width: 3),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _buildImage(imagePath),

            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 18,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? 'Default Name',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(2.5),
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      //distance ?? '5 km away',
    '5 km away',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(3.5),
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                if (isVerified?? true)
                  Image.asset(
                    AppAssets.verifiedIcon,
                    width: 20,
                    height: 20,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
Widget _buildImage(String? path) {
  if (path == null || path.isEmpty) {
    // fallback to default asset
    return Image.asset(
      AppAssets.user3,
      fit: BoxFit.cover,
    );
  } else if (path.startsWith('http')) {
    // Firebase Storage / online images
    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(AppAssets.user3, fit: BoxFit.cover); // fallback
      },
    );
  } else {
    // Local asset
    return Image.asset(
      path,
      fit: BoxFit.cover,
    );
  }
}
