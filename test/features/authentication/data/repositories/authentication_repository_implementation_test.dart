import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/features/authentication/data/repositories/authentication_repository_implementation.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRepositoryImplementation repositoryImplementation;
  late AuthenticationRemoteDataSource remoteDataSource;
  setUp(() {
    remoteDataSource = MockAuthenticationRemoteDataSource();
    repositoryImplementation =
        AuthenticationRepositoryImplementation(remoteDataSource);
  });
  const createdAt = 'createdAt';
  const name = 'name';
  const avatar = 'avatar';

  const tException =
      APIException(message: "Unknown Error Occured", statusCode: 500);
  group('createUser', () {
    test(
        'should call the [RemoteDataSource.createUser] and complete '
        'succesfully when the call to the remote source is successfull ',
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
      expect(result, const Right(null));
      // Verify that createUser got called
      // got called with the same values
      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
    });

    test(
        'should return a [ServerFailure] when the call to the '
        'remote source is unsuccessfull', () async {
      // Arrange
      when(() => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'))).thenThrow(tException);
      //Act

      final result = await repositoryImplementation.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      // Assert
      expect(result, equals( Left(APIFailure(message: tException.message, statusCode: tException.statusCode))));

      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
