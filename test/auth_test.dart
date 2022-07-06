import 'dart:math';

import 'package:littlenotes/services/auth/auth_exceptions.dart';
import 'package:littlenotes/services/auth/auth_provider.dart';
import 'package:littlenotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test(
      'Should not be initialized to begin with',
      () {
        expect(provider.isInitialized, false);
      },
    );
    test(
      'Cannot log out if not initialized',
      () {
        expect(
          provider.signOut(),
          throwsA(const TypeMatcher<NotInitializedException>()),
        );
      },
    );
    test(
      'Should be able to initialized',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
    );
    test(
      'User should be null after initialization',
      () {
        expect(provider.currentUser, null);
      },
    );
    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test(
      'Create user should delegate to signIn() function',
      () async {
        final badEmailUser = provider.createUser(
          email: 'foo@bar.com',
          password: 'anypassword',
        );

        expect(badEmailUser,
            throwsA(const TypeMatcher<UserNotFoundAuthException>()));

        final badPasswordUser = provider.createUser(
          email: 'anyemail@bar.com',
          password: 'foobar',
        );

        expect(badPasswordUser,
            throwsA(const TypeMatcher<WrongPasswordAuthException>()));

        final user = await provider.createUser(
          email: 'anyemail@bar.com',
          password: 'anypassword',
        );

        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      },
    );
    test(
      'Signed in user should be able to verify',
      () {
        provider.sendEmailVerification();
        final user = provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
      },
    );
    test(
      'Should be able to sign out and sign in again',
      () async {
        await provider.signOut();
        await provider.signIn(email: 'email', password: 'password');
        final user = provider.currentUser;
        expect(user, isNotNull);
      },
    );
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return signIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> signOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }
}
