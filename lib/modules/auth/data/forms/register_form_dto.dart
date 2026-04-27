

class RegisterFormDto {
  String fullName;
  String phone;
  String email;
  String password;
  bool acceptedTerms;

  RegisterFormDto({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    required this.acceptedTerms,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'password': password,
      'accepted_terms': acceptedTerms,
      'terms_version': 'v1',
    };
  }

  // Map<String, dynamic> toUpdateProfileJson() {
  //   final userDto = di.get<UserLocalDataSource>().returnUser()!;

  //   return {
  //     if (userDto.fullName != fullName) 'full_name': fullName,
  //     if (userDto.phone != phone) 'phone': phone,
  //     if (userDto.email != email) 'email': email,
  //   };
  // }

  /// Optional: A validation method mirroring the Python schema validations
  bool validate() {
    if (fullName.length < 2 || fullName.length > 120) return false;
    if (password.length < 8) return false;
    if (!acceptedTerms) return false;
    return true; // You can expand this to throw specific exceptions or return error strings
  }

  RegisterFormDto copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? password,
    bool? acceptedTerms,
    String? termsVersion,
  }) {
    return RegisterFormDto(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterFormDto &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.email == email &&
        other.password == password &&
        other.acceptedTerms == acceptedTerms;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        password.hashCode ^
        acceptedTerms.hashCode;
  }
}
