#!/bin/bash

# Proto Setup Script
# Detects OS, installs Flutter, Ollama, and Git, then prepares the project.

set -e

echo "Starting Proto setup..."

OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Windows;;
    MINGW*)     MACHINE=Windows;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "Detected OS: $MACHINE"

# 1. Check for Git
if ! command -v git &> /dev/null; then
    echo "Git not found. Please install Git and run this script again."
    exit 1
fi

# 2. Check for Flutter
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found. Installing Flutter..."
    if [ "$MACHINE" == "Mac" ]; then
        brew install --cask flutter
    elif [ "$MACHINE" == "Linux" ]; then
        sudo snap install flutter --classic
    else
        echo "Please install Flutter manually from https://docs.flutter.dev/get-started/install"
        exit 1
    fi
else
    echo "Flutter is already installed."
fi

# 3. Check for Ollama
if ! command -v ollama &> /dev/null; then
    echo "Ollama not found. Installing Ollama..."
    if [ "$MACHINE" == "Mac" ] || [ "$MACHINE" == "Linux" ]; then
        curl -fsSL https://ollama.com/install.sh | sh
    else
        echo "Please install Ollama manually from https://ollama.com"
        exit 1
    fi
else
    echo "Ollama is already installed."
fi

# 4. Pull AI Model
echo "Pulling local LLM (llama3.2:3b)..."
ollama serve > /dev/null 2>&1 &
sleep 5
ollama pull llama3.2:3b

# 5. Fetch project dependencies
echo "Fetching Flutter dependencies..."
flutter pub get

# 6. Create local assets
mkdir -p assets/models
if [ ! -f "assets/models/robot_head.glb" ]; then
    echo "Downloading sample 3D model..."
    # Placeholder for a real download or generating a dummy file
    curl -L -o assets/models/robot_head.glb https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb
fi

echo "------------------------------------------------"
echo "Proto setup complete!"
echo "Next steps:"
echo "1. Run 'flutter run' to start the application."
echo "2. Ensure Ollama is running ('ollama serve') for local AI features."
echo "------------------------------------------------"
