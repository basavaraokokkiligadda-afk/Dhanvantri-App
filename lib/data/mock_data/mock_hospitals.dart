import '../models/hospital_model.dart';

/// Centralized mock hospital data
class MockHospitals {
  MockHospitals._();

  static final List<Hospital> hospitals = [
    Hospital(
      id: '1',
      name: 'City General Hospital',
      imageUrl: 'https://picsum.photos/400/300?random=1',
      rating: 4.5,
      address: '123 Medical Center, Downtown',
      phone: '+1 234-567-8900',
      emergency: true,
      specialties: ['Cardiology', 'Neurology', 'Orthopedics'],
      beds: 500,
      type: 'Multi-Specialty',
    ),
    Hospital(
      id: '2',
      name: 'St. Mary\'s Medical Center',
      imageUrl: 'https://picsum.photos/400/300?random=2',
      rating: 4.7,
      address: '456 Healthcare Boulevard',
      phone: '+1 234-567-8901',
      emergency: true,
      specialties: ['Emergency Care', 'Surgery', 'ICU'],
      beds: 350,
      type: 'Multi-Specialty',
    ),
    Hospital(
      id: '3',
      name: 'Children\'s Hospital',
      imageUrl: 'https://picsum.photos/400/300?random=3',
      rating: 4.9,
      address: '789 Kids Lane',
      phone: '+1 234-567-8902',
      emergency: true,
      specialties: ['Pediatrics', 'Neonatology', 'Child Surgery'],
      beds: 200,
      type: 'Specialized',
    ),
    Hospital(
      id: '4',
      name: 'Heart Care Institute',
      imageUrl: 'https://picsum.photos/400/300?random=4',
      rating: 4.8,
      address: '321 Cardiac Street',
      phone: '+1 234-567-8903',
      emergency: false,
      specialties: ['Cardiology', 'Cardiac Surgery'],
      beds: 150,
      type: 'Specialized',
    ),
    Hospital(
      id: '5',
      name: 'Metro Community Hospital',
      imageUrl: 'https://picsum.photos/400/300?random=5',
      rating: 4.3,
      address: '555 Community Road',
      phone: '+1 234-567-8904',
      emergency: true,
      specialties: ['General Medicine', 'Emergency Care'],
      beds: 250,
      type: 'General',
    ),
  ];

  static Hospital? getHospitalById(String id) {
    try {
      return hospitals.firstWhere((hospital) => hospital.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Hospital> getEmergencyHospitals() {
    return hospitals.where((hospital) => hospital.emergency).toList();
  }

  static List<Hospital> getHospitalsBySpecialty(String specialty) {
    return hospitals
        .where((hospital) => hospital.specialties.contains(specialty))
        .toList();
  }
}
