class Shift {
  final String id;
  final DateTime datetime;
  final int workers;
  final bool isFulfilled;
  final String jobsite;

  static List<String> requestFields = const [
    'id',
    'date',
    'time',
    'workers',
    'is_fulfilled',
  ];

  Shift({
    this.id,
    this.datetime,
    this.workers,
    this.isFulfilled,
    this.jobsite,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'],
      workers: json['workers'],
      isFulfilled: json['is_fulfilled'] == 1 ? true : false,
      datetime: DateTime.parse("${json['date']['shift_date']}T${json['time']}"),
      jobsite: json['date']['job']['jobsite']['name'],
    );
  }
}
