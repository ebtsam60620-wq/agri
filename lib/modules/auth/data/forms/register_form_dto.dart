

import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/utils/gender_enum.dart';
import 'package:agri/core/utils/user_type_enum.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';

class RegisterFormDto {
  String email;
  String password;
  String firstName;
  String lastName;
  String phone;
  UserTypeEnum userRole;
  ProviderCategoryModel? type;
  String? fullNameOnId;
  String? nationalId;
  DateTime birthDate; // Format: "YYYY-MM-DD"
  Gender gender;

  RegisterFormDto({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userRole,
    this.type,
    this.fullNameOnId,
    this.nationalId,
    required this.birthDate,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phone': '+2$phone',
      'registerAs': userRole.backendvalue,
      if (fullNameOnId != null) 'fullNameOnId': fullNameOnId,
      if (nationalId != null) 'nationalId': nationalId,
      'birthDate': '${birthDate.year}-${birthDate.month}-${birthDate.day}',
      'gender': gender.name.toUpperCase(),
    };
  }

  Map<String, dynamic> toUpdateProfileJson() {
    final userDto =
        di.get<UserLocalDataSource>().returnUser()!;

    return {
      if (userDto.firstName != firstName) 'firstName': firstName,
      if (userDto.lastName != lastName) 'lastName': lastName,
      if (userDto.fullNameOnId != fullNameOnId)
        'fullNameOnId': fullNameOnId ?? '',
      if (userDto.nationalId != nationalId) 'nationalId': nationalId ?? '',
      if (userDto.phone != phone) 'phone': phone,
      if (userDto.email != email) 'email': email,
      if (userDto.birthDate != birthDate)
        'birthDate': birthDate.toIso8601String(),
    };
  }

  RegisterFormDto copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? phone,
    UserTypeEnum? userRole,
    ProviderCategoryModel? type,
    String? fullNameOnId,
    String? nationalId,
    DateTime? birthDate,
    Gender? gender,
  }) {
    return RegisterFormDto(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      userRole: userRole ?? this.userRole,
      type: type ?? this.type,
      fullNameOnId: fullNameOnId ?? this.fullNameOnId,
      nationalId: nationalId ?? this.nationalId,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterFormDto &&
        other.email == email &&
        other.password == password &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phone == phone &&
        other.userRole == userRole &&
        other.type == type &&
        other.fullNameOnId == fullNameOnId &&
        other.nationalId == nationalId &&
        other.birthDate == birthDate &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        password.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        phone.hashCode ^
        userRole.hashCode ^
        type.hashCode ^
        fullNameOnId.hashCode ^
        nationalId.hashCode ^
        birthDate.hashCode ^
        gender.hashCode;
  }
}

class ProviderCategoryModel {
}
