import '../models/doctor_model.dart';

/// Centralized mock doctor data
class MockDoctors {
  MockDoctors._();

  static final List<Doctor> doctors = [
    Doctor(
      id: '1',
      name: 'Dr. Sarah Johnson',
      specialization: 'Cardiologist',
      imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
      rating: 4.8,
      reviewCount: 245,
      experience: 12,
      hospital: 'City General Hospital',
      address: '123 Medical Center, Downtown',
      about:
          'Specialized in interventional cardiology with over 12 years of experience. Expert in treating complex heart conditions.',
      fee: 1500,
      isAvailable: true,
    ),
    Doctor(
      id: '2',
      name: 'Dr. Michael Chen',
      specialization: 'Dermatologist',
      imageUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
      rating: 4.7,
      reviewCount: 189,
      experience: 8,
      hospital: 'Skin Care Clinic',
      address: '456 Health Avenue',
      about:
          'Expert in cosmetic and medical dermatology. Specialized in acne treatment and anti-aging procedures.',
      fee: 1200,
      isAvailable: true,
    ),
    Doctor(
      id: '3',
      name: 'Dr. Emily Williams',
      specialization: 'Pediatrician',
      imageUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
      rating: 4.9,
      reviewCount: 312,
      experience: 15,
      hospital: 'Children\'s Hospital',
      address: '789 Kids Lane',
      about:
          'Dedicated pediatrician with a gentle approach. Specialist in child development and preventive care.',
      fee: 1000,
      isAvailable: true,
    ),
    Doctor(
      id: '4',
      name: 'Dr. David Lee',
      specialization: 'Orthopedic',
      imageUrl: 'https://randomuser.me/api/portraits/men/4.jpg',
      rating: 4.6,
      reviewCount: 278,
      experience: 10,
      hospital: 'Bone & Joint Center',
      address: '321 Ortho Street',
      about:
          'Sports medicine specialist. Expert in joint replacement and minimally invasive orthopedic surgery.',
      fee: 1800,
      isAvailable: false,
    ),
    Doctor(
      id: '5',
      name: 'Dr. Priya Sharma',
      specialization: 'Neurologist',
      imageUrl: 'https://randomuser.me/api/portraits/women/5.jpg',
      rating: 4.8,
      reviewCount: 298,
      experience: 14,
      hospital: 'Neuro Care Institute',
      address: '555 Brain Avenue',
      about:
          'Specialized in stroke management and epilepsy treatment. Published researcher in neuroscience.',
      fee: 2000,
      isAvailable: true,
    ),
    Doctor(
      id: '6',
      name: 'Dr. James Rodriguez',
      specialization: 'General Physician',
      imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
      rating: 4.5,
      reviewCount: 156,
      experience: 6,
      hospital: 'Family Health Clinic',
      address: '111 Wellness Road',
      about:
          'Primary care physician providing comprehensive healthcare services for all ages.',
      fee: 800,
      isAvailable: true,
    ),
  ];

  static Doctor? getDoctorById(String id) {
    try {
      return doctors.firstWhere((doctor) => doctor.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Doctor> getDoctorsBySpecialty(String specialty) {
    if (specialty == 'All') return doctors;
    return doctors
        .where((doctor) => doctor.specialization == specialty)
        .toList();
  }

  static List<Doctor> getAvailableDoctors() {
    return doctors.where((doctor) => doctor.isAvailable).toList();
  }
}
