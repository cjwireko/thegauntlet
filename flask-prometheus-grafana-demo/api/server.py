import logging

from flask import Flask
from flask import jsonify
from prometheus_flask_exporter import PrometheusMetrics

logging.basicConfig(level=logging.INFO)
logging.info("Setting LOGLEVEL to INFO")

api = Flask(__name__)
metrics = PrometheusMetrics(api)

metrics.info("app_info", "App Info, this can be anything you want", version="1.0.0")


@api.route('/ping')
def ping():
    return jsonify(say_pong())


def say_pong():
    return {"message": "pong"}