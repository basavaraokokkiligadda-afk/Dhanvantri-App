# 🤖 Dhanvantri AI Health Assistant

FastAPI-based AI service for health symptom analysis and prescription review.

## Features

- **Symptom Checker**: Rule-based symptom analysis with specialist recommendations
- **Prescription Analyzer**: Extract medicines and suggest medical tests
- **Health Tips**: Categorized health tips (general, nutrition, exercise, mental health)
- **Hospital Recommendations**: Budget-based hospital suggestions
- **First Aid Tips**: Immediate care suggestions based on symptoms

## Quick Start

### 1. Setup Virtual Environment

```bash
# Create virtual environment
python -m venv venv

# Activate (Windows)
venv\Scripts\activate

# Activate (macOS/Linux)
source venv/bin/activate
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Run Service

```bash
python main.py
```

Service runs on: **http://localhost:8000**

## API Endpoints

### 1. Symptom Check
**POST** `/ai/symptom-check`

```json
{
  "symptoms": ["headache", "fever"],
  "age": 30,
  "gender": "male",
  "budget": 2000
}
```

### 2. Prescription Analysis
**POST** `/ai/analyze-prescription`

```json
{
  "prescription_text": "Paracetamol 500mg, 3 times daily",
  "patient_age": 35,
  "existing_conditions": []
}
```

### 3. Health Tips
**GET** `/ai/health-tips?category=nutrition`

Categories: `general`, `nutrition`, `exercise`, `mental_health`

## Interactive Documentation

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Technology Stack

- **Framework**: FastAPI
- **Server**: Uvicorn (ASGI)
- **Validation**: Pydantic
- **Logic**: Rule-based (expandable to ML models)

## Future Enhancements

- [ ] Integration with OpenAI GPT for advanced symptom analysis
- [ ] OCR for prescription image processing
- [ ] Medical NER (Named Entity Recognition) for medicine extraction
- [ ] Integration with medical databases
- [ ] Multilingual support

## License

ISC
