# 📚 DOCUMENTATION INDEX - Dhanvantri Healthcare

> **Central hub for all project documentation**

---

## 🎯 START HERE

New to the refactored codebase? Read in this order:

1. **[README.md](README.md)** ← Start here!
   - Project overview
   - Quick start guide
   - Architecture summary

2. **[REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)**
   - What was accomplished
   - By the numbers
   - Quality checks

3. **[REFACTORING_GUIDE.md](REFACTORING_GUIDE.md)**
   - Complete refactoring details
   - Migration guide
   - Best practices

4. **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)**
   - Common tasks
   - Code snippets
   - Quick lookup

---

## 📖 DOCUMENTATION FILES

### Main Documentation

| File | Purpose | When to Use |
|------|---------|-------------|
| [README.md](README.md) | Project overview & quick start | First thing to read |
| [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) | Executive summary of changes | Want high-level overview |
| [REFACTORING_GUIDE.md](REFACTORING_GUIDE.md) | Complete refactoring documentation | Need detailed information |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | Quick lookup guide | Coding & need fast answers |

### Feature Documentation

| File | Purpose |
|------|---------|
| [FLUTTER_README.md](FLUTTER_README.md) | Original feature documentation |
| [.github/copilot-instructions.md](.github/copilot-instructions.md) | Original project status |

### Backend Documentation

| File | Purpose |
|------|---------|
| [backend/README.md](backend/README.md) | Backend API documentation |
| [backend/server.js](backend/server.js) | Server implementation |

### Archived Documentation

Located in `docs/` folder:
- `APPOINTMENTS_REFACTOR_COMPLETE.md`
- `BOTTOM_NAV_REFACTOR.md`
- `CHITCHAT_MODULE.md`
- `IMPLEMENTATION_COMPLETE.md`
- `MOBILE_FIT_REFACTOR.md`
- `UNIFIED_BOOKING_FLOW.md`
- `UNIFIED_BOOKING_GUIDE.md`

---

## 🗂️ CODE DOCUMENTATION

### Core Files

**Constants:**
- `lib/core/constants/app_constants.dart` - App-wide constants
- `lib/core/constants/api_endpoints.dart` - API endpoints

**Utilities:**
- `lib/core/utils/validators.dart` - Input validation
- `lib/core/utils/date_utils.dart` - Date/time utilities

**Theme:**
- `lib/core/theme/app_theme.dart` - Material Design 3 theme

### Providers (State Management)

**Location:** `lib/core/providers/`

- `app_state_provider.dart` - Authentication & user state
- `doctors_provider.dart` - Doctor search & filtering
- `appointments_provider.dart` - Appointment management
- `pharmacy_provider.dart` - Medicine catalog & cart
- `booking_provider.dart` - Unified booking flow

### Data Models

**Location:** `lib/data/models/`

- `doctor_model.dart` - Doctor information model
- `hospital_model.dart` - Hospital details model
- `appointment_model.dart` - Appointment data model
- `medicine_model.dart` - Medicine catalog model

### Mock Data

**Location:** `lib/data/mock_data/`

- `mock_doctors.dart` - Sample doctor data
- `mock_hospitals.dart` - Sample hospital data
- `mock_medicines.dart` - Sample medicine data

### Navigation

**Location:** `lib/navigation/`

- `app_router.dart` - Centralized routing & navigation

---

## 📝 DOCUMENTATION BY TASK

### I Want To...

#### Learn About the Refactoring
1. Read [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)
2. Then [REFACTORING_GUIDE.md](REFACTORING_GUIDE.md)

#### Start Developing
1. Read [README.md](README.md) - Setup
2. Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Common tasks
3. Check provider files for examples

#### Understand the Architecture
1. Read [README.md](README.md) - Architecture section
2. Read [REFACTORING_GUIDE.md](REFACTORING_GUIDE.md) - New structure

#### Use Providers
1. Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Provider methods
2. Check provider files in `lib/core/providers/`

#### Navigate Between Screens
1. Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Navigation section
2. Check `lib/navigation/app_router.dart`

#### Work with Data Models
1. Check `lib/data/models/` - See examples
2. Read [REFACTORING_GUIDE.md](REFACTORING_GUIDE.md) - Models section

#### Use Mock Data
1. Check `lib/data/mock_data/` - See examples
2. Import and use helper methods

#### Validate Forms
1. Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Validators
2. Check `lib/core/utils/validators.dart`

#### Format Dates
1. Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Date utils
2. Check `lib/core/utils/date_utils.dart`

#### Use Constants
1. Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Constants
2. Check `lib/core/constants/app_constants.dart`

#### Integrate Backend API
1. Read [backend/README.md](backend/README.md)
2. Check `lib/core/constants/api_endpoints.dart`
3. Replace mock data with API calls

---

## 🎓 LEARNING PATH

### Beginner Path (New to the project)

**Day 1:**
- [ ] Read [README.md](README.md)
- [ ] Run the app
- [ ] Explore the UI

**Day 2:**
- [ ] Read [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)
- [ ] Browse through code structure
- [ ] Check providers folder

**Day 3:**
- [ ] Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- [ ] Try using a provider
- [ ] Make a small change

### Intermediate Path (Ready to contribute)

**Week 1:**
- [ ] Read all documentation
- [ ] Understand the architecture
- [ ] Refactor one screen to use providers

**Week 2:**
- [ ] Fix mobile UI issues
- [ ] Add loading states
- [ ] Implement error handling

### Advanced Path (Leading development)

- [ ] Complete Phase 2: Screen refactoring
- [ ] Complete Phase 3: Mobile UI fixes
- [ ] Complete Phase 4: Booking flow
- [ ] Complete Phase 5: API integration

---

## 🔍 FIND DOCUMENTATION BY TOPIC

### Architecture
- [README.md](README.md) - Architecture overview
- [REFACTORING_GUIDE.md](REFACTORING_GUIDE.md) - Detailed structure

### State Management
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Provider usage
- Provider files - Implementation examples

### Navigation
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Navigation methods
- `lib/navigation/app_router.dart` - All routes

### Data & Models
- [REFACTORING_GUIDE.md](REFACTORING_GUIDE.md) - Models section
- `lib/data/models/` - Model implementations

### API Integration
- [backend/README.md](backend/README.md) - API documentation
- `lib/core/constants/api_endpoints.dart` - Endpoints

### UI & Theme
- [FLUTTER_README.md](FLUTTER_README.md) - Features
- `lib/core/theme/app_theme.dart` - Theme config

### Development
- [README.md](README.md) - Setup & running
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Common tasks

---

## 📊 DOCUMENTATION STATISTICS

| Type | Count |
|------|-------|
| Main Documentation | 4 files |
| Code Documentation | Well-commented |
| README files | 5 files |
| Archived Docs | 7 files |
| Total Pages | 50+ |

---

## 🤝 CONTRIBUTING TO DOCUMENTATION

When adding features, update:

1. Code comments in files
2. This index if adding new docs
3. QUICK_REFERENCE.md with new patterns
4. README.md if architecture changes

---

## 📞 GETTING HELP

1. **Check documentation** - Start with this index
2. **Read code comments** - Files are well-documented
3. **Check examples** - Provider files have examples
4. **Review tests** - When available

---

## ✅ DOCUMENTATION CHECKLIST

Before starting development:

- [ ] Read README.md
- [ ] Read REFACTORING_SUMMARY.md
- [ ] Bookmark QUICK_REFERENCE.md
- [ ] Know where to find provider examples
- [ ] Understand the architecture
- [ ] Know how to run the app

---

## 🎯 QUICK LINKS

### Essential Files
- [Main README](README.md)
- [Quick Reference](QUICK_REFERENCE.md)
- [Refactoring Guide](REFACTORING_GUIDE.md)

### Code References
- [Providers](lib/core/providers/)
- [Models](lib/data/models/)
- [Constants](lib/core/constants/)
- [Utils](lib/core/utils/)

### Setup
- [Backend Setup](backend/README.md)
- [Flutter Setup](README.md#installation)

---

**Navigate, Learn, Build! 🚀**

*Last updated: January 11, 2026*
