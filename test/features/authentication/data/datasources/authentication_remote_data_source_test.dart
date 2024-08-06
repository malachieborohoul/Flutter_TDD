import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/features/authentication/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImplementation(client);
    registerFallbackValue(Uri());
  });

  const createdAt = "createdAt";
  const name = "name";
  const avatar = "avatar";
  group('createUser', () {
    test('should complete successfully when status code is 200 or 201',
        () async {
      when(() => client.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('User created successfully', 201));

      final methodCall = await remoteDataSource.createUser;

      expect(methodCall(createdAt: createdAt, name: name, avatar: avatar),
          completes);

      verify(() => client.post(Uri.https(kBaseUrl, kCreateUserEndpoint),
              body: jsonEncode(
                  {'createdAt': createdAt, 'name': name, 'avatar': avatar})))
          .called(1);

      verifyNoMoreInteractions(client);
    });

    test('should throw an [APIException] when the status is not 200 or 201',
        () async {
      when(() => client.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('Invalid email address', 400));

      final methodCall = remoteDataSource.createUser;

      expect(
        () async =>
            methodCall(createdAt: createdAt, name: name, avatar: avatar),
        throwsA(
          const APIException(
            message: 'Invalid email address',
            statusCode: 400,
          ),
        ),
      );

      verify(() => client.post(
              Uri.parse(
                '$kBaseUrl$kCreateUserEndpoint',
              ),
              body: jsonEncode(
                  {'createdAt': createdAt, 'name': name, 'avatar': avatar})))
          .called(1);

      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    test('should return [List<User>] when status code is 200', () async {
      when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200));

      final result = await remoteDataSource.getUsers();

      expect(result, equals(tUsers));
      verify(() => client.get(Uri.https(kBaseUrl, kCreateUserEndpoint)))
          .called(1);

      verifyNoMoreInteractions(client);
    });
    const tMessage = "Server down";
    test('should throw an [APIException if status is not 200]', () async {
      when(() => client.get(any()))
          .thenAnswer((_) async => http.Response(tMessage, 500));

      final methodCall = await remoteDataSource.getUsers;

      expect(methodCall(),
          throwsA(const APIException(message: tMessage, statusCode: 500)));

      verify(() => client.get(Uri.https(kBaseUrl, kCreateUserEndpoint)))
          .called(1);

      verifyNoMoreInteractions(client);
    });
  });
}
