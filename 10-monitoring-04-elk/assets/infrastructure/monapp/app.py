import atexit
import logging
import sys

from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime
from json import dumps
from random import randint
from threading import Thread
from flask import Flask
from gibberish import Gibberish

log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

logger = logging.getLogger('monapp')
logger.setLevel(logging.INFO)

handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.INFO)
formatter = logging.Formatter(
    '%(asctime)s - %(levelname)s - %(message)s',  datefmt='%a, %d %b %Y %H:%M:%S')
handler.setFormatter(formatter)
logger.addHandler(handler)


app = Flask(__name__)

@app.route('/')
def main():
    """Main page"""
    return 'Nothing to show there'


def log_message_generator():
    """Log messages generator"""
    chance = randint(0, 19)
    message = ' '.join(Gibberish().generate_words(
        wordcount=3, vowel_consonant_repeats=1))
    if chance in (18, 19):
        logger.error(message)
    elif chance in (16, 17):
        logger.warning(message)
    else:
        logger.info(message)


scheduler = BackgroundScheduler()
scheduler.add_job(func=log_message_generator, trigger="interval", seconds=5)
scheduler.start()

# Shut down the scheduler when exiting the app
atexit.register(lambda: scheduler.shutdown())

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False)