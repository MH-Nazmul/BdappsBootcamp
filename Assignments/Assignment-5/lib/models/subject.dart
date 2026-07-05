/// A single school subject with a name and a private mark.
///
/// The mark is kept in a private [_mark] field so it can only be read through
/// the [mark] getter and can never be mutated from outside this class.
class Subject {
  final String name;
  final int _mark;

  // A named parameter cannot be a private initializing formal (`this._mark`),
  // so we take a public `mark` and assign it to the private field here.
  // ignore: prefer_initializing_formals
  Subject({required this.name, required int mark}) : _mark = mark;

  /// Read-only access to the private mark field.
  int get mark => _mark;

  /// Letter grade derived from the mark.
  /// A (>= 80), B (>= 65), C (>= 50), otherwise F.
  String get grade {
    if (_mark >= 80) return 'A';
    if (_mark >= 65) return 'B';
    if (_mark >= 50) return 'C';
    return 'F';
  }

  /// A subject is passing when its grade is anything other than F.
  bool get isPassing => grade != 'F';
}
