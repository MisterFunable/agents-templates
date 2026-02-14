"""
Configuration management using environment variables.
Follows 12-factor app principles.
"""
import os


class Config:
    """Application configuration from environment variables."""

    # Server configuration
    PORT = int(os.getenv("PORT", "8000"))
    LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")

    # Optional: Database (example)
    DATABASE_URL = os.getenv("DATABASE_URL")

    # Optional: Redis (example)
    REDIS_URL = os.getenv("REDIS_URL")

    # Service name for logging
    SERVICE_NAME = os.getenv("SERVICE_NAME", "eks-webapp")

    @classmethod
    def validate(cls):
        """
        Validate required configuration.
        Fail fast on startup if config is invalid.
        """
        # Add required config validation here
        # Example:
        # if not cls.DATABASE_URL:
        #     raise ValueError("DATABASE_URL environment variable is required")
        pass

    @classmethod
    def to_dict(cls):
        """Get config as dictionary (for logging, without secrets)."""
        return {
            "port": cls.PORT,
            "log_level": cls.LOG_LEVEL,
            "service_name": cls.SERVICE_NAME,
            # Don't log secrets
            "database_configured": bool(cls.DATABASE_URL),
            "redis_configured": bool(cls.REDIS_URL),
        }


# Validate configuration on import
Config.validate()
