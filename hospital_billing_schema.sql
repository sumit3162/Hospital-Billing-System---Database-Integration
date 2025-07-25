-- Enhanced Hospital Billing System Database Schema
-- Includes additional tables for doctors, rooms, and payment tracking

-- Create database with UTF-8 character set
CREATE DATABASE IF NOT EXISTS hospital_billing 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE hospital_billing;

-- Patients table with additional fields
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender CHAR(1) NOT NULL,
    contact VARCHAR(15) NOT NULL,
    address TEXT,
    email VARCHAR(100),
    insurance_provider VARCHAR(100),
    insurance_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_patient_name (name),
    INDEX idx_patient_contact (contact)
);

-- Doctors table
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    contact VARCHAR(15) NOT NULL,
    consultation_fee DECIMAL(10, 2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Rooms table
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type ENUM('General', 'Private', 'ICU', 'Operation Theater') NOT NULL,
    daily_rate DECIMAL(10, 2) NOT NULL,
    is_occupied BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bills table with enhanced fields
CREATE TABLE bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT,
    admission_date DATE,
    discharge_date DATE,
    room_id INT,
    subtotal DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) DEFAULT 0.00,
    tax DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('Pending', 'Paid', 'Partially Paid', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    INDEX idx_bill_status (status),
    INDEX idx_bill_date (created_at)
);

-- Treatments table with additional details
CREATE TABLE treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    quantity INT DEFAULT 1,
    treatment_date DATE,
    doctor_id INT,
    notes TEXT,
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Payments table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('Cash', 'Credit Card', 'Debit Card', 'Insurance', 'Bank Transfer') NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_reference VARCHAR(100),
    received_by VARCHAR(100),
    notes TEXT,
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id),
    INDEX idx_payment_date (payment_date)
);

-- Enhanced sample data insertion
INSERT INTO patients (name, age, gender, contact, address, email, insurance_provider, insurance_number) VALUES 
('Shraddha Sharma', 21, 'F', '9921709429', '123 Main St, Mumbai', 'shraddha@example.com', 'Star Health', 'STAR-12345'),
('John Doe', 35, 'M', '5551234567', '456 Oak Ave, Delhi', 'john@example.com', 'Max Bupa', 'MAX-67890'),
('Priya Patel', 28, 'F', '9876543210', '789 Pine Rd, Bangalore', 'priya@example.com', NULL, NULL);

INSERT INTO doctors (name, specialization, contact, consultation_fee) VALUES 
('Dr. Rajesh Kumar', 'Cardiology', '9876123456', 800.00),
('Dr. Priya Sharma', 'Pediatrics', '8765432109', 600.00),
('Dr. Amit Patel', 'Orthopedics', '7654321098', 700.00);

INSERT INTO rooms (room_number, room_type, daily_rate) VALUES 
('101', 'General', 1500.00),
('201', 'Private', 3500.00),
('ICU1', 'ICU', 8000.00),
('OT1', 'Operation Theater', 12000.00);

INSERT INTO bills (patient_id, doctor_id, admission_date, discharge_date, room_id, subtotal, discount, tax, total_amount, status) VALUES 
(1, 1, '2023-05-10', '2023-05-15', 2, 20000.00, 1000.00, 3420.00, 22420.00, 'Paid'),
(2, 2, '2023-05-12', NULL, 1, 15000.00, 0.00, 2700.00, 17700.00, 'Partially Paid'),
(3, 3, '2023-05-15', '2023-05-20', 3, 35000.00, 2000.00, 5940.00, 38940.00, 'Pending');

INSERT INTO treatments (bill_id, description, cost, quantity, treatment_date, doctor_id, notes) VALUES 
(1, 'Cardiac Consultation', 800.00, 1, '2023-05-10', 1, 'Initial consultation'),
(1, 'ECG Test', 1200.00, 1, '2023-05-11', 1, NULL),
(1, 'Room Charges', 3500.00, 5, '2023-05-15', NULL, 'Private room for 5 days'),
(2, 'Pediatric Checkup', 600.00, 2, '2023-05-12', 2, 'Follow-up required'),
(2, 'Blood Test', 500.00, 1, '2023-05-13', NULL, 'Complete blood count'),
(3, 'Knee Surgery', 25000.00, 1, '2023-05-15', 3, 'Successful procedure'),
(3, 'Post-Op Physiotherapy', 1000.00, 5, '2023-05-16', 3, 'Daily sessions');

INSERT INTO payments (bill_id, amount, payment_method, transaction_reference, received_by) VALUES 
(1, 22420.00, 'Credit Card', 'TXN-123456', 'Admin User'),
(2, 5000.00, 'Cash', NULL, 'Front Desk'),
(3, 15000.00, 'Insurance', 'CLAIM-7890', 'Billing Dept');