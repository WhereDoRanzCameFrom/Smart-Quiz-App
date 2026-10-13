# 🎓 Smart Quiz - Interactive Elementary Learning App

Smart Quiz is a engaging, gamified educational application built using **Flutter** designed for elementary school students. The app provides interactive lessons and quizzes covering fundamental subjects—including Mathematics, Biology, and English—complete with sound effects, progress tracking, and custom animations to make learning fun and rewarding.

---

## 🚀 Key Features Overview

# 📚 Multi-Subject Lessons & Quizzes
# - Subject Modules: Comprehensive practice sets for key elementary subjects including Mathematics, English, and Biology.
# - Interactive Quiz Engine: Immediate feedback upon answer selection with custom visual progress tracking (`percent_indicator`).
# - Lessons Screen: Dedicated study cards and learning materials tailored for elementary-level understanding.

# 🔊 Audio & Visual Feedback
# - Gamified Sound Effects: Integrated audio feedback (`audioplayers`) for correct answers, wrong selections, quiz completion, and background music.
# - Engaging Animations: Fluid UI transitions and responsive feedback powered by `flutter_animate` and custom typography (`google_fonts`).

# 👤 Student Profile & Progress Persistence
# - Profile Management: Track individual student metrics and learning milestones.
# - Local Storage: Uses `shared_preferences` to locally persist student quiz scores, settings, and progress without requiring an online database.

---

## 🛠️ Tech Stack & Dependencies

Built with the following technology stack and Flutter packages[cite: 3]:

- **Framework:** [Flutter](https://flutter.dev/) (Dart SDK `^3.0.0`)[cite: 3]
- **State Management:** [Provider](https://pub.dev/packages/provider)[cite: 3]
- **Local Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)[cite: 3]
- **Audio & Media:** [AudioPlayers](https://pub.dev/packages/audioplayers) (`^5.2.1`)[cite: 3]
- **UI & Animations:**
  - Custom Typography: `google_fonts`[cite: 3]
  - Visual Indicators: `percent_indicator` & `smooth_page_indicator`[cite: 3]
  - UI Effects: `flutter_animate`[cite: 3]
  - Sound Effect by <a href="https://pixabay.com/id/users/zec53-16984292/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=480254">zec53</a> from <a href="https://pixabay.com/sound-effects//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=480254">Pixabay</a>

---

## ⚙️ Getting Started & Local Setup

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0.0 or higher)[cite: 3]
- An active Android Emulator, iOS Simulator, or connected physical device

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-username/smart-quiz-flutter.git](https://github.com/your-username/smart-quiz-flutter.git)
   cd smart-quiz-flutter
