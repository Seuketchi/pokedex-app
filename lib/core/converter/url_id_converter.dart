import 'package:json_annotation/json_annotation.dart';

class UrlIdConverter implements JsonConverter<int, String> {
  const UrlIdConverter();

  @override
  int fromJson(String url) {
    final segments = url.split('/');
    return int.parse(segments[segments.length - 2]);
  }

  @override
  String toJson(int id) => id.toString();
}
