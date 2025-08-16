from supabase import create_client, Client
from src.config import Config
import os

# Initialize Supabase client
def get_supabase_client() -> Client:
    """Get Supabase client instance"""
    url = Config.SUPABASE_URL
    key = Config.SUPABASE_KEY
    
    if not url or not key:
        raise ValueError("Supabase URL and Key must be provided in environment variables")
    
    return create_client(url, key)

# Global client instance
supabase: Client = None

def init_supabase():
    """Initialize Supabase client"""
    global supabase
    try:
        supabase = get_supabase_client()
        print("Supabase client initialized successfully")
        return supabase
    except Exception as e:
        print(f"Failed to initialize Supabase client: {e}")
        return None

# Define table names with prefix
TABLE_SALES_USERS = "ms_sales_users"
TABLE_INDIAN_STATES = "ms_indian_states"
TABLE_SALONS = "ms_salons"
TABLE_PRODUCT_CATEGORIES = "ms_product_categories"
TABLE_PRODUCTS = "ms_products"
TABLE_VISIT_PLANS = "ms_visit_plans"
TABLE_ORDERS = "ms_orders"
TABLE_ORDER_ITEMS = "ms_order_items"
TABLE_APPROVAL_REQUESTS = "ms_approval_requests"
TABLE_FOLLOW_UP_TASKS = "ms_follow_up_tasks"
TABLE_ACTIVITY_LOG = "ms_activity_log"


