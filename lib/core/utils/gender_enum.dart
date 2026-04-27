enum Gender {
  male,
  female;

  static Gender toGender(String name) {
    switch (name.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        throw ArgumentError('Unknown UserTypeEnum value: $name');
    }
  }
}
