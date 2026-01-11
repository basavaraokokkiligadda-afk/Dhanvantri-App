const express = require('express');
const router = express.Router();

// Mock appointments database
let appointments = [
  {
    id: 1,
    patientId: 1,
    doctorId: 1,
    doctorName: 'Dr. Sarah Johnson',
    specialty: 'Cardiologist',
    date: '2026-01-15',
    time: '10:00 AM',
    status: 'confirmed',
    type: 'consultation'
  },
  {
    id: 2,
    patientId: 1,
    doctorId: 2,
    doctorName: 'Dr. Michael Chen',
    specialty: 'Pediatrician',
    date: '2026-01-18',
    time: '2:00 PM',
    status: 'pending',
    type: 'follow-up'
  }
];

// Get all appointments
router.get('/', (req, res) => {
  const { patientId, status } = req.query;
  
  let filteredAppointments = appointments;
  
  if (patientId) {
    filteredAppointments = filteredAppointments.filter(a => 
      a.patientId === parseInt(patientId)
    );
  }
  
  if (status) {
    filteredAppointments = filteredAppointments.filter(a => 
      a.status === status
    );
  }
  
  res.json({
    success: true,
    count: filteredAppointments.length,
    appointments: filteredAppointments
  });
});

// Create new appointment
router.post('/', (req, res) => {
  const { patientId, doctorId, doctorName, specialty, date, time, type } = req.body;
  
  const newAppointment = {
    id: appointments.length + 1,
    patientId,
    doctorId,
    doctorName,
    specialty,
    date,
    time,
    status: 'pending',
    type: type || 'consultation'
  };
  
  appointments.push(newAppointment);
  
  res.status(201).json({
    success: true,
    message: 'Appointment booked successfully',
    appointment: newAppointment
  });
});

// Update appointment status
router.patch('/:id', (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  
  const appointment = appointments.find(a => a.id === parseInt(id));
  
  if (!appointment) {
    return res.status(404).json({
      success: false,
      message: 'Appointment not found'
    });
  }
  
  appointment.status = status;
  
  res.json({
    success: true,
    message: 'Appointment updated successfully',
    appointment
  });
});

// Delete appointment
router.delete('/:id', (req, res) => {
  const { id } = req.params;
  const index = appointments.findIndex(a => a.id === parseInt(id));
  
  if (index === -1) {
    return res.status(404).json({
      success: false,
      message: 'Appointment not found'
    });
  }
  
  appointments.splice(index, 1);
  
  res.json({
    success: true,
    message: 'Appointment cancelled successfully'
  });
});

module.exports = router;
