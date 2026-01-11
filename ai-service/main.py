from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import uvicorn
from datetime import datetime

app = FastAPI(
    title="Dhanvantri AI Health Assistant",
    description="AI-powered health assistant for symptom analysis and prescription review",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============ MODELS ============

class SymptomCheckRequest(BaseModel):
    symptoms: List[str]
    age: Optional[int] = None
    gender: Optional[str] = None
    budget: Optional[float] = None

class PrescriptionAnalysisRequest(BaseModel):
    prescription_text: str
    patient_age: Optional[int] = None
    existing_conditions: Optional[List[str]] = []

class DoctorRecommendation(BaseModel):
    specialization: str
    priority: str
    reason: str
    estimated_consultation_fee: float

class HospitalRecommendation(BaseModel):
    name: str
    rating: float
    estimated_cost: float
    distance: Optional[str] = None

class SymptomCheckResponse(BaseModel):
    severity: str
    recommended_specialists: List[DoctorRecommendation]
    suggested_hospitals: List[HospitalRecommendation]
    first_aid_tips: List[str]
    urgency_level: str

class PrescriptionAnalysisResponse(BaseModel):
    medicines: List[dict]
    suggested_tests: List[str]
    precautions: List[str]
    side_effects: List[str]
    confidence: float

# ============ RULE-BASED LOGIC ============

SYMPTOM_SPECIALIST_MAP = {
    "chest pain": ("Cardiologist", "high", "Chest pain requires immediate cardiac evaluation"),
    "headache": ("Neurologist", "medium", "Persistent headaches should be examined by a neurologist"),
    "fever": ("General Physician", "medium", "Fever evaluation by general physician"),
    "cough": ("Pulmonologist", "low", "Respiratory symptoms check"),
    "stomach pain": ("Gastroenterologist", "medium", "Abdominal pain evaluation"),
    "skin rash": ("Dermatologist", "low", "Skin condition examination"),
    "joint pain": ("Orthopedic", "medium", "Joint and bone specialist consultation"),
    "breathing difficulty": ("Pulmonologist", "high", "Breathing issues require immediate attention"),
    "dizziness": ("Neurologist", "medium", "Neurological assessment needed"),
}

FIRST_AID_TIPS = {
    "chest pain": [
        "Call emergency services immediately",
        "Keep the person calm and seated",
        "Loosen tight clothing",
        "Do not leave the person alone"
    ],
    "fever": [
        "Drink plenty of fluids",
        "Rest adequately",
        "Take paracetamol if needed",
        "Monitor temperature regularly"
    ],
    "headache": [
        "Rest in a quiet, dark room",
        "Stay hydrated",
        "Apply cold compress on forehead",
        "Avoid screen time"
    ],
    "breathing difficulty": [
        "Sit upright in a comfortable position",
        "Practice slow, deep breathing",
        "Loosen tight clothing",
        "Seek immediate medical help"
    ],
}

MOCK_HOSPITALS = [
    {"name": "Apollo Hospital", "rating": 4.8, "base_cost": 1500},
    {"name": "Fortis Healthcare", "rating": 4.6, "base_cost": 1200},
    {"name": "Max Hospital", "rating": 4.7, "base_cost": 1400},
    {"name": "AIIMS", "rating": 4.9, "base_cost": 800},
    {"name": "Medanta", "rating": 4.7, "base_cost": 1600},
]

# ============ ENDPOINTS ============

@app.get("/")
async def root():
    return {
        "service": "Dhanvantri AI Health Assistant",
        "version": "1.0.0",
        "status": "active",
        "endpoints": {
            "symptom_check": "/ai/symptom-check",
            "prescription_analysis": "/ai/analyze-prescription",
            "health_tips": "/ai/health-tips"
        }
    }

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat()
    }

@app.post("/ai/symptom-check", response_model=SymptomCheckResponse)
async def symptom_check(request: SymptomCheckRequest):
    """
    Rule-based symptom checker
    Suggests specialists based on symptoms
    """
    try:
        symptoms_lower = [s.lower() for s in request.symptoms]
        
        # Determine severity and urgency
        urgent_symptoms = ["chest pain", "breathing difficulty", "severe headache"]
        is_urgent = any(s in symptoms_lower for s in urgent_symptoms)
        
        urgency_level = "high" if is_urgent else "medium" if len(symptoms_lower) > 2 else "low"
        severity = "severe" if is_urgent else "moderate" if len(symptoms_lower) > 2 else "mild"
        
        # Get specialist recommendations
        recommended_specialists = []
        seen_specializations = set()
        
        for symptom in symptoms_lower:
            for key, (spec, priority, reason) in SYMPTOM_SPECIALIST_MAP.items():
                if key in symptom and spec not in seen_specializations:
                    fee = 1500 if priority == "high" else 1000 if priority == "medium" else 800
                    recommended_specialists.append(
                        DoctorRecommendation(
                            specialization=spec,
                            priority=priority,
                            reason=reason,
                            estimated_consultation_fee=fee
                        )
                    )
                    seen_specializations.add(spec)
        
        # If no specific specialist found, recommend general physician
        if not recommended_specialists:
            recommended_specialists.append(
                DoctorRecommendation(
                    specialization="General Physician",
                    priority="medium",
                    reason="General health evaluation recommended",
                    estimated_consultation_fee=800
                )
            )
        
        # Get hospital recommendations based on budget
        budget = request.budget or 2000
        suggested_hospitals = []
        
        for hospital in MOCK_HOSPITALS:
            if hospital["base_cost"] <= budget:
                suggested_hospitals.append(
                    HospitalRecommendation(
                        name=hospital["name"],
                        rating=hospital["rating"],
                        estimated_cost=hospital["base_cost"],
                        distance=f"{hospital['base_cost'] // 300} km"
                    )
                )
        
        # Get first aid tips
        first_aid_tips = []
        for symptom in symptoms_lower:
            for key, tips in FIRST_AID_TIPS.items():
                if key in symptom:
                    first_aid_tips.extend(tips)
        
        if not first_aid_tips:
            first_aid_tips = [
                "Rest adequately",
                "Stay hydrated",
                "Monitor symptoms",
                "Consult a doctor if symptoms persist"
            ]
        
        return SymptomCheckResponse(
            severity=severity,
            recommended_specialists=recommended_specialists,
            suggested_hospitals=suggested_hospitals[:3],
            first_aid_tips=list(set(first_aid_tips))[:5],
            urgency_level=urgency_level
        )
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/ai/analyze-prescription", response_model=PrescriptionAnalysisResponse)
async def analyze_prescription(request: PrescriptionAnalysisRequest):
    """
    Rule-based prescription analyzer
    Extracts medicines and suggests tests
    """
    try:
        prescription = request.prescription_text.lower()
        
        # Mock medicine extraction (in production, use NER/OCR)
        medicines = []
        common_medicines = {
            "paracetamol": {"dosage": "500mg", "frequency": "3 times daily"},
            "amoxicillin": {"dosage": "250mg", "frequency": "2 times daily"},
            "ibuprofen": {"dosage": "400mg", "frequency": "As needed"},
            "metformin": {"dosage": "500mg", "frequency": "2 times daily"},
        }
        
        for med_name, details in common_medicines.items():
            if med_name in prescription:
                medicines.append({
                    "name": med_name.capitalize(),
                    **details
                })
        
        # Suggest tests based on medicines
        suggested_tests = []
        if "metformin" in prescription:
            suggested_tests.extend(["Blood Sugar Test", "HbA1c Test"])
        if "antibiotic" in prescription or "amoxicillin" in prescription:
            suggested_tests.append("Complete Blood Count")
        if "thyroid" in prescription:
            suggested_tests.extend(["TSH Test", "T3/T4 Levels"])
        
        if not suggested_tests:
            suggested_tests = ["Complete Blood Count", "Basic Metabolic Panel"]
        
        # General precautions
        precautions = [
            "Take medicines as prescribed",
            "Complete the full course of antibiotics",
            "Avoid alcohol while on medication",
            "Consult doctor if side effects occur",
            "Store medicines in cool, dry place"
        ]
        
        # Side effects
        side_effects = [
            "Nausea or upset stomach",
            "Drowsiness",
            "Allergic reactions (rash, itching)",
            "Headache",
            "Dizziness"
        ]
        
        return PrescriptionAnalysisResponse(
            medicines=medicines if medicines else [{"name": "No medicines detected", "dosage": "-", "frequency": "-"}],
            suggested_tests=suggested_tests,
            precautions=precautions,
            side_effects=side_effects,
            confidence=0.75 if medicines else 0.3
        )
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/ai/health-tips")
async def health_tips(category: str = "general"):
    """
    Get health tips by category
    """
    tips_database = {
        "general": [
            "Drink at least 8 glasses of water daily",
            "Exercise for 30 minutes daily",
            "Get 7-8 hours of sleep",
            "Eat a balanced diet with fruits and vegetables",
            "Practice stress management techniques"
        ],
        "nutrition": [
            "Include protein in every meal",
            "Eat colorful fruits and vegetables",
            "Limit processed foods and sugar",
            "Choose whole grains over refined grains",
            "Stay hydrated throughout the day"
        ],
        "exercise": [
            "Start with 10-15 minutes of exercise daily",
            "Include both cardio and strength training",
            "Warm up before and cool down after exercise",
            "Listen to your body and rest when needed",
            "Stay consistent with your routine"
        ],
        "mental_health": [
            "Practice meditation or mindfulness",
            "Maintain social connections",
            "Take breaks from screen time",
            "Seek professional help when needed",
            "Practice gratitude daily"
        ]
    }
    
    return {
        "category": category,
        "tips": tips_database.get(category, tips_database["general"])
    }

if __name__ == "__main__":
    print("🤖 Starting Dhanvantri AI Health Assistant...")
    print("📍 Server: http://localhost:8000")
    print("📚 Docs: http://localhost:8000/docs")
    uvicorn.run(app, host="0.0.0.0", port=8000)
