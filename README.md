# Prompt Generator & Library 🚀

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Hive](https://img.shields.io/badge/Storage-Hive%20DB-FFA000?style=for-the-badge&logo=databricks&logoColor=white)](https://pub.dev/packages/hive)
[![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Android%20%7C%20iOS-4CAF50?style=for-the-badge)](https://flutter.dev/multi-platform)

An intelligent, offline-first **AI Prompt Library & Interactive Generator** built with Flutter. Organize, search, customize, and generate ready-to-use prompts for LLMs (ChatGPT, Claude, Gemini, DeepSeek) tailored for software engineering and development workflows.

---

## 🌟 Key Features

* **⚡ Dynamic Parameter Generator**:
  * Automatically detects template placeholders such as `{ProjectName}`, `{ClassName}`, and `{Database, e.g. Postgres}`.
  * Real-time variable input fields with clickable suggestion chips.
  * Live preview updating instantaneously as you type.
  * Append optional custom requirements or constraints before copying.
  * One-tap copy to clipboard with instant feedback.
* **📚 Curated Engineering Prompts**:
  * Pre-loaded starter prompts across popular tech stacks: **.NET**, **SQL**, **PostgreSQL**, **Dart**, **Flutter**, **React**, **CSS**, **Bootstrap**, and **General**.
* **🏗️ Lifecycle Stage Categorization**:
  * Quickly filter prompts by development stages: **From Scratch**, **Helper Functions**, **UI / Cards**, **Deployment**, and **Other**.
* **🔍 Search & Filter**:
  * Instant search across prompt titles, content, and tags.
  * Dual horizontal chip filters for tech stacks and lifecycle stages.
  * Star favorite prompts for instant access.
* **💾 Offline-First Local Storage**:
  * Powered by high-performance **Hive DB** for zero-latency local caching and offline use.
* **✏️ Template Authoring**:
  * Create, edit, and delete custom prompts.
  * Live parameter detection highlights `{Variable}` tokens as you compose new prompts.

---

## 🛠️ Tech Stack

* **Framework:** [Flutter](https://flutter.dev) (Material 3 Design)
* **Language:** [Dart](https://dart.dev) (Null-safe)
* **Local Persistence:** [Hive](https://pub.dev/packages/hive) & [hive_flutter](https://pub.dev/packages/hive_flutter)
* **Networking:** [http](https://pub.dev/packages/http) with graceful error handling and fallbacks

---

## 📝 How Dynamic Prompt Templates Work

You can write prompt templates containing dynamic variables that become customizable fields in the generator.

### Syntax Examples

| Syntax | Example | Generator Behavior |
| :--- | :--- | :--- |
| `{Name}` | `{ProjectName}` | Creates a clean text input labeled **ProjectName** |
| `{Name, e.g. Hint}` | `{MigrationTool, e.g. Flyway or EF Core}` | Creates an input with hint and clickable option chips: `Flyway`, `EF Core` |
| `{Option1, Option2, or Option3}` | `{CSS, Tailwind, or Bootstrap}` | Provides quick clickable pills for `CSS`, `Tailwind`, and `Bootstrap` |

When opening the prompt in the app, fill in the values or tap a suggestion chip, and the final prompt is generated live!

---

## 🚀 Getting Started

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `3.12.0` or higher)
* [Dart SDK](https://dart.dev/get-dart)
* A device, emulator, or browser (Chrome) to run the app

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/promptgenerator.git
   cd promptgenerator
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run on Chrome (Web):**
   ```bash
   flutter run -d chrome
   ```

4. **Run on Desktop (Windows):**
   ```bash
   flutter run -d windows
   ```

5. **Run on Mobile (Android / iOS):**
   ```bash
   flutter run
   ```

---

## 🧪 Running Tests & Quality Checks

Run the automated test suite:
```bash
flutter test
```

Verify static analysis:
```bash
flutter analyze
```

---

## 🗺️ Roadmap

- [x] Phase 1: Dynamic Parameter Filler & Interactive Live Generator
- [ ] Phase 2: Modular Prompt Assembler (Persona + Constraints + Output Schema)
- [ ] Phase 3: AI Meta-Prompting (Integrate Google Gemini API to refine and generate prompts)
- [ ] Phase 4: Export & Share (Export to Markdown, JSON, and direct web links)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
