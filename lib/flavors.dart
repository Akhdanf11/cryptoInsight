enum Flavor {
  dev,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Cryptho Insight App';
      case Flavor.prod:
        return 'Cryptho Insight App';
      default:
        return 'title';
    }
  }

}
