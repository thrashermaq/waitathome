class QueueTypes {
  static const SMALL = const QueueTypes._(0, 'Klein', 'Kleine Schlange');
  static const MEDIUM = const QueueTypes._(1, 'Mittel', 'Mittlere Schlange');
  static const BIG = const QueueTypes._(2, 'Gross', 'Grosse Schlange');
  static const UNKNOWN =
      const QueueTypes._(-1, 'Unbekannt', 'Warteschlange ist unbekannt');

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
