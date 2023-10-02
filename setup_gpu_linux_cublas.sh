#!/bin/bash
set -e

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "python3 could not be found"
    exit 1
fi

# Check if python3 version is 3.10 or higher
python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
if [[ "$(printf "3.10.0\n%s" "$python_version" | sort -V | head -n1)" != "3.10.0" ]]; then
    echo "Python 3.10 or higher is required. You have Python $python_version."
    exit 1
fi

python3 -m venv .venv || { echo "Failed to create a virtual environment"; exit 1; }
source .venv/bin/activate || { echo "Failed to activate the virtual environment"; exit 1; }

# Upgrade pip, setuptools, and wheel in your virtual environment before installing packages
pip install --upgrade pip setuptools wheel || { echo "Failed to upgrade pip, setuptools, wheel"; exit 1; }

mkdir -p models
model_path="models/vicuna-13b-v1.5-16k.Q5_K_M.gguf"

# Only download the model if it does not already exist
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

pip install langchain streamlit python-dotenv || { echo "Failed to install the necessary packages"; exit 1; }
CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install --force-reinstall llama-cpp-python==0.1.83 --no-cache-dir || { echo "Failed to install llama-cpp-python"; exit 1; }
