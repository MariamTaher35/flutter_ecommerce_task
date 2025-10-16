import 'package:flutter/material.dart';

class SaleBanner extends StatelessWidget {
  const SaleBanner({super.key});

  // IMPORTANT: Replace with your actual asset path.
  static const String modelImagePath = 'assets/images/men_fashoin_model.png';

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // AspectRatio: 383 / 212
      aspectRatio: 383 / 212,
      child: LayoutBuilder(builder: (context, constraints) {
        final double bannerHeight = constraints.maxHeight;
        final double bannerWidth = constraints.maxWidth;

        // Reduced padding so content fits reliably
        final double horizontalPadding = bannerHeight * 0.12;
        final double verticalPadding = bannerHeight * 0.10;

        // Limit image width so it doesn't push text out of the card
        final double imageWidth = bannerWidth * 0.61;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF64B5F6)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              // 1. Model Image with constrained width & full height
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: imageWidth,
                  height: bannerHeight,
                  child: Image.asset(
                    modelImagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(Icons.person, color: Colors.grey.shade500),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 2. Text and Button Content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // don't expand vertically
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Sale Percentage Text
                    Text(
                      '50% Off Today',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Allow the subtitle to wrap / shrink if needed
                    Flexible(
                      child: Text(
                        'Limited-time picks\njust for you',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Fixed height button so it won't force layout overflow
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Shop Now Tapped!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                        ),
                        child: Text(
                          'Shop Now',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
