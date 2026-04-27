import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/utils/extension_methods.dart';
import 'package:agri/presentation/components/my_scafold.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CustomBottomNavBar extends StatelessWidget {
  final HomePages currentIndex;
  final ValueChanged<HomePages> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context);

    return SizedBox(
      child: Stack(
        children: [
          Container(
            height: 70,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: ColorsManager.textWhite, // Main bar is now Black
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(0.3.toAlpha),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IConButton(
                  onTap: onTap,
                  isActive: currentIndex == HomePages.home,
                  item: HomePages.home,
                ),
                IConButton(
                  onTap: onTap,
                  isActive: currentIndex == HomePages.cropCycle,
                  item: HomePages.cropCycle,
                ),
                SizedBox(width: 20),
                IConButton(
                  onTap: onTap,
                  isActive: currentIndex == HomePages.sensors,
                  item: HomePages.sensors,
                ),
                IConButton(
                  onTap: onTap,
                  isActive: currentIndex == HomePages.settings,
                  item: HomePages.settings,
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: GestureDetector(
              onTap: () => onTap(HomePages.scan),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(0.3.toAlpha),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  currentIndex == HomePages.scan
                      ? HomePages.scan.activeIcon
                      : HomePages.scan.inactiveIcon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IConButton extends StatelessWidget {
  const IConButton({
    super.key,
    required this.onTap,
    required this.isActive,
    required this.item,
  });

  final ValueChanged<HomePages> onTap;
  final bool isActive;
  final HomePages item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        child: Icon(
          isActive ? item.activeIcon : item.inactiveIcon,
          color: isActive
              ? ColorsManager.textBlack
              : ColorsManager
                    .iconsGrey, // Black icon inside Orange, Grey when off
          size: 24,
        ),
      ),
    );
  }
}

// class NavItemData {
//   final IconData inactiveicon;
//   final IconData activeicon;
//   final String label;

//   const NavItemData({
//     required this.inactiveicon,
//     required this.activeicon,
//     required this.label,
//   });

//   NavItemData copyWith({
//     IconData? inactiveicon,
//     IconData? activeicon,
//     String? label,
//   }) {
//     return NavItemData(
//       inactiveicon: inactiveicon ?? this.inactiveicon,
//       activeicon: activeicon ?? this.activeicon,
//       label: label ?? this.label,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'inactiveicon': inactiveicon.codePoint,
//       'activeicon': activeicon.codePoint,
//       'label': label,
//     };
//   }

//   factory NavItemData.fromMap(Map<String, dynamic> map) {
//     return NavItemData(
//       inactiveicon: IconData(
//         map['inactiveicon'] as int,
//         fontFamily: 'MaterialIcons',
//       ),
//       activeicon: IconData(
//         map['activeicon'] as int,
//         fontFamily: 'MaterialIcons',
//       ),
//       label: map['label'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory NavItemData.fromJson(String source) =>
//       NavItemData.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() =>
//       'NavItemData(inactiveicon: $inactiveicon, activeicon: $activeicon, label: $label)';

//   @override
//   bool operator ==(covariant NavItemData other) {
//     if (identical(this, other)) return true;

//     return other.inactiveicon == inactiveicon &&
//         other.activeicon == activeicon &&
//         other.label == label;
//   }

//   @override
//   int get hashCode => Object.hashAll([inactiveicon, activeicon, label]);
// }
