from langchain.chains import LLMChain
from langchain.memory import ConversationBufferMemory
from langchain.memory.chat_message_histories import StreamlitChatMessageHistory
from langchain.prompts import PromptTemplate
from langchain.llms import LlamaCpp
import streamlit as st
import os
from dotenv import load_dotenv

st.set_page_config(page_title="QBot")
st.title("QBot")

START_CHAT_MSG = "Hello! How may I help you?"

# Set up memory
msgs = StreamlitChatMessageHistory(key="langchain_messages")
memory = ConversationBufferMemory(chat_memory=msgs)
if len(msgs.messages) == 0:
    msgs.add_ai_message(START_CHAT_MSG)

load_dotenv()

model_path = os.environ.get("MODEL_PATH")

print(model_path)
n_gpu_layers = 1  # Metal set to 1 is enough. On Linux can get higher (40 for example)
n_batch = 512
llm = LlamaCpp(
    model_path=model_path,
    n_batch=n_batch,
    n_gpu_layers=n_gpu_layers,
    f16_kv=True,
    verbose=True,
    n_ctx=512,  # Important if you have long input (default value is 512)
    top_k=40,
    top_p=0.95,
    repeat_penalty=1.1,
    temperature=0.8,
    seed=42,
)


template = """
This is a conversation between a human and QBot, a friendly chatbot. QBot is helpful, kind, honest, good at writing, and never fails to answer any requests immediately and with precision.

{history}
User: {user_input}
QBot:
"""

# Set up the LLMChain, passing in memory


prompt = PromptTemplate(input_variables=["history", "user_input"], template=template)
llm_chain = LLMChain(llm=llm, prompt=prompt, memory=memory)

# Add a button to clear the chat history
if st.sidebar.button("Clear History and Restart Chat"):
    msgs.messages.clear()  # Clear the existing messages
    msgs.add_ai_message(START_CHAT_MSG)  # Add an initial message from the AI
# Render current messages from StreamlitChatMessageHistory
for msg in msgs.messages:
    st.chat_message(msg.type).write(msg.content)

# If user inputs a new prompt, generate and draw a new response
if prompt := st.chat_input():
    st.chat_message("user").write(prompt)
    # Note: new messages are saved to history automatically by Langchain during run
    response = llm_chain.run(prompt)
    st.chat_message("qbot").write(response)
