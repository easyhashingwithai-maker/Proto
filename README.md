# Proto - AI-Powered Coding Assistant

Proto is a highly efficient, offline-first personal assistant for developers. It combines 3D holographic interfaces with powerful AI automation to help you code, debug, and manage repositories.

## Key Features
- **3D Holographic Avatar**: Interactive 3D interface using `model_viewer_plus`.
- **Hybrid AI Orchestrator**: Uses Local LLMs (via Ollama) by default, with fallback to Gemini/Groq.
- **Git Automation**: Automated bug detection, fixing, and repository maintenance.
- **Offline First**: Local chat history and settings stored using Isar.
- **Voice Interface**: Voice-activated commands and Text-to-Speech responses.

## Getting Started

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Git
- Ollama (for local AI features)

### Automated Setup
Run the following command to detect your environment and install all dependencies automatically:

```bash
chmod +x setup.sh
./setup.sh
```

### Manual Installation
1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Start Ollama and pull the model:
   ```bash
   ollama pull llama3.2:3b
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## System Architecture
Proto follows a feature-based Clean Architecture:
- `core/`: Shared services (Theme, DB, Connectivity)
- `features/ai/`: AI Clients and Orchestration
- `features/code/`: Embedded Editor and File Analysis
- `features/git/`: Git operations and automation
- `features/avatar/`: 3D UI components
- `features/voice/`: TTS and Speech Recognition

## Security
API keys and GitHub PATs are stored securely using `flutter_secure_storage`.

## License
MIT
