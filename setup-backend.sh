#!/bin/bash

echo "🏥 Setting up Dhanvantri Backend Services..."
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. Setup Backend
echo -e "${BLUE}📦 Setting up Node.js Backend...${NC}"
cd backend-new

if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please configure .env with your MongoDB URI and Razorpay keys"
fi

echo "Installing Node.js dependencies..."
npm install

echo -e "${GREEN}✅ Backend setup complete!${NC}"
echo ""

# 2. Setup AI Service
echo -e "${BLUE}🤖 Setting up AI Service...${NC}"
cd ../ai-service

if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
fi

echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing Python dependencies..."
pip install -r requirements.txt

echo -e "${GREEN}✅ AI Service setup complete!${NC}"
echo ""

# 3. Instructions
echo -e "${BLUE}🚀 Setup Complete!${NC}"
echo ""
echo "To start the services:"
echo ""
echo "1. Backend (in terminal 1):"
echo "   cd backend-new"
echo "   npm run dev"
echo ""
echo "2. AI Service (in terminal 2):"
echo "   cd ai-service"
echo "   source venv/bin/activate  # macOS/Linux"
echo "   python main.py"
echo ""
echo "3. Flutter App (in terminal 3):"
echo "   flutter run"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"
