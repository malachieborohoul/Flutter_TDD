import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/features/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/features/authentication/data/repositories/authentication_repository_implementation.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repositoryImplementation;
  setUp(() {
    remoteDataSource = MockAuthenticationRemoteDataSource();
    repositoryImplementation =
        AuthenticationRepositoryImplementation(remoteDataSource);
  });
  const tException =
      APIException(message: "Unknown Error Occured", statusCode: 500);
  group('createUser', () {
    const createdAt = 'createdAt';
    const name = 'name';
    const avatar = 'avatar';

    test(
        'should call the [RemoteDataSource.createUser] and complete '
        'successfully when the call to the remote source is successful ',
        () async {
      //Arrange
      when(() => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar')))
          .thenAnswer((_) async => Future.value());

      //Act
      final result = await repositoryImplementation.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      //Assert

      expect(result, equals(const Right(null)));

      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return a [APIFailure] when the call to the remote source is unsucessfull',
        () async {
      when(() => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'))).thenThrow(tException);

      final result = await repositoryImplementation.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      expect(
          result,
          equals(Left(APIFailure(
              message: tException.message,
              statusCode: tException.statusCode))));

      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getUsers', () {
    test(
      'should call the [RemoteDataSource.getUsers] and complete '
      'successfully when the call to the remote source is successful ',
      () async {
        // Notez l'ajout de async ici
        // Arrange
        when(() => remoteDataSource.getUsers()).thenAnswer(
          (_) async => [const UserModel.empty()],
        );

        // Act
        final result =
            await repositoryImplementation.getUsers(); // Ajout de await ici

        // Assert
        expect(result, isA<Right<Failure, List<UserModel>>>());

        verify(() => remoteDataSource.getUsers()).called(1); // Changé ici

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
        'should return a [APIFailure] when the call to the remote source is unsucessfull',
        () async {
      when(() => remoteDataSource.getUsers())
          .thenThrow(tException);

      final result = await repositoryImplementation.getUsers();

      expect(result, equals(Left(APIFailure.fromException(tException))));

      verify(() => remoteDataSource.getUsers()).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
