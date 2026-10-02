import 'dart:math';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/constants/corridor_constants.dart';

/// Authentic local Warri/Delta transit logistics sample data generator.
/// Used for quick prototyping, demo walkthroughs, and automated form randomization.
class FormSampleData {
  static final _random = Random();

  static const List<String> firstNames = [
    'Diran',
    'Oghenekevwe',
    'Efe',
    'Tega',
    'Chinedu',
    'Blessing',
    'Emeka',
    'Amina',
    'Obaro',
    'Elohor',
    'Tare',
    'Osas',
    'Precious',
  ];

  static const List<String> lastNames = [
    'Olakunle',
    'Okoro',
    'Etaghene',
    'Igho',
    'Macaulay',
    'Omoefe',
    'Agbaje',
    'Uduaghan',
    'Ovie',
    'Kalu',
    'Ese',
  ];

  static const List<String> phonePrefixes = [
    '803',
    '806',
    '812',
    '706',
    '903',
    '814',
    '901',
    '703',
  ];

  static const List<String> plateNumbers = [
    'WRA-492-XA',
    'EFF-812-DT',
    'UVD-103-KM',
    'WAR-334-LK',
    'SAP-501-AB',
    'WRA-771-BC',
  ];

  static const List<String> parkNames = [
    'Refinery Junction Unit Park',
    'PTI First Gate Park',
    'Enerhen Junction Park',
    'Deco Road Tricycle Union Park',
    'Airport Road Main Park',
    'Jakpa Road Keke Station',
  ];

  static const List<String> merchantShops = senderShops;
  static const List<String> senderShops = [
    'Warri Glow Boutique & Cosmetics',
    'Ekpan Fresh Provisions & Drinks',
    'Midwest Electronics & Gadgets',
    'Deco Luxury Fabrics',
    'Enerhen Mobile Care & Accessories',
    'Oil City Perfumery',
    'Delta Beauty Hub',
  ];

  static const List<String> hubStores = [
    'City Care Pharmacy & Stores',
    'Goodwill Chemist & Mini-Mart',
    'Delta Health Mart',
    'PTI Road Groceries & Drinks',
    'Enerhen Junction Drug Store',
    'Apex Supermarket & Hub',
  ];

  static const List<String> roadsideLandmarks = [
    'Opposite PTI First Gate, Effurun',
    'Beside Enerhen Junction Flyover',
    'Near Refinery Police Station',
    'Deco Road by Total Filling Station',
    'Airport Junction by Church of God',
    'Jakpa Junction by First Bank',
  ];

  static const List<String> deliveryAddresses = [
    '14 Deco Road, Warri',
    '88 Effurun-Sapele Road, Effurun',
    '5 PTI Road, Effurun',
    '12 Enerhen Road, Warri',
    '44 Airport Road, Warri',
    '23 Jakpa Road, Effurun',
  ];

  static const List<String> trackingIds = [
    'SND-WAR-8492',
    'SND-EFF-3019',
    'SND-REF-5521',
    'SND-DEC-9104',
    'SND-JAK-7720',
  ];

  static T _pick<T>(List<T> list) => list[_random.nextInt(list.length)];

  static String randomFirstName() => _pick(firstNames);
  static String randomLastName() => _pick(lastNames);

  static String randomPhone() {
    final prefix = _pick(phonePrefixes);
    final rest = _random.nextInt(9000000) + 1000000;
    return '$prefix$rest';
  }

  static String randomPlateNumber() => _pick(plateNumbers);
  static String randomCorridor() => _pick(CorridorConstants.pilotCorridors);
  static String randomPark() => _pick(parkNames);
  static String randomSenderShop() => _pick(senderShops);
  static String randomMerchantShop() => randomSenderShop();
  static String randomHubStore() => _pick(hubStores);
  static String randomLandmark() => _pick(roadsideLandmarks);
  static String randomAddress() => _pick(deliveryAddresses);
  static String randomTrackingId() => _pick(trackingIds);
}

/// Classy, minimal action button for randomizing form state with 1 tap.
class RandomizeButton extends StatelessWidget {
  final VoidCallback onRandomize;
  final String label;
  final bool isInline;

  const RandomizeButton({
    super.key,
    required this.onRandomize,
    this.label = 'Randomize',
    this.isInline = false,
  });

  const RandomizeButton.inline({
    super.key,
    required this.onRandomize,
    this.label = 'Randomize Form',
  }) : isInline = true;

  @override
  Widget build(BuildContext context) {
    if (isInline) {
      return TextButton.icon(
        onPressed: () {
          onRandomize();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Form populated with demo data.'),
              duration: Duration(milliseconds: 1200),
            ),
          );
        },
        icon: const Icon(FeatherIcons.shuffle, size: 14, color: AppColors.textSecondary),
        label: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    // Modern hairline action pill for AppBars
    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: Center(
        child: InkWell(
          onTap: () {
            onRandomize();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Form populated with demo data.'),
                duration: Duration(milliseconds: 1200),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FeatherIcons.shuffle, size: 12, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
