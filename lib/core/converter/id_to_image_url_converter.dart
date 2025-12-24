import 'package:json_annotation/json_annotation.dart';

class IdToImageUrlConverter implements JsonConverter<String, String> {
  const IdToImageUrlConverter();

  @override
  String fromJson(String url) {
    final segments = url.split('/');
    final id = int.parse(segments[segments.length - 2]);
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }

  @override
  String toJson(String imageUrl) => imageUrl;
}
