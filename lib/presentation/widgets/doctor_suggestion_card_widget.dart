import 'package:flutter/material.dart';

class DoctorSuggestionCardWidget extends StatelessWidget {
  final String? doctorName;
  final String? specialty;
  final String? imageUrl;
  final double? rating;
  final VoidCallback? onTap;
  final VoidCallback? onBookAppointment;
  final Map<String, dynamic>? doctor;

  const DoctorSuggestionCardWidget({
    super.key,
    this.doctorName,
    this.specialty,
    this.imageUrl,
    this.rating,
    this.onTap,
    this.onBookAppointment,
    this.doctor,
  });

  String _getDoctorName() {
    if (doctorName != null) return doctorName!;
    if (doctor != null) return doctor!['name'] ?? 'Doctor';
    return 'Doctor';
  }

  String _getSpecialty() {
    if (specialty != null) return specialty!;
    if (doctor != null) return doctor!['specialty'] ?? 'General';
    return 'General';
  }

  double _getRating() {
    if (rating != null) return rating!;
    if (doctor != null) return (doctor!['rating'] ?? 4.5).toDouble();
    return 4.5;
  }

  String? _getImageUrl() {
    if (imageUrl != null) return imageUrl;
    if (doctor != null) return doctor!['imageUrl'];
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final name = _getDoctorName();
    final spec = _getSpecialty();
    final rate = _getRating();
    final imgUrl = _getImageUrl();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap ?? onBookAppointment,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                child: imgUrl != null
                    ? ClipOval(
                        child: Image.network(imgUrl, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person,
                            size: 30, color: Theme.of(context).primaryColor);
                      }))
                    : Icon(Icons.person,
                        size: 30, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      spec,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          rate.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
