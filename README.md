# QBot 🤖✨

This project is a simple chatbot developed using Streamlit, LangChain, and `llama-cpp-python`. It leverages a quantized version of [Vicuna](https://lmsys.org/blog/2023-03-30-vicuna) but also supports other `GGUF` models like the ones upload by [TheBloke](https://huggingface.co/TheBloke) on Hugging Face, provided that your hardware meets the required specifications. The app is simple and will certainly need some improvements. 

- The "Q" in QBot stands for "Quantized".


## Features
- **Local Offline Usage**: Designed to operate locally and offline.
- **Compatibility**: Tested on Apple Silicon Macs (Macbook Pro M2) and expected to run on Linux-based systems.
- **Customizable**: Users have the option to use other models.

## 📑 Table of Contents
- [Requirements](#requirements)
- [Installation](#installation)
  - [Common Steps](#common-steps)
  - [For Apple Silicon Machines](#for-apple-silicon-machines)
  - [For Linux Based Systems](#for-linux-based-systems)
- [Credits](#credits)


## 🛠 Requirements

- Python 3.10 or above
- pip (Python’s package installer)

## 💾 Installation

### Common Steps

1. Clone the repository to your local machine:
   ```sh
   git clone https://github.com/hbacard/streamlit-qbot.git
   cd streamlit-qbot
   ```


2. Create a virtual environment and activate it:

   ```sh
   python3 -m venv .venv
   source .venv/bin/activate  # Linux/macOS
   ```

3. If not already present, create a `models` directory in the root of the repository:

   ```sh
   mkdir -p models
   ```

4. Download the model `vicuna-13b-v1.5-16k.Q5_K_M.gguf` into the `models` directory using `wget` (Unix Based Systems):

   ```sh
   wget -P models https://huggingface.co/hbacard/vicuna-13b-v1.5-16k.Q5_K_M-GGUF/resolve/main/vicuna-13b-v1.5-16k.Q5_K_M.gguf
   ```

5. Create a `.env` file in the project root [using for example `touch .env` in the terminal] and specify the model path:
   ```env
   MODEL_PATH=models/vicuna-13b-v1.5-16k.Q5_K_M.gguf
   ```
   Or your other preferred GGUF model:
   ```env
   MODEL_PATH=models/your-downloaded-model-name.gguf
   ```

### For Apple Silicon Machines

1. Install dependencies:

   ```sh
   pip install langchain streamlit python-dotenv
   ```

2. Install `llama-cpp-python` for mac using the following command:

   ```sh
   CMAKE_ARGS="-DLLAMA_METAL=on" FORCE_CMAKE=1 pip install --force-reinstall llama-cpp-python==0.1.83 --no-cache-dir
   ```

   💡 This will ensure that any previous CPU-only installation will be removed and a new version using Apple Silicon GPU (Metal) will be installed.

   🛈 **Note:** If you don't need GPU support, you can simply install `llama-cpp-python` using `pip install llama-cpp-python==0.1.83` instead.
3. Launch the app:
   ```sh
   streamlit run app.py
   ```

### For Linux Based Systems

1. Install dependencies:

   ```sh
   pip install langchain streamlit python-dotenv
   ```

2. Install `llama-cpp-python` for Linux:

   ```sh
   <CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install --force-reinstall llama-cpp-python==0.1.83 --no-cache-dir
   ```
   🛈 **Note:** If you don't need GPU support, you can simply install `llama-cpp-python` using `pip install llama-cpp-python==0.1.83` instead.
3. Launch the app:
   ```sh
   streamlit run app.py
   ```
## Model Weights
### Vicuna Weights
[Vicuna](https://lmsys.org/blog/2023-03-30-vicuna/) is based on LLaMA and should be used under LLaMA's [model license](https://github.com/facebookresearch/llama/blob/main/LICENSE).

## Credits

- [LangChain Streamlit Agent](https://github.com/langchain-ai/streamlit-agent/blob/main/streamlit_agent/basic_memory.py): The foundational streamlit code for this project is derived from that LangChain Streamlit Agent. The adaptation primarily involves not using an OpenAI API key.

