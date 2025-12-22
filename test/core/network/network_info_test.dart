import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_app/core/network/network_info.dart';

/// Mock Connectivity class for testing.
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('NetworkInfoImpl isConnected', () {
    test(
      'GIVEN an initialized NetworkInfo class WHEN connected via WiFi THEN returns true',
      () async {
        // Arrange
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Act
        final result = networkInfo.isConnected;

        // Assert
        verify(() => mockConnectivity.checkConnectivity()).called(1);
        expect(result, completion(isTrue));
      },
    );

    test(
      'GIVEN an initialized NetworkInfo class WHEN connected via mobile data THEN returns true',
      () async {
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.mobile]);

        final result = networkInfo.isConnected;

        expect(result, completion(isTrue));
      },
    );

    test(
      'GIVEN an initialized NetworkInfo class WHEN connected via ethernet THEN returns true',
      () async {
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.ethernet]);

        final result = networkInfo.isConnected;

        expect(result, completion(isTrue));
      },
    );

    test(
      'GIVEN an initialized NetworkInfo class WHEN connected via multiple sources THEN returns true',
      () async {
        when(() => mockConnectivity.checkConnectivity()).thenAnswer(
          (_) async => [
            ConnectivityResult.wifi,
            ConnectivityResult.mobile,
          ],
        );

        final result = networkInfo.isConnected;

        expect(result, completion(isTrue));
      },
    );

    test(
      'GIVEN an initialized NetworkInfo class WHEN not connected THEN returns false',
      () async {
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.none]);

        final result = networkInfo.isConnected;

        expect(result, completion(isFalse));
      },
    );

    test(
      'GIVEN an initialized NetworkInfo class WHEN connectivity result is empty THEN returns true',
      () async {
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => []);

        final result = networkInfo.isConnected;

        // Empty list is treated as connected
        expect(result, completion(isTrue));
      },
    );
  });
}
