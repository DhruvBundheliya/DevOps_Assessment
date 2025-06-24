import os
import requests
import logging
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

SLACK_TOKEN = os.environ.get("SLACK_TOKEN")
SLACK_CHANNEL = os.environ.get("SLACK_CHANNEL", "#alerts")
slack_client = WebClient(token=SLACK_TOKEN)

URLS = os.environ.get("URLS", "").split(",")

def send_slack_alert(url, status_code):
    try:
        message = f":warning: *{url}* is returning status code *{status_code}*"
        slack_client.chat_postMessage(channel=SLACK_CHANNEL, text=message)
    except SlackApiError as e:
        logger.error(f"Failed to send Slack alert: {e.response['error']}")

def lambda_handler(event, context):
    for url in URLS:
        try:
            response = requests.get(url, timeout=5)
            logger.info(f"{url} - Status Code: {response.status_code}")
            if response.status_code >= 400:
                send_slack_alert(url, response.status_code)
        except requests.exceptions.RequestException as e:
            logger.error(f"Error checking {url}: {str(e)}")
            send_slack_alert(url, "UNREACHABLE")
