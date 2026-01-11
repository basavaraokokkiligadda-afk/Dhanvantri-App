/// Appointment model
class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String? doctorImage;
  final String specialty;
  final DateTime date;
  final String time;
  final String type;
  final String status;
  final double amount;
  final String? notes;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    this.doctorImage,
    required this.specialty,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    required this.amount,
    this.notes,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      doctorId: json['doctorId']?.toString() ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorImage: json['doctorImage'],
      specialty: json['specialty'] ?? '',
      date: DateTime.parse(json['date']),
      time: json['time'] ?? '',
      type: json['type'] ?? 'consultation',
      status: json['status'] ?? 'pending',
      amount: (json['amount'] ?? 0).toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorImage': doctorImage,
      'specialty': specialty,
      'date': date.toIso8601String(),
      'time': time,
      'type': type,
      'status': status,
      'amount': amount,
      'notes': notes,
    };
  }

  Appointment copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? doctorName,
    String? doctorImage,
    String? specialty,
    DateTime? date,
    String? time,
    String? type,
    String? status,
    double? amount,
    String? notes,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorImage: doctorImage ?? this.doctorImage,
      specialty: specialty ?? this.specialty,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
    );
  }
}
