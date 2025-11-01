# 🏙️ UrbanX – AI-Powered Civic Issue Reporting App

> Empowering citizens with technology to build smarter cities

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Google Gemini](https://img.shields.io/badge/Google%20Gemini-8E75B2?style=for-the-badge&logo=google&logoColor=white)](https://deepmind.google/technologies/gemini/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)

---|------|
| **Krish Bawangade** 
| **Rajat Behera** 
| **Jatin Ukey** 
| **Vidhi Ramteke** 

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Problem Statement](#-problem-statement)
- [Solution](#-solution)
- [Key Features](#-key-features)
- [Tech Stack](#-tech-stack)
- [How It Works](#-how-it-works)
- [Installation](#-installation)
- [Project Structure](#-project-structure)
- [API Response Example](#-api-response-example)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🚀 Overview

**UrbanX** is an AI-powered civic issue reporting application designed to empower citizens and local authorities by simplifying how public problems are reported, verified, and prioritized.

Users can capture an image of a civic issue (like potholes, garbage dumps, streetlight failures, etc.), add a short description, and submit it directly through the app. Our AI verification system, powered by **Google's Gemini 2.5 Flash model**, automatically analyzes both the image and description to verify authenticity, classify the issue, generate a clear title, and assign a priority score.

---

## 🎯 Problem Statement

Current civic issue reporting systems face several challenges:
- **Manual verification** of reports is time-consuming and resource-intensive
- **Fake or irrelevant submissions** clog the system
- **Poor categorization** leads to misdirected complaints
- **Lack of priority assessment** delays critical issues
- **Communication gap** between citizens and municipal authorities

---

## 💡 Solution

UrbanX bridges the communication gap between citizens and municipal authorities by introducing an **AI-based verification and prioritization system**. It ensures that only authentic, accurately categorized, and high-priority issues reach authorities—reducing manual validation workload and increasing civic response efficiency.

### ✨ Key Features

#### 🧠 AI-Powered Verification
- Evaluates both image and description using Google Gemini 2.5 Flash
- Detects issue type (e.g., Garbage, Road Damage, Street Light)
- Verifies authenticity and relevance of reported issues
- Assigns urgency priority between 1–100 based on severity

#### 🗂️ Smart Categorization
- Uses AI understanding for accurate issue classification
- Generates short, descriptive titles automatically
- Matches image content with text description for validation

#### 📍 Real-Time Location Detection
- Automatically captures the user's current location for each issue
- Helps municipal authorities locate and address problems quickly
- GPS-based pinpoint accuracy

#### 🎨 Modern Cross-Platform UI
- Built with Flutter for Android and iOS
- Smooth, minimal, and intuitive interface
- Responsive design for all screen sizes

#### ⚙️ Scalable Architecture
- Uses modular service classes (`GeminiApiService`, `LocationService`)
- Future-ready for integration with municipal dashboards
- Easy to extend with new features and analytics APIs

---

## 🧠 Tech Stack

| Layer | Technology |
|-------|-------------|
| **Frontend** | Flutter (Dart) |
| **Backend** | Firebase / Node.js (optional) |
| **AI Model** | Google Gemini 2.5 Flash |
| **Location Services** | Geolocator package |
| **Environment Management** | flutter_dotenv |
| **State Management** | Provider / Riverpod (as needed) |

---

## ⚙️ How It Works

### 1️⃣ User Submission
The user captures or uploads an image and provides a short text description of the civic issue.

### 2️⃣ AI Verification
The app sends both image and text to the Gemini API using the `GeminiApiService`. The model evaluates:
- Is it a real civic issue?
- Which category does it belong to?
- Does the image match the description?
- What is the confidence and priority level?
- Generate a short title and reasoning

### 3️⃣ AI Processing
Gemini 2.5 Flash analyzes the submission and returns structured data about the issue.

### 4️⃣ Display & Submit
The AI-verified report is displayed in the app with its title, category, and priority, ready to be forwarded to authorities.

---

## 📥 Installation

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Google Gemini API Key

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/urbanx.git
   cd urbanx
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   
   Create a `.env` file in the project root:
   ```env
   GEMINI_API_KEY=your_api_key_here
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Getting a Gemini API Key
1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Create a new API key
4. Copy and paste it into your `.env` file

---

## 📁 Project Structure

```
lib/
│
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   ├── report_issue/
│   │   ├── report_issue_screen.dart
│   │   └── widgets/
│   └── widgets/
│       └── common_widgets.dart
│
├── services/
│   ├── gemini_api_service.dart      # Handles AI verification & classification
│   └── location_service.dart        # Handles GPS and location permissions
│
├── models/
│   └── issue_report.dart            # Data models
│
├── utils/
│   └── constants.dart               # App constants and configurations
│
└── main.dart                        # App entry point
```

---

## 📊 API Response Example

When an issue is submitted, the Gemini API returns structured JSON:

```json
{
  "is_problem": true,
  "category": "Road Damage",
  "matches": true,
  "confidence": 0.94,
  "priority": 87,
  "title": "Severe Pothole on Main Street",
  "reason": "The image and description clearly show a large pothole causing road obstruction."
}
```

### Response Fields
- **is_problem**: Boolean indicating if it's a valid civic issue
- **category**: Classification (e.g., Road Damage, Garbage, Street Light)
- **matches**: Whether image and description align
- **confidence**: AI confidence score (0-1)
- **priority**: Urgency score (1-100)
- **title**: Auto-generated issue title
- **reason**: Brief explanation of the assessment

---

## 🚀 Future Enhancements

- [ ] **Municipal Dashboard**: Web portal for officials to view and manage reported issues in real-time
- [ ] **Duplicate Detection**: AI-based system to detect similar issues already reported
- [ ] **Reward System**: Gamification to encourage active citizen participation
- [ ] **Data Analytics**: Generate city cleanliness and maintenance heatmaps
- [ ] **Push Notifications**: Notify users about issue status and resolutions
- [ ] **Multi-language Support**: Expand accessibility across diverse communities
- [ ] **Offline Mode**: Allow report drafting without internet connection
- [ ] **Issue Tracking**: Let users track their reported issues from submission to resolution

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is developed for **Hackathon 2025** and is currently under an open innovation license. Contributions, forks, and feature suggestions are welcome!

---

## 📞 Contact

**Team Phantom Minds**

For questions, suggestions, or collaboration opportunities, please reach out to the team members or open an issue on GitHub.

---


**Made with ❤️ by Team Phantom Minds**

*Building smarter cities, one report at a time*

</div>
