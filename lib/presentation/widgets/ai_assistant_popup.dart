import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

/// AI Health Assistant Popup Widget with voice and text support
class AiAssistantPopup extends StatefulWidget {
  const AiAssistantPopup({super.key});

  @override
  State<AiAssistantPopup> createState() => _AiAssistantPopupState();
}

class _AiAssistantPopupState extends State<AiAssistantPopup>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isListening = false;
  bool _isTyping = false;
  late AnimationController _micAnimationController;

  @override
  void initState() {
    super.initState();
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Welcome message
    _addMessage(
      'Hi! I\'m your AI Health Assistant. How can I help you today?',
      isUser: false,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _micAnimationController.dispose();
    super.dispose();
  }

  void _addMessage(String text, {required bool isUser}) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: isUser));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleVoiceInput() async {
    setState(() => _isListening = !_isListening);
    HapticFeedback.mediumImpact();

    if (_isListening) {
      // Simulate voice recording
      await Future.delayed(const Duration(seconds: 2));

      // Mock voice input - simulate different languages
      final mockInputs = [
        'I have a headache and fever',
        'నాకు తలనొప్పి మరియు జ్వరం ఉంది', // Telugu
        'मुझे सिरदर्द और बुखार है', // Hindi
      ];
      final randomInput = mockInputs[DateTime.now().second % mockInputs.length];

      setState(() => _isListening = false);
      _addMessage(randomInput, isUser: true);
      _generateAIResponse(randomInput);
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _addMessage(message, isUser: true);
    _messageController.clear();
    _generateAIResponse(message);
  }

  void _generateAIResponse(String userMessage) async {
    setState(() => _isTyping = true);

    // Simulate AI thinking
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isTyping = false);

    // Mock AI responses based on keywords
    String response;
    final lowerMessage = userMessage.toLowerCase();

    // Detect language (mock)
    bool isTelugu = userMessage.contains(RegExp(r'[\u0C00-\u0C7F]'));
    bool isHindi = userMessage.contains(RegExp(r'[\u0900-\u097F]'));

    if (lowerMessage.contains('headache') ||
        lowerMessage.contains('fever') ||
        isTelugu ||
        isHindi) {
      response = isTelugu
          ? '''మీ లక్షణాల ఆధారంగా, మీరు సాధారణ జ్వరంతో బాధపడుతున్నారు.

**సిఫార్సులు:**
• విశ్రాంతి తీసుకోండి
• నీటిని ఎక్కువగా త్రాగండి
• పారసెటమాల్ తీసుకోవచ్చు

**నిపుణుడు:** సాధారణ వైద్యుడు లేదా ఫిజిషియన్

**అత్యవసరమైతే:** 24/7 ఆసుపత్రిలో చేరండి'''
          : isHindi
              ? '''आपके लक्षणों के आधार पर, आपको सामान्य बुखार हो सकता है।

**सुझाव:**
• आराम करें
• पानी ज्यादा पिएं
• पैरासिटामोल ले सकते हैं

**विशेषज्ञ:** जनरल फिजिशियन

**आपातकाल में:** 24/7 अस्पताल जाएं'''
              : '''Based on your symptoms, it appears you may have a common fever.

**Recommendations:**
• Get adequate rest
• Stay hydrated - drink plenty of water
• Take paracetamol for fever

**Specialist Needed:** General Physician

**Emergency:** Visit 24/7 hospital if symptoms worsen''';
    } else if (lowerMessage.contains('budget') ||
        lowerMessage.contains('hospital') ||
        lowerMessage.contains('cost')) {
      response = '''I can help you find hospitals within your budget!

**Top Rated Hospitals (Budget-Friendly):**

1. **Green Valley Hospital** - ₹300
   ⭐ 4.5 rating | 2.5 km away
   
2. **City General Hospital** - Free
   ⭐ 4.2 rating | 3 km away
   
3. **Continental Health Hub** - ₹500
   ⭐ 4.7 rating | 4 km away

Would you like me to book an appointment?''';
    } else if (lowerMessage.contains('cpr') ||
        lowerMessage.contains('emergency') ||
        lowerMessage.contains('first aid')) {
      response = '''**CPR Emergency Steps:**

1️⃣ Call ambulance (102/108)
2️⃣ Check if person is breathing
3️⃣ Place hands on chest center
4️⃣ Push hard & fast (100-120/min)
5️⃣ Give 30 compressions
6️⃣ 2 rescue breaths
7️⃣ Repeat until help arrives

**Remember:** Every second counts!''';
    } else if (lowerMessage.contains('chest pain') ||
        lowerMessage.contains('heart')) {
      response = '''⚠️ **Chest pain requires immediate attention!**

**Specialist Needed:** Cardiologist

**Recommended Hospitals:**
• Apollo Care Center - Dr. Sarah Johnson
• Sunrise Hospital - Dr. Rajesh Kumar

**Emergency:** Call 108 immediately if pain is severe!''';
    } else {
      response = '''I understand your concern. Let me help you!

**I can assist with:**
• Symptom analysis
• Doctor recommendations
• Hospital suggestions
• Health tips
• Emergency guidance

Please tell me more about your symptoms or what you need help with.''';
    }

    _addMessage(response, isUser: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.smart_toy, color: theme.primaryColor),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Health Assistant',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),

            // Chat Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }
                  return _buildMessageBubble(_messages[index], theme);
                },
              ),
            ),

            // Input Area
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  // Voice Input Button
                  AnimatedBuilder(
                    animation: _micAnimationController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: _isListening
                              ? [
                                  BoxShadow(
                                    color: theme.primaryColor.withValues(
                                      alpha:
                                          _micAnimationController.value * 0.5,
                                    ),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ]
                              : null,
                        ),
                        child: IconButton(
                          onPressed: _handleVoiceInput,
                          icon: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color:
                                _isListening ? Colors.red : theme.primaryColor,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: _isListening
                                ? Colors.red.withValues(alpha: 0.1)
                                : theme.primaryColor.withValues(alpha: 0.1),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),

                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: _isListening
                            ? 'Listening...'
                            : 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      enabled: !_isListening,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Send Button
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ThemeData theme) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? theme.primaryColor
              : theme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: (value + index * 0.3) % 1.0,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
