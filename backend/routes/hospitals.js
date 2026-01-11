const express = require('express');
const router = express.Router();

// Mock hospitals database
const hospitals = [
  {
    id: 1,
    name: 'City Medical Center',
    address: '123 Main St, Downtown',
    phone: '+1234567890',
    rating: 4.5,
    specialties: ['Cardiology', 'Neurology', 'Orthopedics'],
    emergency: true,
    beds: 250,
    image: 'https://via.placeholder.com/200'
  },
  {
    id: 2,
    name: 'Children\'s Hospital',
    address: '456 Park Ave, Uptown',
    phone: '+1234567891',
    rating: 4.8,
    specialties: ['Pediatrics', 'Neonatology'],
    emergency: true,
    beds: 150,
    image: 'https://via.placeholder.com/200'
  },
  {
    id: 3,
    name: 'Skin Care Clinic',
    address: '789 Oak Rd, Midtown',
    phone: '+1234567892',
    rating: 4.3,
    specialties: ['Dermatology', 'Cosmetic Surgery'],
    emergency: false,
    beds: 50,
    image: 'https://via.placeholder.com/200'
  }
];

// Get all hospitals
router.get('/', (req, res) => {
  const { emergency, specialty } = req.query;
  
  let filteredHospitals = hospitals;
  
  if (emergency !== undefined) {
    filteredHospitals = filteredHospitals.filter(h => 
      h.emergency === (emergency === 'true')
    );
  }
  
  if (specialty) {
    filteredHospitals = filteredHospitals.filter(h => 
      h.specialties.some(s => s.toLowerCase().includes(specialty.toLowerCase()))
    );
  }
  
  res.json({
    success: true,
    count: filteredHospitals.length,
    hospitals: filteredHospitals
  });
});

// Get hospital by ID
router.get('/:id', (req, res) => {
  const hospital = hospitals.find(h => h.id === parseInt(req.params.id));
  
  if (!hospital) {
    return res.status(404).json({
      success: false,
      message: 'Hospital not found'
    });
  }
  
  res.json({
    success: true,
    hospital
  });
});

module.exports = router;
