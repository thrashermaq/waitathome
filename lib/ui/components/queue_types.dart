class QueueTypes {
  static const SMALL = const QueueTypes._(0, 'Klein', 'TODO');
  static const MEDIUM = const QueueTypes._(1, 'Mittel', 'TODO');
  static const BIG = const QueueTypes._(2, 'Gross', 'TODO');

  static get values => [SMALL, MEDIUM, BIG];

  final int value;
  final String buttonText;
  final String description;

  const QueueTypes._(this.value, this.buttonText, this.description);
}
