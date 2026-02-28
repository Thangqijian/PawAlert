# 🐾 PawAlert – AI-Driven Stray Rescue & Welfare Platform  
**KitaHack 2026 Preliminary Submission**

---

## 1️⃣ Repository Overview & Team Introduction

**PawAlert** is a modular mobile application designed to bridge the gap between stray animal emergencies and volunteer responders.

### 👥 Team Members
- **Member 1 (Jasmine Tang):** Speaker & Pitch Lead & Roadmap Strategy  
- **Member 2 (Melody Lu Yi En):** AI Specialist & Gemini Integration  
- **Member 3 (Thang Qi Jian):** Technical Architect & Firebase Management  
- **Member 4 (Hoh Wen Hao):** UX Researcher & User Validation Lead  

---

## 2️⃣ Project Overview

### 🚨 Problem Statement
Urban stray management in Malaysia is often fragmented and slow, leading to:
- Public health risks  
- Animal suffering  
- Lack of automated prioritisation in emergency cases  

### 🌍 SDG Alignment
- **SDG 3 (Target 3.3):** Managing strays prevents the spread of zoonotic diseases (e.g., rabies).  
- **SDG 15 (Target 15.5):** Protecting biodiversity by rescuing domestic strays and preventing ecosystem disruption.  

### 💡 Solution
An AI-powered ecosystem that uses multimodal analysis to:
- Triage rescue requests  
- Coordinate community-led animal welfare  

---

## 3️⃣ Key Features

### 🧠 Multimodal AI Triage
- Uses **Gemini 1.5 Flash** to analyze photos and text.
- Ranks emergencies as:
  - Critical
  - Urgent
  - Moderate

### 🗺️ Automatic Safety Protocol
- Geolocates nearby volunteers.
- Routes rescue coordinators efficiently.

### 📍 Real-Time Location Tracking
- Converts GPS coordinates to Malaysian states using Google Geocoding API.

### 🔔 Real-Time Communication
- High-concurrency chat system.
- Live unread notification badges.
- Instant rescue status updates.

---

## 4️⃣ Overview of Technologies Used

### ☁️ Google Technologies
- **Gemini 1.5 Flash** – Low-latency multimodal AI processing  
- **Firebase Firestore** – Real-time global data sync  
- **Google Maps API (Geocoding)** – Human-readable regional mapping  
- **Flutter** – Cross-platform mobile UI  

### 🛠️ Supporting Tools
- **Geolocator & Geocoding packages** – GPS access  
- **Image Picker** – Evidence capture  

---

## 5️⃣ Implementation Details & Innovation

### 🏗️ System Architecture
Service-oriented architecture:
- UI Components
- Centralized AIService
- DatabaseService
- LocationService

### 🔄 Workflow
1. User captures photo and description.  
2. Gemini AI analyzes and assigns urgency rank.  
3. Rescue alert is pushed to nearby volunteers.  

### ✨ Innovation
- Real-time "Time to Refresh" feature in chat list.
- Fixed unread badge issues.
- Improved response visibility.
- Direct API integration (no UI embedding of AI logic).

---

## 6️⃣ Challenges Faced

### ⚠️ Technical Challenge
Massive Git rebase conflicts during AI tool merging.

### ✅ Solution
- Manually reconciled dependencies in `pubspec.yaml`.
- Resolved UI mapping conflicts line-by-line.
- Ensured stable Gemini API integration.

---

## 7️⃣ Installation & Setup

### 📥 Clone Repository
```bash
git clone https://github.com/YOUR_GITHUB_URL
```

### 📦 Install Dependencies
```bash
flutter pub get
```

### 🔑 Configure Firebase
- Place `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) in correct directories.

### ▶️ Run Application
```bash
flutter run
```

---

## 8️⃣ Future Roadmap

### 🚀 Phase 1 (0–6 Months)
- Full integration of interactive Google Maps UI.

### 🏥 Phase 2 (6–12 Months)
- Automated API integration with local veterinary clinics.

### 📊 Phase 3 (12+ Months)
- Large-scale analytics dashboard for municipal stray monitoring.

---
