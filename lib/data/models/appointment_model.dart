/// Production-grade Appointment Model
class Appointment {
  final String id;
  final String? patientId;
  final String? doctorId;
  final String doctorName;
  final String? doctorImage;
  final String specialty;
  final DateTime date;
  final String time;
  final String type; // 'video', 'clinic', 'home'
  final String status; // 'upcoming', 'completed', 'cancelled'
  final double fee;
  final String? notes;
  final DateTime? createdAt;

  Appointment({
    required this.id,
    this.patientId,
    this.doctorId,
    required this.doctorName,
    this.doctorImage,
    required this.specialty,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    required this.fee,
    this.notes,
    this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      patientId: json['patientId']?.toString(),
      doctorId: json['doctorId']?.toString(),
      doctorName: json['doctorName'] ?? '',
      doctorImage: json['doctorImage'],
      specialty: json['specialty'] ?? '',
      date: json['date'] is String
          ? DateTime.parse(json['date'])
          : json['date'] as DateTime,
      time: json['time'] ?? '',
      type: json['type'] ?? 'video',
      status: json['status'] ?? 'upcoming',
      fee: (json['fee'] ?? json['amount'] ?? 0).toDouble(),
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is String
              ? DateTime.parse(json['createdAt'])
              : json['createdAt'] as DateTime)
          : null,
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
      'fee': fee,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
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
    double? fee,
    String? notes,
    DateTime? createdAt,
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
      fee: fee ?? this.fee,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isUpcoming => status == 'upcoming' && date.isAfter(DateTime.now());
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}
