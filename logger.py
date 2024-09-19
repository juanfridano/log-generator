import logging
import random
import time
import os

# Configure logging
logging.basicConfig(level=logging.DEBUG)

severities = [logging.DEBUG, logging.INFO, logging.WARNING, logging.ERROR, logging.CRITICAL]
messages = ["Random message one", "Random message two", "Random message three", "Random message four", "Random message five", "Random message six"]

def generate_random_log():
    severity = random.choice(severities)
    message = random.choice(messages)
    logging.log(severity, message)

if __name__ == "__main__":
    log_frequency = int(os.getenv('LOG_FREQUENCY_SECONDS', 2))
    while True:
        generate_random_log()
        time.sleep(log_frequency)
