"""
Structured logging configuration.
Logs to STDOUT in JSON format for Kubernetes.
"""
import logging
import json
from datetime import datetime

from .config import Config


class JSONFormatter(logging.Formatter):
    """Format logs as JSON for structured logging."""

    def format(self, record):
        log_data = {
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "level": record.levelname,
            "message": record.getMessage(),
            "service": Config.SERVICE_NAME,
            "logger": record.name,
        }

        # Add extra fields if present
        if hasattr(record, "extra"):
            log_data.update(record.extra)

        # Add exception if present
        if record.exc_info:
            log_data["exception"] = self.formatException(record.exc_info)

        return json.dumps(log_data)


def setup_logging():
    """
    Configure structured logging to STDOUT.
    Kubernetes will collect logs from STDOUT/STDERR.
    """
    # Create handler for STDOUT
    handler = logging.StreamHandler()
    handler.setFormatter(JSONFormatter())

    # Configure root logger
    logger = logging.getLogger()
    logger.addHandler(handler)
    logger.setLevel(getattr(logging, Config.LOG_LEVEL.upper()))

    # Reduce noise from uvicorn
    logging.getLogger("uvicorn.access").setLevel(logging.WARNING)
    logging.getLogger("uvicorn.error").setLevel(logging.INFO)

    return logger
