from fastapi import FastAPI
from pydantic import BaseModel
from src.pipeline import run
from dotenv import load_dotenv
from fastapi.middleware.cors import CORSMiddleware
from fastapi import Response, Request
import logging
import time


logging.basicConfig(
    level=logging.DEBUG, format="%(asctime)s - %(levelname)s - %(message)s"
)

load_dotenv()


app = FastAPI()

# Add CORS middleware before defining routes
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your frontend domain
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)

# Add middleware to log requests
@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    logging.info(f"Request: {request.method} {request.url}")
    response = await call_next(request)
    process_time = time.time() - start_time
    logging.info(f"Response: {response.status_code} - {process_time:.4f}s")
    return response


@app.get("/health")
def health_check():
    return {"status": "healthy"}


@app.options("/pipeline")
async def pipeline_options():
    return {"message": "OK"}


class PromptRequest(BaseModel):
    prompt: str


@app.post("/pipeline")
async def pipeline(request: PromptRequest):
    logging.info(f"Received request with prompt: {request.prompt}")
    result = await run(request.prompt)
    return {"result": result}
    return {"result": result}
