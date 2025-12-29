#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting Gemini CLI installation on Ubuntu..."

# 1. Update system packages
echo "📦 Updating package lists..."
sudo apt update && sudo apt upgrade -y

# 2. Install Python3 and pip if not present
echo "🐍 Installing Python and dependencies..."
sudo apt install -y python3 python3-pip python3-venv

# 3. Create a directory for the Gemini CLI
mkdir -p ~/gemini-cli
cd ~/gemini-cli

# 4. Set up a virtual environment
echo "🛠️ Setting up Gemini's Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

# 5. Install the Google Generative AI SDK
echo "📥 Installing Google Generative AI library..."
pip install -q -U google-generativeai

# 6. Create a wrapper script to run it easily
echo "✍️ Creating executable wrapper..."
cat << 'EOF' > gemini-chat.py
import os
import google.generativeai as genai
import sys

# Get API Key from environment variable
api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    print("❌ Error: GEMINI_API_KEY environment variable not set.")
    sys.exit(1)

genai.configure(api_key=api_key)
model = genai.GenerativeModel('gemini-pro')

if len(sys.argv) > 1:
    prompt = " ".join(sys.argv[1:])
    response = model.generate_content(prompt)
    print(f"\n🤖 Gemini:\n{response.text}")
else:
    print("Usage: gemini 'Your question here'")
EOF

# 7. Add alias to .bashrc for global access
if ! grep -q "alias gemini=" ~/.bashrc; then
    echo "alias gemini='source ~/gemini-cli/venv/bin/activate && python3 ~/gemini-cli/gemini-chat.py'" >> ~/.bashrc
    echo "✅ Alias added to .bashrc"
fi

echo "-------------------------------------------------------"
echo "🎉 Installation Complete!"
echo "1. Run 'source ~/.bashrc' to refresh your terminal."
echo "2. Set your API key: export GEMINI_API_KEY='your_key_here'"
echo "3. Use it by typing: gemini 'Hello, how are you?'"
echo "-------------------------------------------------------"
