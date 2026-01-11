const express = require('express');
const router = express.Router();

// Mock doctors database
const doctors = [
  {
    id: 1,
    name: 'Dr. Sarah Johnson',
    specialty: 'Cardiologist',
    rating: 4.8,
    experience: 15,
    hospital: 'City Medical Center',
    available: true,
    consultationFee: 500,
    image: 'https://via.placeholder.com/150'
  },
  {
    id: 2,
    name: 'Dr. Michael Chen',
    specialty: 'Pediatrician',
    rating: 4.9,
    experience: 12,
    hospital: 'Children\'s Hospital',
    available: true,
    consultationFee: 400,
    image: 'https://via.placeholder.com/150'
  },
  {
    id: 3,
    name: 'Dr. Emily Williams',
    specialty: 'Dermatologist',
    rating: 4.7,
    experience: 10,
    hospital: 'Skin Care Clinic',
    available: false,
    consultationFee: 600,
    image: 'https://via.placeholder.com/150'
  },
  {
    id: 4,
    name: 'Dr. Rajesh Kumar',
    specialty: 'Orthopedic',
    rating: 4.6,
    experience: 18,
    hospital: 'Bone & Joint Center',
    available: true,
    consultationFee: 550,
    image: 'https://via.placeholder.com/150'
  }
];

// Get all doctors
router.get('/', (req, res) => {
  const { specialty, available } = req.query;
  
  let filteredDoctors = doctors;
  
  if (specialty) {
    filteredDoctors = filteredDoctors.filter(d => 
      d.specialty.toLowerCase().includes(specialty.toLowerCase())
    );
  }
  
  if (available !== undefined) {
    filteredDoctors = filteredDoctors.filter(d => 
      d.available === (available === 'true')
    );
  }
  
  res.json({
    success: true,
    count: filteredDoctors.length,
    doctors: filteredDoctors
  });
});

// Get doctor by ID
router.get('/:id', (req, res) => {
  const doctor = doctors.find(d => d.id === parseInt(req.params.id));
  
  if (!doctor) {
    return res.status(404).json({
      success: false,
      message: 'Doctor not found'
    });
  }
  
  res.json({
    success: true,
    doctor
  });
});

// Get doctor specialties
router.get('/specialties/list', (req, res) => {
  const specialties = [...new Set(doctors.map(d => d.specialty))];
  
  res.json({
    success: true,
    specialties
  });
});

module.exports = router;
