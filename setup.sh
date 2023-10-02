#!/bin/bash
set -e

if ! command -v python3 &> /dev/null; then
    echo "python3 could not be found"
    exit 1
fi

python3 -m venv .venv || { echo "Failed to create a virtual environment"; exit 1; }
source .venv/bin/activate || { echo "Failed to activate the virtual environment"; exit 1; }

mkdir -p models
model_path="models/vicuna-13b-v1.5-16k.Q5_K_M.gguf"

# Only download the model if it does not already exist.
if [ ! -f "$model_path" ]; then
    if command -v wget &> /dev/null; then
        wget -P models https://huggingface.co/hbacard/vicuna-13b-v1.5-16k.Q5_K_M-GGUF/resolve/main/vicuna-13b-v1.5-16k.Q5_K_M.gguf || { echo "Failed to download the model"; exit 1; }
    elif command -v curl &> /dev/null; then
        curl -L -o $model_path https://huggingface.co/hbacard/vicuna-13b-v1.5-16k.Q5_K_M-GGUF/resolve/main/vicuna-13b-v1.5-16k.Q5_K_M.gguf || { echo "Failed to download the model"; exit 1; }
    else
        echo "Neither wget nor curl is available on this system."
        exit 1
    fi
fi

echo "MODEL_PATH=$model_path" > .env || { echo "Failed to create .env file"; exit 1; }

# Install Cython before other packages
pip install Cython || { echo "Failed to install Cython"; exit 1; }
pip install langchain streamlit python-dotenv || { echo "Failed to install the necessary packages"; exit 1; }
pip install --upgrade pip || { echo "Failed to upgrade pip"; exit 1; }
pip install llama-cpp-python==0.1.83 || { echo "Failed to install llama-cpp-python"; exit 1; }
