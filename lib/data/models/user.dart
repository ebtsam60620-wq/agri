import 'package:agri/core/infrastructure/di.dart';
import 'package:agri/core/utils/account_status_enum.dart';
import 'package:agri/core/utils/user_type_enum.dart';
import 'package:agri/data/data_sources/user_local_data_source.dart';
import 'package:objectbox/objectbox.dart';

// part 'user.g.dart';

@Entity()
class User {
  @Id()
  int storageID = 0;

  @Unique(onConflict: ConflictStrategy.replace)
  final String userID;
  final String? firstName;
  final String? lastName;
  final String? fullNameOnId;
  final String? nationalId;
  final String? email;
  final String? phone;
  @Property(type: PropertyType.date)
  final DateTime? birthDate;
  final String? gender;

  final bool? isActive;
  @Property(type: PropertyType.date)
  final DateTime? emailVerifiedAt;
  @Property(type: PropertyType.date)
  final DateTime? phoneVerifiedAt;
  @Property(type: PropertyType.date)
  final DateTime? createdAt;
  @Property(type: PropertyType.date)
  final DateTime? updatedAt;
  // The Role type is not supported by ObjectBox.
  // So ignore this field...
  @Transient()
  final AccountStatusEnum?
      accountStatus; // ...and define a field with a supported type,
  // that is backed by the role field.
  int? get dbAccountStatus {
    _ensureStabledbAccountStatusEnumValues();
    return accountStatus?.index;
  }

  void _ensureStabledbAccountStatusEnumValues() {
    assert(AccountStatusEnum.approved.index == 0);
    assert(AccountStatusEnum.pending.index == 1);
    assert(AccountStatusEnum.rejected.index == 2);
  }

  final bool? acceptedTerms;
  @Property(type: PropertyType.date)
  final DateTime? acceptedTermsAt;
  final bool? acceptedDisclaimer;
  @Property(type: PropertyType.date)
  final DateTime? acceptedDisclaimerAt;
  final bool? patientDetailsComplete;
  @Property(type: PropertyType.date)
  final DateTime? patientDetailsCompletedAt;
  final bool? providerDetailsComplete;
  @Property(type: PropertyType.date)
  final DateTime? providerDetailsCompletedAt;
  final int? categoryId;
  // New fields
  @Transient()
  final String? firstRequestStatus;

  final String? requestUpdatedBy;
  @Property(type: PropertyType.date)
  final DateTime? requestUpdatedAt;
  final String? declinationReason;
  final String? onlineStatus;
  final String? avatar;
  final bool isProvider;

  User(
      {required this.userID,
      required this.isProvider,
      this.firstName,
      this.lastName,
      this.fullNameOnId,
      this.nationalId,
      this.email,
      this.phone,
      this.birthDate,
      this.gender,
      this.isActive,
      this.emailVerifiedAt,
      this.phoneVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.accountStatus,
      this.acceptedTerms,
      this.acceptedTermsAt,
      this.acceptedDisclaimer,
      this.acceptedDisclaimerAt,
      this.patientDetailsComplete,
      this.patientDetailsCompletedAt,
      this.providerDetailsComplete,
      this.providerDetailsCompletedAt,
      this.firstRequestStatus,
      this.requestUpdatedBy,
      this.requestUpdatedAt,
      this.declinationReason,
      this.onlineStatus,
      this.avatar,
      this.categoryId});

  factory User.fromJson(Map<String, dynamic> json, {bool? isProvider}) {
    final data = json['data'] ?? json['user'] ?? json;

    return User(
      userID: data['id'] ?? '',
      isProvider:
          isProvider ?? di<UserLocalDataSource>().returnUser()!.isProvider,
      firstName: data['firstName'],
      lastName: data['lastName'],
      fullNameOnId: data['fullNameOnId'],
      nationalId: data['nationalId'],
      email: data['email'],
      phone: data['phone'],
      birthDate: data['birthDate'] != null
          ? DateTime.tryParse(data['birthDate'])
          : null,
      gender: data['gender'],
      isActive: data['isActive'],
      emailVerifiedAt: data['emailVerifiedAt'] != null
          ? DateTime.tryParse(data['emailVerifiedAt'])
          : null,
      phoneVerifiedAt: data['phoneVerifiedAt'] != null
          ? DateTime.tryParse(data['phoneVerifiedAt'])
          : null,
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'])
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'])
          : null,
      accountStatus:
          AccountStatusEnum.toAccountStatusEnum(data['accountStatus']),
      acceptedTerms: data['acceptedTerms'],
      acceptedTermsAt: data['acceptedTermsAt'] != null
          ? DateTime.tryParse(data['acceptedTermsAt'])
          : null,
      acceptedDisclaimer: data['acceptedDisclaimer'],
      acceptedDisclaimerAt: data['acceptedDisclaimerAt'] != null
          ? DateTime.tryParse(data['acceptedDisclaimerAt'])
          : null,
      patientDetailsComplete: data['patientDetailsComplete'],
      patientDetailsCompletedAt: data['patientDetailsCompletedAt'] != null
          ? DateTime.tryParse(data['patientDetailsCompletedAt'])
          : null,
      providerDetailsComplete: data['providerDetailsComplete'],
      providerDetailsCompletedAt:
          DateTime.tryParse(data['providerDetailsCompletedAt'].toString()),
      firstRequestStatus: data['firstRequestStatus'],
      requestUpdatedBy: data['requestUpdatedBy'],
      requestUpdatedAt: data['requestUpdatedAt'] != null
          ? DateTime.tryParse(data['requestUpdatedAt'])
          : null,
      declinationReason: data['declinationReason'],
      onlineStatus: data['onlineStatus'],
      avatar: data['avatar'],
      categoryId: data['categoryId'],
    );
  }

  String get fullname => '${firstName!} ${lastName!}';

  User copyWith(
      {String? userID,
      String? firstName,
      String? lastName,
      String? fullNameOnId,
      String? nationalId,
      String? email,
      String? phone,
      DateTime? birthDate,
      String? gender,
      List<UserTypeEnum>? roles,
      bool? isActive,
      DateTime? emailVerifiedAt,
      DateTime? phoneVerifiedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      AccountStatusEnum? accountStatus,
      bool? acceptedTerms,
      DateTime? acceptedTermsAt,
      bool? acceptedDisclaimer,
      DateTime? acceptedDisclaimerAt,
      bool? patientDetailsComplete,
      DateTime? patientDetailsCompletedAt,
      bool? providerDetailsComplete,
      DateTime? providerDetailsCompletedAt,
      String? firstRequestStatus,
      String? requestUpdatedBy,
      DateTime? requestUpdatedAt,
      String? declinationReason,
      String? onlineStatus,
      String? avatar,
      int? categoryId}) {
    return User(
      userID: userID ?? this.userID,
      isProvider: isProvider,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullNameOnId: fullNameOnId ?? this.fullNameOnId,
      nationalId: nationalId ?? this.nationalId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      isActive: isActive ?? this.isActive,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accountStatus: accountStatus ?? this.accountStatus,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      acceptedTermsAt: acceptedTermsAt ?? this.acceptedTermsAt,
      acceptedDisclaimer: acceptedDisclaimer ?? this.acceptedDisclaimer,
      acceptedDisclaimerAt: acceptedDisclaimerAt ?? this.acceptedDisclaimerAt,
      patientDetailsComplete:
          patientDetailsComplete ?? this.patientDetailsComplete,
      patientDetailsCompletedAt:
          patientDetailsCompletedAt ?? this.patientDetailsCompletedAt,
      providerDetailsComplete:
          providerDetailsComplete ?? this.providerDetailsComplete,
      providerDetailsCompletedAt:
          providerDetailsCompletedAt ?? this.providerDetailsCompletedAt,
      firstRequestStatus: firstRequestStatus ?? this.firstRequestStatus,
      requestUpdatedBy: requestUpdatedBy ?? this.requestUpdatedBy,
      requestUpdatedAt: requestUpdatedAt ?? this.requestUpdatedAt,
      declinationReason: declinationReason ?? this.declinationReason,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      avatar: avatar ?? this.avatar,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  String toString() {
    return 'User('
        'userID: $userID, '
        'firstName: $firstName, '
        'lastName: $lastName, '
        'fullNameOnId: $fullNameOnId, '
        'nationalId: $nationalId, '
        'email: $email, '
        'phone: $phone, '
        'birthDate: $birthDate, '
        'gender: $gender, '
        'isActive: $isActive, '
        'emailVerifiedAt: $emailVerifiedAt, '
        'phoneVerifiedAt: $phoneVerifiedAt, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'accountStatus: $accountStatus, '
        'acceptedTerms: $acceptedTerms, '
        'acceptedTermsAt: $acceptedTermsAt, '
        'acceptedDisclaimer: $acceptedDisclaimer, '
        'acceptedDisclaimerAt: $acceptedDisclaimerAt, '
        'patientDetailsComplete: $patientDetailsComplete, '
        'patientDetailsCompletedAt: $patientDetailsCompletedAt, '
        'providerDetailsComplete: $providerDetailsComplete, '
        'providerDetailsCompletedAt: $providerDetailsCompletedAt, '
        'firstRequestStatus: $firstRequestStatus, '
        'requestUpdatedBy: $requestUpdatedBy, '
        'requestUpdatedAt: $requestUpdatedAt, '
        'declinationReason: $declinationReason, '
        'onlineStatus: $onlineStatus, '
        'avatar: $avatar, '
        'categoryId: $categoryId, '
        'isProvider: $isProvider'
        ')';
  }

 
}
