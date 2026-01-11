# 🏥 Dhanvantri Backend Setup Script
# Run this script to set up both Node.js backend and Python AI service

Write-Host "🏥 Setting up Dhanvantri Backend Services..." -ForegroundColor Blue
Write-Host ""

# 1. Setup Backend
Write-Host "📦 Setting up Node.js Backend..." -ForegroundColor Cyan
Set-Location backend-new

if (-Not (Test-Path ".env")) {
    Write-Host "Creating .env file..."
    Copy-Item ".env.example" ".env"
    Write-Host "⚠️  Please configure .env with your MongoDB URI and Razorpay keys" -ForegroundColor Yellow
}

Write-Host "Installing Node.js dependencies..."
npm install

Write-Host "✅ Backend setup complete!" -ForegroundColor Green
Write-Host ""

# 2. Setup AI Service
Write-Host "🤖 Setting up AI Service..." -ForegroundColor Cyan
Set-Location ..\ai-service

if (-Not (Test-Path "venv")) {
    Write-Host "Creating Python virtual environment..."
    python -m venv venv
}

Write-Host "Activating virtual environment..."
.\venv\Scripts\Activate.ps1

Write-Host "Installing Python dependencies..."
pip install -r requirements.txt

Write-Host "✅ AI Service setup complete!" -ForegroundColor Green
Write-Host ""

# 3. Instructions
Write-Host "🚀 Setup Complete!" -ForegroundColor Blue
Write-Host ""
Write-Host "To start the services:" -ForegroundColor White
Write-Host ""
Write-Host "1. Backend (in terminal 1):" -ForegroundColor Yellow
Write-Host "   cd backend-new"
Write-Host "   npm run dev"
Write-Host ""
Write-Host "2. AI Service (in terminal 2):" -ForegroundColor Yellow
Write-Host "   cd ai-service"
Write-Host "   .\venv\Scripts\Activate.ps1"
Write-Host "   python main.py"
Write-Host ""
Write-Host "3. Flutter App (in terminal 3):" -ForegroundColor Yellow
Write-Host "   flutter run"
Write-Host ""
Write-Host "Happy coding! 🎉" -ForegroundColor Green

# Return to root directory
Set-Location ..
