// Mocks generated by Mockito 5.4.4 from annotations
// in book_tracker/test/google_books_repository_tests.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:book_tracker/features/search_books/data/data_sources/google_books_api_service.dart'
    as _i3;
import 'package:dio/dio.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDio_0 extends _i1.SmartFake implements _i2.Dio {
  _FakeDio_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GoogleBooksApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockGoogleBooksApiService extends _i1.Mock
    implements _i3.GoogleBooksApiService {
  MockGoogleBooksApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get baseUrl => (super.noSuchMethod(
        Invocation.getter(#baseUrl),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#baseUrl),
        ),
      ) as String);

  @override
  _i2.Dio get dio => (super.noSuchMethod(
        Invocation.getter(#dio),
        returnValue: _FakeDio_0(
          this,
          Invocation.getter(#dio),
        ),
      ) as _i2.Dio);

  @override
  _i5.Future<Map<String, dynamic>> searchBooks(String? keywords) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchBooks,
          [keywords],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
}
