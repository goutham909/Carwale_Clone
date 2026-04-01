import 'dart:convert';

class Car {
  const Car({
    required this.id,
    required this.brand,
    required this.name,
    required this.fullName,
    required this.priceDisplay,
    required this.priceRange,
    required this.onRoad,
    required this.emi,
    required this.version,
    required this.city,
    required this.imageUrls,
    required this.status,
  });

  final String id;
  final String brand;
  final String name;
  final String fullName;
  final String priceDisplay;
  final String priceRange;
  final String onRoad;
  final String emi;
  final String version;
  final String city;
  final List<String> imageUrls;
  /// '', 'coming', 'discontinued'
  final String status;

  factory Car.fromJson(Map<String, dynamic> j) {
    return Car(
      id: j['id'] as String,
      brand: j['brand'] as String,
      name: j['name'] as String,
      fullName: j['fullName'] as String,
      priceDisplay: j['priceDisplay'] as String,
      priceRange: j['priceRange'] as String,
      onRoad: j['onRoad'] as String,
      emi: j['emi'] as String,
      version: j['version'] as String,
      city: j['city'] as String,
      imageUrls: (j['imageUrls'] as List<dynamic>).cast<String>(),
      status: j['status'] as String? ?? '',
    );
  }
}

class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.author,
    required this.time,
    required this.views,
    required this.imageUrl,
    required this.category,
  });

  final String id;
  final String title;
  final String author;
  final String time;
  final String views;
  final String imageUrl;
  final String category;

  factory NewsArticle.fromJson(Map<String, dynamic> j) {
    return NewsArticle(
      id: j['id'] as String,
      title: j['title'] as String,
      author: j['author'] as String,
      time: j['time'] as String,
      views: j['views'] as String,
      imageUrl: j['imageUrl'] as String,
      category: j['category'] as String,
    );
  }
}

class AppNotification {
  const AppNotification({
    required this.title,
    required this.time,
    required this.imageUrl,
  });

  final String title;
  final String time;
  final String imageUrl;

  factory AppNotification.fromJson(Map<String, dynamic> j) {
    return AppNotification(
      title: j['title'] as String,
      time: j['time'] as String,
      imageUrl: j['imageUrl'] as String,
    );
  }
}

class ComparisonRef {
  const ComparisonRef({required this.leftId, required this.rightId});

  final String leftId;
  final String rightId;

  factory ComparisonRef.fromJson(Map<String, dynamic> j) {
    return ComparisonRef(
      leftId: j['leftId'] as String,
      rightId: j['rightId'] as String,
    );
  }
}

class CarWaleCatalog {
  const CarWaleCatalog({
    required this.cars,
    required this.news,
    required this.notifications,
    required this.comparisons,
    required this.recentCarIds,
    required this.trending,
    required this.searchCompareLabels,
    required this.cities,
  });

  final List<Car> cars;
  final List<NewsArticle> news;
  final List<AppNotification> notifications;
  final List<ComparisonRef> comparisons;
  final List<String> recentCarIds;
  final List<String> trending;
  final List<String> searchCompareLabels;
  final List<String> cities;

  Car? carById(String id) {
    try {
      return cars.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  factory CarWaleCatalog.fromJson(Map<String, dynamic> j) {
    return CarWaleCatalog(
      cars: (j['cars'] as List<dynamic>).map((e) => Car.fromJson(e as Map<String, dynamic>)).toList(),
      news: (j['news'] as List<dynamic>).map((e) => NewsArticle.fromJson(e as Map<String, dynamic>)).toList(),
      notifications: (j['notifications'] as List<dynamic>)
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      comparisons: (j['comparisons'] as List<dynamic>)
          .map((e) => ComparisonRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentCarIds: (j['recentCarIds'] as List<dynamic>).cast<String>(),
      trending: (j['trending'] as List<dynamic>).cast<String>(),
      searchCompareLabels: (j['searchCompareLabels'] as List<dynamic>).cast<String>(),
      cities: (j['cities'] as List<dynamic>).cast<String>(),
    );
  }

  static CarWaleCatalog decode(String raw) {
    return CarWaleCatalog.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
