enum UserTypeEnum {
  patient('PATIENT'),
  provider('PROVIDER'),
  ;

  final String backendvalue;
  const UserTypeEnum(this.backendvalue);
  // String get name {
  //   switch (this) {
  //     case UserTypeEnum.patient:
  //       return 'PATIENT';
  //     case UserTypeEnum.provider:
  //       return 'PROVIDER';
  //   }
  // }
}

// Extension to convert UserTypeEnum to String
extension UserTypeEnumExtension on String {
  UserTypeEnum get toUserTypeEnum {
    switch (toLowerCase()) {
      case 'patient':
        return UserTypeEnum.patient;
      case 'provider':
        return UserTypeEnum.provider;
      default:
        throw ArgumentError('Unknown UserTypeEnum value: $this');
    }
  }
}
