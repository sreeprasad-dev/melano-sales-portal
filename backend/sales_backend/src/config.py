import os
from datetime import timedelta

class Config:
    # Supabase Configuration
    SUPABASE_URL = os.environ.get("SUPABASE_URL", "https://czvrldsjhbzsxndfnvtb.supabase.co")
    SUPABASE_KEY = os.environ.get("SUPABASE_KEY", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN6dnJsZHNqaGJ6c3huZGZudnRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4OTE2MTcsImV4cCI6MjA3MDQ2NzYxN30.EvJRjV7DQk0xmpVX5FRBcFet7f8_8lii0VdTeooLBYs")

    # JWT Configuration
    JWT_SECRET_KEY = os.environ.get("JWT_SECRET_KEY", "a_very_strong_jwt_secret_key_for_melano_sales_portal") # Change this in production
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=1)

    # Flask Configuration
    SECRET_KEY = os.environ.get("SECRET_KEY", "a_very_strong_flask_secret_key_for_melano_sales_portal") # Change this in production
    FLASK_ENV = os.environ.get("FLASK_ENV", "development")

    # CORS Configuration
    CORS_ORIGINS = os.environ.get("CORS_ORIGINS", "*") # Allow all origins for development

    # Indian timezone
    TIMEZONE = 'Asia/Kolkata'
    
    # Application settings
    ITEMS_PER_PAGE = 20
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024  # 16MB max file upload



