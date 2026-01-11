# 🚀 Quick Setup Script for Dhanvantri Healthcare App

Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  🏥 Dhanvantri Healthcare - Setup Script" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Step 1: Install Flutter Dependencies
Write-Host "📦 Step 1/3: Installing Flutter dependencies..." -ForegroundColor Yellow
flutter pub get

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Flutter dependencies installed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to install Flutter dependencies" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Install Backend Dependencies
Write-Host "📦 Step 2/3: Installing Backend dependencies..." -ForegroundColor Yellow
Set-Location backend
npm install

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Backend dependencies installed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to install Backend dependencies" -ForegroundColor Red
    Set-Location ..
    exit 1
}

Set-Location ..
Write-Host ""

# Step 3: Verify Setup
Write-Host "🔍 Step 3/3: Verifying setup..." -ForegroundColor Yellow
Write-Host "Checking Flutter..." -ForegroundColor Gray
flutter doctor --version

Write-Host "Checking Node.js..." -ForegroundColor Gray
node --version

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✅ Setup Complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "📚 Next Steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Start Backend Server:" -ForegroundColor White
Write-Host "   cd backend" -ForegroundColor Cyan
Write-Host "   npm start" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. In a new terminal, Run Flutter App:" -ForegroundColor White
Write-Host "   flutter run" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. API Base URL:" -ForegroundColor White
Write-Host "   http://localhost:3000/api" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Test Credentials:" -ForegroundColor White
Write-Host "   Email: patient@test.com" -ForegroundColor Cyan
Write-Host "   Password: password123" -ForegroundColor Cyan
Write-Host ""
Write-Host "📖 For more details, see FLUTTER_README.md" -ForegroundColor Gray
Write-Host ""
