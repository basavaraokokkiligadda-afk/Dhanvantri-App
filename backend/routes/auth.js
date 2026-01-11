const express = require('express');
const router = express.Router();

// Mock user database
const users = [
  { id: 1, email: 'patient@test.com', password: 'password123', type: 'patient', name: 'John Doe' },
  { id: 2, email: 'hospital@test.com', password: 'password123', type: 'hospital', name: 'City Hospital' }
];

// Login endpoint
router.post('/login', (req, res) => {
  const { email, password } = req.body;
  
  const user = users.find(u => u.email === email && u.password === password);
  
  if (!user) {
    return res.status(401).json({
      success: false,
      message: 'Invalid email or password'
    });
  }
  
  res.json({
    success: true,
    message: 'Login successful',
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      type: user.type
    },
    token: 'mock_jwt_token_' + user.id
  });
});

// Register endpoint
router.post('/register', (req, res) => {
  const { name, email, password, type } = req.body;
  
  const existingUser = users.find(u => u.email === email);
  if (existingUser) {
    return res.status(400).json({
      success: false,
      message: 'Email already registered'
    });
  }
  
  const newUser = {
    id: users.length + 1,
    name,
    email,
    password,
    type: type || 'patient'
  };
  
  users.push(newUser);
  
  res.status(201).json({
    success: true,
    message: 'Registration successful',
    user: {
      id: newUser.id,
      name: newUser.name,
      email: newUser.email,
      type: newUser.type
    }
  });
});

module.exports = router;
