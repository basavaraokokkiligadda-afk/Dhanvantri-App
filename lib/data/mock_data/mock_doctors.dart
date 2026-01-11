import '../models/doctor_model.dart';

/// Centralized mock doctor data
class MockDoctors {
  MockDoctors._();

  static final List<Doctor> doctors = [
    Doctor(
      id: '1',
      name: 'Dr. Sarah Johnson',
      specialty: 'Cardiologist',
      imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
      rating: 4.8,
      experience: 12,
      hospital: 'City General Hospital',
      address: '123 Medical Center, Downtown',
      about:
          'Specialized in interventional cardiology with over 12 years of experience. Expert in treating complex heart conditions.',
      consultationFee: 1500,
      isAvailable: true,
    ),
    Doctor(
      id: '2',
      name: 'Dr. Michael Chen',
      specialty: 'Dermatologist',
      imageUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
      rating: 4.7,
      experience: 8,
      hospital: 'Skin Care Clinic',
      address: '456 Health Avenue',
      about:
          'Expert in cosmetic and medical dermatology. Specialized in acne treatment and anti-aging procedures.',
      consultationFee: 1200,
      isAvailable: true,
    ),
    Doctor(
      id: '3',
      name: 'Dr. Emily Williams',
      specialty: 'Pediatrician',
      imageUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
      rating: 4.9,
      experience: 15,
      hospital: 'Children\'s Hospital',
      address: '789 Kids Lane',
      about:
          'Dedicated pediatrician with a gentle approach. Specialist in child development and preventive care.',
      consultationFee: 1000,
      isAvailable: true,
    ),
    Doctor(
      id: '4',
      name: 'Dr. David Lee',
      specialty: 'Orthopedic',
      imageUrl: 'https://randomuser.me/api/portraits/men/4.jpg',
      rating: 4.6,
      experience: 10,
      hospital: 'Bone & Joint Center',
      address: '321 Ortho Street',
      about:
          'Sports medicine specialist. Expert in joint replacement and minimally invasive orthopedic surgery.',
      consultationFee: 1800,
      isAvailable: false,
    ),
    Doctor(
      id: '5',
      name: 'Dr. Priya Sharma',
      specialty: 'Neurologist',
      imageUrl: 'https://randomuser.me/api/portraits/women/5.jpg',
      rating: 4.8,
      experience: 14,
      hospital: 'Neuro Care Institute',
      address: '555 Brain Avenue',
      about:
          'Specialized in stroke management and epilepsy treatment. Published researcher in neuroscience.',
      consultationFee: 2000,
      isAvailable: true,
    ),
    Doctor(
      id: '6',
      name: 'Dr. James Rodriguez',
      specialty: 'General Physician',
      imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
      rating: 4.5,
      experience: 6,
      hospital: 'Family Health Clinic',
      address: '111 Wellness Road',
      about:
          'Primary care physician providing comprehensive healthcare services for all ages.',
      consultationFee: 800,
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
    return doctors.where((doctor) => doctor.specialty == specialty).toList();
  }

  static List<Doctor> getAvailableDoctors() {
    return doctors.where((doctor) => doctor.isAvailable).toList();
  }
}
