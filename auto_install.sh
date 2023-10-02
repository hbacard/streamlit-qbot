#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Check for python3 and pip
if ! command -v python3 &> /dev/null; then
    echo "python3 could not be found"
    exit 1
fi

if ! command -v pip &> /dev/null; then
    echo "pip could not be found"
    exit 1
fi

# Create a virtual environment
python3 -m venv .venv || { echo "Failed to create a virtual environment"; exit 1; }
source .venv/bin/activate || { echo "Failed to activate the virtual environment"; exit 1; }

# Create models directory if it doesn't exist
mkdir -p models

# Download the model
if command -v wget &> /dev/null; then
    wget -P models https://huggingface.co/hbacard/vicuna-13b-v1.5-16k.Q5_K_M-GGUF/resolve/main/vicuna-13b-v1.5-16k.Q5_K_M.gguf || { echo "Failed to download the model"; exit 1; }
elif command -v curl &> /dev/null; then
    curl -L -o models/vicuna-13b-v1.5-16k.Q5_K_M.gguf https://huggingface.co/hbacard/vicuna-13b-v1.5-16k.Q5_K_M-GGUF/resolve/main/vicuna-13b-v1.5-16k.Q5_K_M.gguf || { echo "Failed to download the model"; exit 1; }
else
    echo "Neither wget nor curl is available on this system."
    exit 1
fi

# Create .env file
echo "MODEL_PATH=models/vicuna-13b-v1.5-16k.Q5_K_M.gguf" > .env || { echo "Failed to create .env file"; exit 1; }

# Install the necessary packages
pip install langchain streamlit python-dotenv || { echo "Failed to install the necessary packages"; exit 1; }
pip install --upgrade pip || { echo "Failed to upgrade pip"; exit 1; }
pip install llama-cpp-python==0.1.83 || { echo "Failed to install llama-cpp-python"; exit 1; }

# Run the application
streamlit run app.py || { echo "Failed to run the application"; exit 1; }
