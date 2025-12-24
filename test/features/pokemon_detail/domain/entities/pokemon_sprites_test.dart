import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/pokemon_detail/domain/entities/pokemon_sprites.dart';

void main() {
  group('PokemonSprites Entity', () {
    test(
      'GIVEN two PokemonSprites instances with same values '
      'WHEN they are compared '
      'THEN they should be equal',
      () {
        // Arrange
        const sprites1 = PokemonSprites(
          frontDefault: 'https://example.com/front.png',
          frontShiny: 'https://example.com/shiny.png',
          officialArtwork: 'https://example.com/artwork.png',
        );

        const sprites2 = PokemonSprites(
          frontDefault: 'https://example.com/front.png',
          frontShiny: 'https://example.com/shiny.png',
          officialArtwork: 'https://example.com/artwork.png',
        );

        // Act & Assert
        expect(sprites1, equals(sprites2));
      },
    );

    test(
      'GIVEN a PokemonSprites instance '
      'WHEN accessing its properties '
      'THEN they should return correct values',
      () {
        // Arrange
        const sprites = PokemonSprites(
          frontDefault: 'https://example.com/front.png',
          frontShiny: 'https://example.com/front-shiny.png',
          frontFemale: 'https://example.com/front-female.png',
          frontShinyFemale: 'https://example.com/front-shiny-female.png',
          backDefault: 'https://example.com/back.png',
          backShiny: 'https://example.com/back-shiny.png',
          backFemale: 'https://example.com/back-female.png',
          backShinyFemale: 'https://example.com/back-shiny-female.png',
          officialArtwork: 'https://example.com/artwork.png',
        );

        // Act & Assert
        expect(sprites.frontDefault, 'https://example.com/front.png');
        expect(sprites.frontShiny, 'https://example.com/front-shiny.png');
        expect(sprites.frontFemale, 'https://example.com/front-female.png');
        expect(
          sprites.frontShinyFemale,
          'https://example.com/front-shiny-female.png',
        );
        expect(sprites.backDefault, 'https://example.com/back.png');
        expect(sprites.backShiny, 'https://example.com/back-shiny.png');
        expect(sprites.backFemale, 'https://example.com/back-female.png');
        expect(
          sprites.backShinyFemale,
          'https://example.com/back-shiny-female.png',
        );
        expect(sprites.officialArtwork, 'https://example.com/artwork.png');
      },
    );
  });
}
