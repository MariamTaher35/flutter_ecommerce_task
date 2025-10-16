import 'package:flutter/material.dart';

class LocationBar extends StatelessWidget {
  final VoidCallback onPressed;
  static const double _kBarHeight = 52.0;

   LocationBar({
    super.key,
    required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {
    // The GestureDetector makes the whole bar tappable
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // Constrain the height to the fixed dimension (52)
        height: _kBarHeight,
        padding: const EdgeInsets.only(left: 4, right: 8), // Adjusted padding to fit content better
        // Main container styling
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_kBarHeight / 2), // Perfect pill shape
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Location Pin Icon Container (Circular, outlined)
            Container(
              width: _kBarHeight - 8, // Set icon diameter slightly smaller than bar height
              height: _kBarHeight - 8,
              margin: const EdgeInsets.only(right: 8), // Reduced internal margin
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: Colors.black,
                size: 20, // Icon size adjusted
              ),
            ),

            // 2. Text Content (takes all available horizontal space)
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0), // Vertical padding for alignment
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                  children: [
                    // 'Send To' Label (light grey, smaller)
                    Text(
                      'Send To',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // Location Text (darker, bolder)
                    Text(
                      'Brisbane, Queensland',
                      style: TextStyle(
                        fontSize: 14, // Adjusted size slightly for the limited height
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1, // Restrict to one line for the 52 unit height
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8), // Spacer

            // 3. Change Button (Right side, fixed height and appearance)
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 100, // Provides a minimum width to approximate the 176 dimension
                maxHeight: _kBarHeight - 12, // Ensure it fits well within the bar
              ),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF015B8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20), // Adjusted padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}