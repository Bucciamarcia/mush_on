from google.cloud import logging as cloud_logging
from google.cloud.logging.handlers import CloudLoggingHandler
import logging
import os


class BasicLogger:
    def __init__(self, logger_name="my-application"):
        self.logger = logging.getLogger(logger_name)
        self.logger.setLevel(logging.DEBUG)

        # Only use Cloud Logging in production
        if os.getenv("ENVIRONMENT") == "production":
            client = cloud_logging.Client()
            handler = CloudLoggingHandler(client, name=logger_name)
            self.logger.addHandler(handler)
        else:
            # Use simple console logging locally
            handler = logging.StreamHandler()
            formatter = logging.Formatter(
                "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
            )
            handler.setFormatter(formatter)
            self.logger.addHandler(handler)

    def debug(self, message):
        self.logger.debug(message)

    def info(self, message):
        self.logger.info(message)

    def warning(self, message):
        self.logger.warning(message)

    def error(self, message):
        self.logger.error(message)
