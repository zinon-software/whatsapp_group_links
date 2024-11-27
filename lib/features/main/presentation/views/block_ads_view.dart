import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockAdsView extends StatelessWidget {
  const BlockAdsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            "حظر الإعلانات",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Description
          Text(
            "اختر الطريقة التي تناسبك للتخلص من الإعلانات المزعجة. يمكنك الاشتراك لإزالة الإعلانات بالكامل.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Button to block ads temporarily
              ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.parse('https://wa.me/967772404196'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  "حظر مؤقت",
                  style: TextStyle(fontSize: 16),
                ),
              ),

              // Button to subscribe for ad-free experience
              ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.parse('https://wa.me/967772404196'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  "إزالة الإعلانات",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
