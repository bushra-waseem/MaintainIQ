# 🔧 MaintainIQ — Software Maintenance Cost Estimator

**MaintainIQ** is a professional Flutter-based mobile application that estimates annual software maintenance costs using the **COCOMO II mathematical model** for systems operating 5+ years.

---

## ✨ Features

- 📊 **Cost Estimation** — COCOMO II mathematical model
- 🤖 **AI Chatbot** — Grok AI (Urdu & English)
- 📄 **PDF Report** — Professional downloadable report
- 🔔 **Real-time Notifications** — Instant alerts
- 🔐 **Firebase Authentication** — Email & Google Sign-In
- 📁 **Estimation History** — Firebase Firestore
- 👤 **User Profile** — Account management
- 🌙 **Modern UI** — Purple glassmorphism design

---

## 🚀 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter (Dart) |
| **Authentication** | Firebase Auth |
| **Database** | Firebase Firestore |
| **AI Chatbot** | Grok API |
| **PDF Generation** | Flutter PDF Package |
| **Notifications** | Flutter Local Notifications |
| **Model** | COCOMO II |

---

## 📐 Mathematical Model

```
Annual Maintenance Cost = 
  Dev Cost × Base Rate × Size Factor × Age Factor × Inflation

Base Rate   = 15% + (Complexity × 2.5%) + (TechDebt × 3%)
Size Factor = Small=1.0 | Medium=1.3 | Large=1.6 | Enterprise=2.0
Age Factor  = 1.0 + (Age × 0.04) per year
Inflation   = 3% per year compounded
```

---

## 🗺️ App Flow Diagram

```mermaid
flowchart TD
    A([📱 App Launch]) --> B[Splash Screen]
    B --> C{User Logged In?}
    C -->|No| D[Login Screen]
    C -->|Yes| H[Home Screen]
    D --> E[Email/Password Login]
    D --> F[Google Sign-In]
    D --> G[Register Account]
    E --> H
    F --> H
    G --> H
    H --> I[Cost Estimation Form]
    H --> J[AI Chatbot]
    H --> K[History]
    H --> L[Notifications]
    H --> M[Profile]
    I --> N[COCOMO II Calculation]
    N --> O[Results Screen]
    O --> P[📄 PDF Report]
    O --> Q[💾 Save to Firestore]
    Q --> K
```

---

## 🏗️ Architecture Diagram

```mermaid
graph LR
    subgraph Mobile["📱 Flutter Mobile App"]
        UI[UI Screens]
        Services[Services Layer]
        Models[Data Models]
    end

    subgraph Firebase["🔥 Firebase"]
        Auth[Firebase Auth]
        Firestore[Firestore DB]
    end

    subgraph AI["🤖 AI Services"]
        Gemini[Gemini API]
    end

    subgraph Local["📦 Local"]
        PDF[PDF Generator]
        Notif[Notifications]
    end

    UI --> Services
    Services --> Auth
    Services --> Firestore
    Services --> Grok
    Services --> PDF
    Services --> Notif
    Models --> Services
```

---

## 👥 Use Case Diagram

```mermaid
graph TD
    User((👤 User))
    
    User --> UC1[Register / Login]
    User --> UC2[Estimate Cost]
    User --> UC3[Chat with AI]
    User --> UC4[Download PDF]
    User --> UC5[View History]
    User --> UC6[Get Notifications]
    User --> UC7[Manage Profile]

    UC1 --> S1[[Firebase Auth]]
    UC2 --> S2[[COCOMO II Engine]]
    UC3 --> S3[[GROK AI]]
    UC4 --> S4[[PDF Service]]
    UC5 --> S5[[Firestore DB]]
    UC6 --> S6[[Notification Service]]
```

---

## 📁 Project Structure

```
maintainiq/
├── lib/
│   ├── main.dart
│   ├── constants/
│   │   ├── colors.dart
│   │   └── strings.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   └── estimation_model.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   ├── gemini_service.dart
│   │   ├── cost_calculator.dart
│   │   ├── notification_service.dart
│   │   └── pdf_service.dart
│   └── screens/
│       ├── auth/
│       │   ├── login_screen.dart
│       │   └── register_screen.dart
│       ├── splash_screen.dart
│       ├── home_screen.dart
│       ├── estimation_screen.dart
│       ├── result_screen.dart
│       ├── chatbot_screen.dart
│       ├── history_screen.dart
│       ├── notifications_screen.dart
│       └── profile_screen.dart
└── pubspec.yaml
```

---

## 🛠️ How to Run

**1. Clone the Repository:**
```bash
git clone https://github.com/bushra-waseem/MaintainIQ.git
cd MaintainIQ
```

**2. Install Dependencies:**
```bash
flutter pub get
```

**3. Firebase Setup:**
- Create project at [console.firebase.google.com](https://console.firebase.google.com)
- Enable Authentication (Email + Google)
- Enable Firestore Database
- Download `google-services.json` → place in `android/app/`
- Run `flutterfire configure`

**4. Add API Key:**
```dart
// lib/constants/strings.dart
static const geminiApiKey = 'YOUR_GEMINI_API_KEY';
```

**5. Run:**
```bash
flutter run
```

---

## 📲 Download APK

> [⬇️ Download MaintainIQ.apk](https://github.com/bushra-waseem/MaintainIQ/releases/download/v1.0.0/MaintainIQ.apk)

---

## 👩‍💻 Developer

**Bushra Waseem**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://www.linkedin.com/in/bushraa-waseem)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black)](https://github.com/bushra-waseem)

---

> Built with 💜 Flutter | Firebase | Grok AI
