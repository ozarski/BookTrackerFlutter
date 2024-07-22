
class ObjectNotFoundError extends DatabaseError {
  ObjectNotFoundError(super.message);
}

class DatabaseError extends Error {
  final String message;

  DatabaseError(this.message);

  @override
  String toString() {
    return 'DatabaseError: $message';
  }
}