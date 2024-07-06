import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar});

  Future<List<User>> getUsers();
}
