#!/bin/bash
set -e

source .venv/bin/activate || { echo "Failed to activate the virtual environment"; exit 1; }
streamlit run app.py || { echo "Failed to run the application"; exit 1; }
