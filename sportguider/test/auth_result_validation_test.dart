import 'package:flutter_test/flutter_test.dart';
import 'package:sportguider/core/utils/AuthResult/auth_result.dart';

void main() {
  group('AuthResult.validateEmail', () {
    test('rejects empty email', () {
      expect(AuthResult.validateEmail(''), isNotNull);
      expect(AuthResult.validateEmail('   '), isNotNull);
    });

    test('rejects obvious invalid emails', () {
      expect(AuthResult.validateEmail('plainaddress'), isNotNull);
      expect(AuthResult.validateEmail('a@'), isNotNull);
      expect(AuthResult.validateEmail('@b.com'), isNotNull);
      expect(AuthResult.validateEmail('a@b'), isNotNull);
      expect(AuthResult.validateEmail('a@b..com'), isNotNull);
      expect(AuthResult.validateEmail('a..b@c.com'), isNotNull);
      expect(AuthResult.validateEmail('a@-b.com'), isNotNull);
    });

    test('accepts normal emails and normalizes domain case', () {
      expect(AuthResult.validateEmail('user@example.com'), isNull);
      expect(AuthResult.validateEmail('user@EXAMPLE.COM'), isNull);
      expect(AuthResult.normalizeEmail('user@EXAMPLE.COM'), 'user@example.com');
    });
  });

  group('AuthResult.validatePassword', () {
    test('rejects empty, whitespace and short passwords', () {
      expect(AuthResult.validatePassword(''), isNotNull);
      expect(AuthResult.validatePassword('Abc 123!'), isNotNull);
      expect(AuthResult.validatePassword('Ab1!a'), isNotNull);
    });

    test('requires upper, lower, digit and special', () {
      expect(AuthResult.validatePassword('abcdefgh1!'), isNotNull); // no upper
      expect(AuthResult.validatePassword('ABCDEFGH1!'), isNotNull); // no lower
      expect(AuthResult.validatePassword('Abcdefgh!!'), isNotNull); // no digit
      expect(AuthResult.validatePassword('Abcdefgh12'), isNotNull); // no special
    });

    test('accepts strong password', () {
      expect(AuthResult.validatePassword('Abcdefg1!'), isNull);
    });
  });

  group('AuthResult.validatePasswordForLogin', () {
    test('rejects empty and whitespace passwords', () {
      expect(AuthResult.validatePasswordForLogin(''), isNotNull);
      expect(AuthResult.validatePasswordForLogin('pass word'), isNotNull);
    });

    test('accepts weak but non-empty password (backwards compatible)', () {
      expect(AuthResult.validatePasswordForLogin('123456'), isNull);
    });
  });
}

