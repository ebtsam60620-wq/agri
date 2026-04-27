enum AccountStatusEnum {
  approved,
  rejected,
  pending;

  static AccountStatusEnum toAccountStatusEnum(String name) {
    switch (name.toLowerCase()) {
      case 'approved':
        return AccountStatusEnum.approved;
      case 'rejected':
        return AccountStatusEnum.rejected;
      case 'pending':
        return AccountStatusEnum.pending;
      default:
        throw ArgumentError('Unknown UserTypeEnum value: $name');
    }
  }
}
