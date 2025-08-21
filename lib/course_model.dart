class Course {
  final String code;
  final String name;
  final int attended;
  final int total;

  Course({
    required this.code,
    required this.name,
    required this.attended,
    required this.total,
  });

  int get missed => total - attended;
  double get percentage => (attended / total) * 100;

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'attended': attended,
      'total': total,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      code: map['code'] as String,
      name: map['name'] as String,
      attended: map['attended'] as int,
      total: map['total'] as int,
    );
  }
}