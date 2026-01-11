const express = require('express');
const router = express.Router();

// Mock medicines database
const medicines = [
  {
    id: 1,
    name: 'Paracetamol 500mg',
    category: 'Pain Relief',
    price: 50,
    manufacturer: 'MediPharma',
    inStock: true,
    description: 'For fever and pain relief',
    image: 'https://via.placeholder.com/100'
  },
  {
    id: 2,
    name: 'Amoxicillin 250mg',
    category: 'Antibiotic',
    price: 120,
    manufacturer: 'HealthCare Ltd',
    inStock: true,
    description: 'Antibiotic for bacterial infections',
    image: 'https://via.placeholder.com/100'
  },
  {
    id: 3,
    name: 'Vitamin D3',
    category: 'Supplements',
    price: 200,
    manufacturer: 'WellnessPharm',
    inStock: true,
    description: 'Daily vitamin supplement',
    image: 'https://via.placeholder.com/100'
  }
];

// Get all medicines
router.get('/medicines', (req, res) => {
  const { category, search } = req.query;
  
  let filteredMedicines = medicines;
  
  if (category) {
    filteredMedicines = filteredMedicines.filter(m => 
      m.category.toLowerCase() === category.toLowerCase()
    );
  }
  
  if (search) {
    filteredMedicines = filteredMedicines.filter(m => 
      m.name.toLowerCase().includes(search.toLowerCase())
    );
  }
  
  res.json({
    success: true,
    count: filteredMedicines.length,
    medicines: filteredMedicines
  });
});

// Get medicine by ID
router.get('/medicines/:id', (req, res) => {
  const medicine = medicines.find(m => m.id === parseInt(req.params.id));
  
  if (!medicine) {
    return res.status(404).json({
      success: false,
      message: 'Medicine not found'
    });
  }
  
  res.json({
    success: true,
    medicine
  });
});

module.exports = router;
