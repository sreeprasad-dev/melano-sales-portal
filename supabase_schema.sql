-- Sales Management System Database Schema for Supabase
-- Designed for Indian market with focus on hair color products

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE user_role AS ENUM (
    'sales_rep',
    'sales_head',
    'admin'
);
CREATE TYPE salon_status AS ENUM (
    'prospect',
    'active',
    'inactive',
    'dormant'
);
CREATE TYPE visit_status AS ENUM (
    'planned',
    'completed',
    'missed',
    'cancelled'
);
CREATE TYPE order_status AS ENUM (
    'pending',
    'confirmed',
    'shipped',
    'delivered',
    'cancelled'
);
CREATE TYPE approval_status AS ENUM (
    'pending',
    'approved',
    'rejected'
);
CREATE TYPE approval_type AS ENUM (
    'extra_discount',
    'credit_increase',
    'special_pricing'
);

-- Sales Users table
CREATE TABLE ms_sales_users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    role user_role NOT NULL DEFAULT 'sales_rep',
    territory VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indian States for dropdown
CREATE TABLE ms_indian_states (
    id SERIAL PRIMARY KEY,
    state_name VARCHAR(50) NOT NULL,
    state_code VARCHAR(3) NOT NULL
);

-- Insert Indian states
INSERT INTO ms_indian_states (state_name, state_code) VALUES
(
    'Andhra Pradesh',
    'AP'
),
(
    'Arunachal Pradesh',
    'AR'
),
(
    'Assam',
    'AS'
),
(
    'Bihar',
    'BR'
),
(
    'Chhattisgarh',
    'CG'
),
(
    'Goa',
    'GA'
),
(
    'Gujarat',
    'GJ'
),
(
    'Haryana',
    'HR'
),
(
    'Himachal Pradesh',
    'HP'
),
(
    'Jharkhand',
    'JH'
),
(
    'Karnataka',
    'KA'
),
(
    'Kerala',
    'KL'
),
(
    'Madhya Pradesh',
    'MP'
),
(
    'Maharashtra',
    'MH'
),
(
    'Manipur',
    'MN'
),
(
    'Meghalaya',
    'ML'
),
(
    'Mizoram',
    'MZ'
),
(
    'Nagaland',
    'NL'
),
(
    'Odisha',
    'OR'
),
(
    'Punjab',
    'PB'
),
(
    'Rajasthan',
    'RJ'
),
(
    'Sikkim',
    'SK'
),
(
    'Tamil Nadu',
    'TN'
),
(
    'Telangana',
    'TG'
),
(
    'Tripura',
    'TR'
),
(
    'Uttar Pradesh',
    'UP'
),
(
    'Uttarakhand',
    'UK'
),
(
    'West Bengal',
    'WB'
),
(
    'Delhi',
    'DL'
),
(
    'Jammu and Kashmir',
    'JK'
),
(
    'Ladakh',
    'LA'
),
(
    'Lakshadweep',
    'LD'
),
(
    'Puducherry',
    'PY'
),
(
    'Andaman and Nicobar Islands',
    'AN'
),
(
    'Chandigarh',
    'CH'
),
(
    'Dadra and Nagar Haveli and Daman and Diu',
    'DN'
);

-- Salons table
CREATE TABLE ms_salons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    salon_name VARCHAR(200) NOT NULL,
    owner_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state_id INTEGER REFERENCES ms_indian_states(id),
    pincode VARCHAR(10) NOT NULL,
    status salon_status DEFAULT 'prospect',
    credit_limit DECIMAL(10,2) DEFAULT 0.00,
    current_balance DECIMAL(10,2) DEFAULT 0.00,
    assigned_sales_rep UUID REFERENCES ms_sales_users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Product categories for hair color products
CREATE TABLE ms_product_categories (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

INSERT INTO ms_product_categories (category_name, description) VALUES
(
    'Hair Color',
    'Professional hair coloring products'
),
(
    'Hair Color Shampoo',
    'Color-safe and color-enhancing shampoos'
),
(
    'Hair Cover Products',
    'Gray hair coverage solutions'
),
(
    'Hair Accessories',
    'Tools and accessories for hair coloring'
);

-- Products table (focused on hair color products)
CREATE TABLE ms_products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_name VARCHAR(200) NOT NULL,
    product_code VARCHAR(50) UNIQUE NOT NULL,
    category_id INTEGER REFERENCES ms_product_categories(id),
    description TEXT,
    price_inr DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sample hair color products
INSERT INTO ms_products (product_name, product_code, category_id, description, price_inr, stock_quantity) VALUES
(
    'Melano Professional Hair Color - Black',
    'MHC-001',
    1,
    'Premium black hair color for professional use',
    299.00,
    100
),
(
    'Melano Professional Hair Color - Brown',
    'MHC-002',
    1,
    'Rich brown hair color for salon professionals',
    299.00,
    100
),
(
    'Melano Professional Hair Color - Burgundy',
    'MHC-003',
    1,
    'Elegant burgundy shade for modern looks',
    349.00,
    75
),
(
    'Melano Color Safe Shampoo',
    'MCS-001',
    2,
    'Color-protecting shampoo for colored hair',
    199.00,
    150
),
(
    'Melano Gray Cover Plus',
    'MGC-001',
    3,
    'Instant gray hair coverage solution',
    399.00,
    80
),
(
    'Melano Color Enhancing Shampoo',
    'MCS-002',
    2,
    'Enhances and maintains hair color vibrancy',
    229.00,
    120
),
(
    'Melano Professional Applicator Brush',
    'MPA-001',
    4,
    'Professional hair color application brush',
    149.00,
    200
);

-- Visit Plans table
CREATE TABLE ms_visit_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    salon_id UUID NOT NULL REFERENCES ms_salons(id),
    sales_rep_id UUID NOT NULL REFERENCES ms_sales_users(id),
    visit_date DATE NOT NULL,
    visit_time TIME,
    purpose VARCHAR(200),
    status visit_status DEFAULT 'planned',
    notes TEXT,
    duration_minutes INTEGER,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Orders table
CREATE TABLE ms_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    salon_id UUID NOT NULL REFERENCES ms_salons(id),
    sales_rep_id UUID NOT NULL REFERENCES ms_sales_users(id),
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount_inr DECIMAL(12,2) NOT NULL,
    discount_amount_inr DECIMAL(10,2) DEFAULT 0.00,
    final_amount_inr DECIMAL(12,2) NOT NULL,
    status order_status DEFAULT 'pending',
    delivery_date DATE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Order Items table
CREATE TABLE ms_order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES ms_orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES ms_products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price_inr DECIMAL(10,2) NOT NULL,
    discount_percent DECIMAL(5,2) DEFAULT 0.00,
    line_total_inr DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Approval Requests table
CREATE TABLE ms_approval_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_type approval_type NOT NULL,
    requested_by UUID NOT NULL REFERENCES ms_sales_users(id),
    salon_id UUID REFERENCES ms_salons(id),
    order_id UUID REFERENCES ms_orders(id),
    request_details JSONB,
    current_value DECIMAL(10,2),
    requested_value DECIMAL(10,2),
    justification TEXT,
    status approval_status DEFAULT 'pending',
    approved_by UUID REFERENCES ms_sales_users(id),
    approved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Follow-up Tasks table
CREATE TABLE ms_follow_up_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    salon_id UUID NOT NULL REFERENCES ms_salons(id),
    assigned_to UUID NOT NULL REFERENCES ms_sales_users(id),
    task_title VARCHAR(200) NOT NULL,
    task_description TEXT,
    due_date DATE,
    priority VARCHAR(20) DEFAULT 'medium',
    is_completed BOOLEAN DEFAULT false,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Activity Log table
CREATE TABLE ms_activity_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES ms_sales_users(id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id UUID,
    metadata JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_ms_salons_assigned_sales_rep ON ms_salons(assigned_sales_rep);
CREATE INDEX idx_ms_salons_status ON ms_salons(status);
CREATE INDEX idx_ms_visit_plans_salon_date ON ms_visit_plans(salon_id, visit_date);
CREATE INDEX idx_ms_visit_plans_sales_rep ON ms_visit_plans(sales_rep_id);
CREATE INDEX idx_ms_orders_salon_id ON ms_orders(salon_id);
CREATE INDEX idx_ms_orders_sales_rep_id ON ms_orders(sales_rep_id);
CREATE INDEX idx_ms_orders_date ON ms_orders(order_date);
CREATE INDEX idx_ms_order_items_order_id ON ms_order_items(order_id);
CREATE INDEX idx_ms_approval_requests_status ON ms_approval_requests(status);
CREATE INDEX idx_ms_activity_log_user_id ON ms_activity_log(user_id);
CREATE INDEX idx_ms_activity_log_created_at ON ms_activity_log(created_at);

-- Row Level Security (RLS) Policies
ALTER TABLE ms_sales_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE ms_salons ENABLE ROW LEVEL SECURITY;
ALTER TABLE ms_visit_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE ms_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE ms_order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE ms_approval_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE ms_follow_up_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE ms_activity_log ENABLE ROW LEVEL SECURITY;

-- RLS Policies for ms_sales_users
CREATE POLICY "Users can view their own profile" ON ms_sales_users
    FOR SELECT USING (auth.uid()::text = id::text OR 
                     EXISTS (SELECT 1 FROM ms_sales_users WHERE id::text = auth.uid()::text AND role IN ('sales_head', 'admin')));

-- RLS Policies for ms_salons
CREATE POLICY "Sales reps can view assigned salons" ON ms_salons
    FOR SELECT USING (assigned_sales_rep::text = auth.uid()::text OR 
                     EXISTS (SELECT 1 FROM ms_sales_users WHERE id::text = auth.uid()::text AND role IN ('sales_head', 'admin')));

CREATE POLICY "Sales reps can update assigned salons" ON ms_salons
    FOR UPDATE USING (assigned_sales_rep::text = auth.uid()::text OR 
                     EXISTS (SELECT 1 FROM ms_sales_users WHERE id::text = auth.uid()::text AND role IN ('sales_head', 'admin')));

CREATE POLICY "Sales reps can insert salons" ON ms_salons
    FOR INSERT WITH CHECK (assigned_sales_rep::text = auth.uid()::text OR 
                          EXISTS (SELECT 1 FROM ms_sales_users WHERE id::text = auth.uid()::text AND role IN ('sales_head', 'admin')));

-- RLS Policies for ms_visit_plans
CREATE POLICY "Sales reps can manage their visits" ON ms_visit_plans
    FOR ALL USING (sales_rep_id::text = auth.uid()::text OR 
                   EXISTS (SELECT 1 FROM ms_sales_users WHERE id::text = auth.uid()::text AND role IN ('sales_head', 'admin')));

-- RLS Policies for ms_orders
CREATE POLICY "Sales reps can manage their orders" ON ms_orders
    FOR ALL USING (sales_rep_id::text = auth.uid()::text OR 
                   EXISTS (SELECT 1 FROM ms_sales_users WHERE id::text = auth.uid()::text AND role IN ('sales_head', 'admin')));

-- RLS Policies for ms_order_items
CREATE POLICY "Access through parent order" ON ms_order_items
    FOR ALL USING (EXISTS (SELECT 1 FROM ms_orders WHERE ms_orders.id = ms_order_items.order_id AND 
                          (ms_orders.sales_rep_id::text = auth.uid()::text OR 
                           EXISTS (SELECT 1 FROM ms_sales_users WHERE id::text = auth.uid()::text AND role IN ('sales_head', 'admin')))));

-- RLS Policies for ms_approval_requests
CREATE POLICY "Users can manage their approval requests" ON ms_approval_requests
    FOR ALL USING (requested_by::text = auth.uid()::text OR approved_by::text = auth.uid()::text OR 
                   EXISTS (SELECT 1 FROM ms_sales_users WHERE id::text = auth.uid()::text AND role IN ('sales_head', 'admin')));

-- RLS Policies for ms_follow_up_tasks
CREATE POLICY "Users can manage assigned tasks" ON ms_follow_up_tasks
    FOR ALL USING (assigned_to::text = auth.uid()::text OR 
                   EXISTS (SELECT 1 FROM ms_sales_users WHERE id::text = auth.uid()::text AND role IN ('sales_head', 'admin')));

-- RLS Policies for ms_activity_log
CREATE POLICY "Users can view their own activities" ON ms_activity_log
    FOR SELECT USING (user_id::text = auth.uid()::text OR 
                     EXISTS (SELECT 1 FROM ms_sales_users WHERE id::text = auth.uid()::text AND role IN ('sales_head', 'admin')));

-- Functions for automatic order number generation
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TEXT AS $$
DECLARE
    next_num INTEGER;
    order_num TEXT;
BEGIN
    -- Get the next sequence number for today
    SELECT COALESCE(MAX(CAST(SUBSTRING(order_number FROM 9) AS INTEGER)), 0) + 1
    INTO next_num
    FROM ms_orders
    WHERE order_date = CURRENT_DATE;
    
    -- Format: ORD-YYYYMMDD-XXXX
    order_num := 'ORD-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || LPAD(next_num::TEXT, 4, '0');
    
    RETURN order_num;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-generate order numbers
CREATE OR REPLACE FUNCTION set_order_number()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.order_number IS NULL OR NEW.order_number = '' THEN
        NEW.order_number := generate_order_number();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_order_number
    BEFORE INSERT ON ms_orders
    FOR EACH ROW
    EXECUTE FUNCTION set_order_number();

-- Function to update salon balance after order
CREATE OR REPLACE FUNCTION update_salon_balance()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE ms_salons 
        SET current_balance = current_balance + NEW.final_amount_inr,
            updated_at = NOW()
        WHERE id = NEW.salon_id;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE ms_salons 
        SET current_balance = current_balance - OLD.final_amount_inr + NEW.final_amount_inr,
            updated_at = NOW()
        WHERE id = NEW.salon_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE ms_salons 
        SET current_balance = current_balance - OLD.final_amount_inr,
            updated_at = NOW()
        WHERE id = OLD.salon_id;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_salon_balance
    AFTER INSERT OR UPDATE OR DELETE ON ms_orders
    FOR EACH ROW
    EXECUTE FUNCTION update_salon_balance();

-- Function to log activities
CREATE OR REPLACE FUNCTION log_activity(
    p_user_id UUID,
    p_action VARCHAR(100),
    p_entity_type VARCHAR(50) DEFAULT NULL,
    p_entity_id UUID DEFAULT NULL,
    p_metadata JSONB DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO ms_activity_log (user_id, action, entity_type, entity_id, metadata)
    VALUES (p_user_id, p_action, p_entity_type, p_entity_id, p_metadata);
END;
$$ LANGUAGE plpgsql;

-- Create a view for dashboard statistics
CREATE OR REPLACE VIEW ms_dashboard_stats AS
SELECT 
    (SELECT COUNT(*) FROM ms_salons WHERE status = 'active') as active_salons,
    (SELECT COUNT(*) FROM ms_salons WHERE status = 'prospect') as prospect_salons,
    (SELECT COUNT(*) FROM ms_visit_plans WHERE visit_date = CURRENT_DATE AND status = 'planned') as today_visits,
    (SELECT COUNT(*) FROM ms_orders WHERE order_date = CURRENT_DATE) as today_orders,
    (SELECT COUNT(*) FROM ms_approval_requests WHERE status = 'pending') as pending_approvals,
    (SELECT COALESCE(SUM(final_amount_inr), 0) FROM ms_orders WHERE order_date >= DATE_TRUNC('month', CURRENT_DATE)) as monthly_sales;

-- Grant necessary permissions (adjust based on your Supabase setup)
-- Note: In Supabase, you might need to adjust these grants based on your authentication setup

COMMENT ON TABLE ms_sales_users IS 'Sales team members with role-based access';
COMMENT ON TABLE ms_salons IS 'Hair salons and parlours in the network';
COMMENT ON TABLE ms_products IS 'Hair color products and related items';
COMMENT ON TABLE ms_visit_plans IS 'Scheduled and completed salon visits';
COMMENT ON TABLE ms_orders IS 'Product orders placed by salons';
COMMENT ON TABLE ms_approval_requests IS 'Requests requiring management approval';
COMMENT ON TABLE ms_activity_log IS 'Audit trail of all system activities';



