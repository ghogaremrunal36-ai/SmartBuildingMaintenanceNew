-- =====================================================================
-- SMART BUILDING MAINTENANCE SYSTEM
-- Database: smart_building_new
-- Compatible with MySQL 5.7+ / 8.0+
-- =====================================================================

CREATE DATABASE IF NOT EXISTS smart_building_new;
USE smart_building_new;

-- =====================================================================
-- 1. USERS TABLE
-- =====================================================================
DROP TABLE IF EXISTS maintenance_requests;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================================
-- 2. MAINTENANCE REQUESTS TABLE
-- =====================================================================
CREATE TABLE maintenance_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(500) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_request
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =====================================================================
-- 3. SEED DATA FOR DEMO & TESTING
-- =====================================================================

-- Insert Administrators and Residents
INSERT INTO users (name, email, password, phone, role, created_at) VALUES
('System Administrator', 'admin@smartbuilding.com', 'admin123', '+1 555-0199', 'ADMIN', NOW() - INTERVAL 30 DAY),
('Building Manager', 'manager@smartbuilding.com', 'manager123', '+1 555-0198', 'ADMIN', NOW() - INTERVAL 25 DAY),
('John Doe (Apt 402)', 'john@gmail.com', 'user123', '+1 555-0101', 'USER', NOW() - INTERVAL 20 DAY),
('Sarah Connor (Apt 501)', 'sarah@gmail.com', 'user123', '+1 555-0102', 'USER', NOW() - INTERVAL 15 DAY),
('Michael Scott (Apt 204)', 'michael@gmail.com', 'user123', '+1 555-0103', 'USER', NOW() - INTERVAL 10 DAY),
('Emily Watson (Apt 305)', 'emily@gmail.com', 'user123', '+1 555-0104', 'USER', NOW() - INTERVAL 5 DAY);

-- Insert Sample Maintenance Requests
INSERT INTO maintenance_requests (user_id, title, description, category, status, created_at) VALUES
(3, 'Water Leakage Under Kitchen Sink', 'Persistent pipe drip causing water pooling under the cabinet in apartment 402.', 'Plumbing', 'PENDING', NOW() - INTERVAL 1 DAY),
(3, 'Flickering Corridor Light', 'Main ceiling LED panel in the unit hallway is flickering intermittently.', 'Electrical', 'IN PROGRESS', NOW() - INTERVAL 3 DAY),
(4, 'HVAC Cooling Unit Not Working', 'Central air conditioning blowing warm air during afternoon peak hours.', 'Air Conditioning', 'IN PROGRESS', NOW() - INTERVAL 4 DAY),
(5, 'Elevator B Door Sticking', 'Passenger elevator door on the 2nd floor jerks and fails to open smoothly.', 'Lift / Elevator', 'PENDING', NOW() - INTERVAL 2 HOUR),
(4, 'Deep Cleaning for 5th Floor Stairwell', 'Spilled paint residue and dust near fire exit doorway needs power scrubbing.', 'Cleaning', 'COMPLETED', NOW() - INTERVAL 6 DAY),
(6, 'Balcony Sliding Door Latch Loose', 'Security latch on the balcony sliding glass door has stripped screws.', 'Other', 'COMPLETED', NOW() - INTERVAL 8 DAY),
(5, 'Water Pressure Low in Bathroom', 'Hot water pressure in master shower dropped significantly since yesterday.', 'Plumbing', 'PENDING', NOW() - INTERVAL 5 HOUR),
(6, 'AC Thermostat Display Dead', 'Digital wall thermostat for AC unit is totally dark and unresponsive.', 'Air Conditioning', 'COMPLETED', NOW() - INTERVAL 12 DAY);

-- Check inserted data
SELECT * FROM users;
SELECT * FROM maintenance_requests;
