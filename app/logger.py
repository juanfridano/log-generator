import logging
import random
import time
import os
from flask import Flask
import google.cloud.logging

client = google.cloud.logging.Client()
client.setup_logging()
logging.basicConfig(level=logging.DEBUG)

severities = [logging.DEBUG, logging.INFO, logging.WARNING, logging.ERROR, logging.CRITICAL]
messages = ["Random debug message", "Random info message", "Random warning", "Random error", "Random critical issue"]

app = Flask(__name__)

def generate_random_log():
    index = random.randint(0, 4)
    severity = severities[index]
    message = messages[index]
    logging.log(severity, message)

@app.route('/')
def home():
    return "Log generator is running."

if __name__ == "__main__":
    log_frequency = int(os.getenv('LOG_FREQUENCY_SECONDS', 5))
    
    from threading import Thread
    
    def log_generator():
        while True:
            generate_random_log()
            time.sleep(log_frequency)

    log_thread = Thread(target=log_generator)
    log_thread.start()
    
    port = int(os.getenv('PORT', 8080))
    app.run(host='0.0.0.0', port=port)
