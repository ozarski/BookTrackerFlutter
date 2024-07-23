
class ObjectNotFoundError extends BookRepositoryError {
  ObjectNotFoundError(super.message);
}

class InvalidBookInputError extends BookRepositoryError {
  InvalidBookInputError(super.message);
}

class BookRepositoryError extends Error {
  final String message;

  BookRepositoryError(this.message);

  @override
  String toString() {
    return 'DatabaseError: $message';
  }
}