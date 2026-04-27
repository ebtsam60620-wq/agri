class OnboardingModel {
  final String image;
  final String titlePart1;
  final String titlePart2;
  final String titlePart3;

  OnboardingModel({
    required this.image,
    required this.titlePart1,
    required this.titlePart2,
    required this.titlePart3,
  });
}

final List<OnboardingModel> onboardingData = [
  OnboardingModel(
    image: 'assets/images/boarding1.jpg',
    titlePart1: 'TRACK YOUR',
    titlePart2: 'FARM',
    titlePart3: 'USING IOT SENSORS',
  ),
  OnboardingModel(
    image: 'assets/images/boarding2.jpg',
    titlePart1: 'SMARTER IRRIGATION',
    titlePart2: 'WITH',
    titlePart3: 'LESS WATER',
  ),
  OnboardingModel(
    image: 'assets/images/boarding3.jpg',
    titlePart1: 'CONNECT WITH',
    titlePart2: 'FARMERS',
    titlePart3: 'AND SHARE UPDATES',
  ),
];
