const express = require('express');
const router = express.Router();

// Mock conversation history
let conversations = [];

// AI Assistant chat endpoint
router.post('/chat', (req, res) => {
  const { message, userId } = req.body;
  
  if (!message) {
    return res.status(400).json({
      success: false,
      message: 'Message is required'
    });
  }
  
  // Mock AI response based on keywords
  let aiResponse = '';
  const lowerMessage = message.toLowerCase();
  
  if (lowerMessage.includes('fever') || lowerMessage.includes('temperature')) {
    aiResponse = 'For fever, I recommend:\n1. Rest and stay hydrated\n2. Take paracetamol if temperature is above 100°F\n3. Use cold compress\n4. If fever persists for more than 3 days, consult a doctor immediately.';
  } else if (lowerMessage.includes('headache') || lowerMessage.includes('pain')) {
    aiResponse = 'For headache relief:\n1. Get adequate rest\n2. Stay hydrated\n3. Avoid bright lights\n4. You can take pain relievers like paracetamol\n5. If pain is severe or persistent, please consult a doctor.';
  } else if (lowerMessage.includes('appointment') || lowerMessage.includes('doctor')) {
    aiResponse = 'I can help you book an appointment. Please specify:\n1. Type of specialist you need\n2. Preferred date and time\n3. Your symptoms\n\nWould you like me to show available doctors?';
  } else {
    aiResponse = 'I understand you\'re experiencing some health concerns. Could you please provide more details about your symptoms? This will help me assist you better.\n\nI can help with:\n• Symptom assessment\n• Booking appointments\n• Medicine information\n• Health tips';
  }
  
  const userMessage = {
    id: conversations.length + 1,
    type: 'user',
    message,
    timestamp: new Date().toISOString()
  };
  
  const aiMessage = {
    id: conversations.length + 2,
    type: 'ai',
    message: aiResponse,
    timestamp: new Date().toISOString()
  };
  
  conversations.push(userMessage, aiMessage);
  
  res.json({
    success: true,
    response: aiResponse,
    conversation: [userMessage, aiMessage]
  });
});

// Get conversation history
router.get('/history', (req, res) => {
  res.json({
    success: true,
    conversations
  });
});

// Clear conversation history
router.delete('/history', (req, res) => {
  conversations = [];
  
  res.json({
    success: true,
    message: 'Conversation history cleared'
  });
});

module.exports = router;
