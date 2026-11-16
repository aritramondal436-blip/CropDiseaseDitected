import os
from dotenv import load_dotenv
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime
from google import genai
from PIL import Image
import io
import json

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- FIREBASE SETUP ---
try:
    cred = credentials.Certificate("firebase_credentials.json")
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    print("✅ Firebase Connected Successfully!")
except Exception as e:
    print(f"❌ Firebase Connection Failed: {e}")

# --- AI SETUP ---
load_dotenv() # Loads the hidden .env file

# Use the key from the hidden file instead of plain text
client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

# --- REAL AI FUNCTION ---
def analyze_leaf(image_bytes):
    image = Image.open(io.BytesIO(image_bytes))
    
    prompt = """
    You are an expert agricultural botanist. Analyze this plant leaf image.
    Identify the crop, any disease present, and recommend a treatment.
    Respond ONLY with a valid JSON object matching this exact structure, nothing else:
    {
        "crop": "Name of crop",
        "disease": "Name of disease or 'Healthy'",
        "confidence": "XX%",
        "status": "Disease detected or Healthy",
        "treatment": "Brief treatment recommendation"
    }
    """
    
    # Send request using the new SDK syntax and current model
    response = client.models.generate_content(
        model='gemini-3.6-flash',
        contents=[prompt, image]
    )
    
    result_text = response.text.replace("```json", "").replace("```", "").strip()
    return json.loads(result_text)

# --- THE ENDPOINT ---
@app.post("/api/detect-disease")
async def detect_disease(file: UploadFile = File(...)):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")

    try:
        image_bytes = await file.read()
        ai_result = analyze_leaf(image_bytes)

        scan_data = {
            "scan_date": datetime.utcnow().isoformat(),
            "crop_name": ai_result["crop"],
            "disease_name": ai_result["disease"],
            "confidence_score": ai_result["confidence"],
            "treatment_recommendation": ai_result["treatment"]
        }

        db.collection("scans").add(scan_data)
        
        return ai_result

    except Exception as e:
        print(f"Server Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))
