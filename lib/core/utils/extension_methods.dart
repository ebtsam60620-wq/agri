import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/resources/route_manager.dart';
import 'package:agri/data/data_sources/localization_local_data_source.dart';
import 'package:agri/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart'
    show
        Directionality,
        TextDirection,
        BuildContext,
        RouteSettings,
        Color,
        StringCharacters,
        ModalRoute,
        Locale;

extension StringExtensions on String {
  bool get isValidEmail => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(this);
  String? get phoneValidation {
    if (isEmpty) {
      return 'Phone number is required';
    }

    // Remove common formatting characters like spaces, dashes, or parentheses
    // to check the raw digit count
    final cleanPhone = replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it contains non-numeric characters (allowing for a leading +)
    if (!RegExp(r'^\+?[0-9]+$').hasMatch(cleanPhone)) {
      return 'Enter a valid phone number (digits only)';
    }

    // Standard E.164 length check (usually 10 to 15 digits)
    if (cleanPhone.length < 10) {
      return 'Phone number is too short';
    }
    if (cleanPhone.length > 15) {
      return 'Phone number is too long';
    }
    if (!(cleanPhone.startsWith('010') || // vodafone
            cleanPhone.startsWith('011') || // e
            cleanPhone.startsWith('012') || // orange
            cleanPhone.startsWith('015')) // we
        ) {
      return 'not valid company';
    }
    return null;
  }

  String? get passwordValidationMessage {
    if (isEmpty) {
      return 'Password is required';
    }
    if (length < 8) {
      return 'Use at least 8 characters';
    }
    if (length > 50) {
      return 'Password must be at most 50 characters';
    }

    if (!RegExp(r'\d+').hasMatch(this)) {
      return 'Consider adding numbers for extra security';
    }
    if (!RegExp(r'[!@#$%^&*?_~\-()]').hasMatch(this)) {
      return 'Add special characters for increased strength';
    }
    if (!RegExp(r'^[^\s]+$').hasMatch(this)) {
      return 'Password should not contain space';
    }
    if (!RegExp(r'[a-z]').hasMatch(this)) {
      return 'Must include lowercase letters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(this)) {
      return 'Must include uppercase letters';
    }
    return null;
  }

  String removeAllHtmlTags() {
    RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

    return replaceAll(exp, ' ');
  }

  String get initials {
    String nameInitials = '';
    if (contains(' ')) {
      nameInitials = split(' ')
          .map((e) => e.characters.first.toUpperCase())
          .take(2)
          .join();
    } else if (contains('.')) {
      nameInitials = split('.')
          .map((e) => e.characters.first.toUpperCase())
          .take(2)
          .join();
    } else {
      nameInitials = characters.first.toUpperCase();
    }

    return nameInitials;
  }

  void callPhoneNumber() {
    launchUrl(Uri.parse('tel:$this'));
  }

  void sendEmail() {
    launchUrl(Uri.parse('mailto:$this'));
  }

  void openWhatsApp() {
    final whatsappUrl = 'https://wa.me/$this';
    launchUrl(Uri.parse(whatsappUrl));
  }

  String toNumber() {
    if (startsWith('+20')) {
      return this;
    } else if (startsWith('0')) {
      return '+2$this';
    }
    return '+20$this';
  }

  void lunch() {}
}

extension NavExtensions on BuildContext {
  RouteSettings getRouteSettings() {
    final r = ModalRoute.of(this)!.settings;
    return r;
  }

  TextDirection get textDirection => Directionality.of(this);
  bool get isRtl => textDirection == TextDirection.rtl;
  bool get canPop => RouteManager.canPop(context: this);

  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension DateTimeExtension on DateTime {
  String get formattedDate => '$year-$month-$day';
  String toFormattedString({String? format = 'dd MMM yyyy, h:mm a'}) {
    return DateFormat(format).format(this);
  }

  String toSmartString() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCheck = DateTime(year, month, day);

    if (dateToCheck == today) {
      return 'Today\n${toFormattedString(format: 'h:mm a')}';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow\n${toFormattedString(format: 'h:mm a')}';
    } else {
      // For any other day, show the full date and time
      return toFormattedString(format: 'dd MMM\nh:mm a');
    }
  }

  String timeAgo() {
    final Duration diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return "$m minute${m == 1 ? '' : 's'} ago";
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return "$h hour${h == 1 ? '' : 's'} ago";
    } else if (diff.inDays < 7) {
      final d = diff.inDays;
      return "$d day${d == 1 ? '' : 's'} ago";
    } else if (diff.inDays < 30) {
      final w = (diff.inDays / 7).floor();
      return "$w week${w == 1 ? '' : 's'} ago";
    } else if (diff.inDays < 365) {
      final mo = (diff.inDays / 30).floor();
      return "$mo month${mo == 1 ? '' : 's'} ago";
    } else {
      final y = (diff.inDays / 365).floor();
      return "$y year${y == 1 ? '' : 's'} ago";
    }
  }

  int get getAge {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}

extension TextDirectionExtension on AppLocalizations {
  TextDirection get textDirection {
    switch (localeName) {
      case 'ar':
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }
}

extension ColorExtenstion on Color {
  int get hex {
    final red = (r * 255.0).round() & 0xff;
    final green = (g * 255.0).round() & 0xff;
    final blue = (b * 255.0).round() & 0xff;
    final alpha = (a * 255.0).round() & 0xff;
    return int.parse('0x$alpha$red$green$blue');
  }
}

extension ColorAplhaExtenstion on num {
  int get toAlpha => (this * 255.0).round() & 0xff;
}

AppLocalizations getappLoc() {
  final languageCode = di.get<LocalizationLocalDataSource>().getLocalization();

  return lookupAppLocalizations(Locale(languageCode.languageCode ));
}

extension Multifile on XFile {
  Future<MultipartFile> get getMultipartFile async {
    final mimeType = lookupMimeType(path) ?? 'application/octet-stream';
    final mediaTypeParts = mimeType.split('/');

    return MultipartFile.fromFile(
      path,
      contentType: DioMediaType(mediaTypeParts[0], mediaTypeParts[1]),
      filename: name,
    );
  }
}



extension D on double {
  double get upper {
    final c = (this).ceilToDouble();
    return c;
  }
}
