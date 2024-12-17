import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_morty_app/core/utils/network_info.dart';

class MockInternetConnection extends Mock implements InternetConnection {}

void main() {
  group('NetworkInfo =>', () {
    late NetworkInfo networkInfo;
    late MockInternetConnection mockInternetConnection;

    setUp(() {
      mockInternetConnection = MockInternetConnection();
      networkInfo = NetworkInfo(connectionChecker: mockInternetConnection);
    });

    test('should return true when the device is connected to the internet',
        () async {
      when(() => mockInternetConnection.hasInternetAccess)
          .thenAnswer((_) async => true);

      final result = await networkInfo.isConnected;

      verify(() => mockInternetConnection.hasInternetAccess).called(1);
      expect(result, true);
    });

    test('should return false when the device is not connected to the internet',
        () async {
      when(() => mockInternetConnection.hasInternetAccess)
          .thenAnswer((_) async => false);

      final result = await networkInfo.isConnected;

      verify(() => mockInternetConnection.hasInternetAccess).called(1);
      expect(result, false);
    });
  });
}
