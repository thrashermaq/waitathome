class QueueTypes {
  static const SMALL = const QueueTypes._(0, 'Short', 'Short queue');
  static const MEDIUM = const QueueTypes._(1, 'Middle', 'Middle queue');
  static const BIG = const QueueTypes._(2, 'Long', 'Long queue');
  static const UNKNOWN =
      const QueueTypes._(-1, 'Unknown', 'Queue size is unknown');

  final int value;
  final String buttonText;
  final String description;

  const QueueTypes._(this.value, this.buttonText, this.description);

  static QueueTypes getType(int id) {
    switch (id) {
      case 0:
        return SMALL;
      case 1:
        return MEDIUM;
      case 2:
        return BIG;
    }
    return UNKNOWN;
  }
}
