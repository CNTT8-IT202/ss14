CREATE DATABASE telecom_system_db;
USE telecom_system_db;

CREATE TABLE telecom_towers (
    tower_id INT AUTO_INCREMENT PRIMARY KEY,
    tower_name VARCHAR(100) NOT NULL,
    serial_number VARCHAR(50) UNIQUE NOT NULL,
    location_zone VARCHAR(50) NOT NULL,
    commission_date DATE NOT NULL
);


CREATE TABLE engineers (
    engineer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    skill_level VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    safety_rating DECIMAL(2,1) DEFAULT 5.0 CHECK (safety_rating BETWEEN 0.0 AND 5.0)
);

CREATE TABLE maintenance_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    tower_id INT NOT NULL,
    engineer_id INT NOT NULL,
    scheduled_time DATETIME NOT NULL,
    operation_cost DECIMAL(12,2) CHECK (operation_cost > 0),
    order_status ENUM('Assigned', 'Executed', 'Aborted') NOT NULL,
    FOREIGN KEY (tower_id) REFERENCES telecom_towers(tower_id),
    FOREIGN KEY (engineer_id) REFERENCES engineers(engineer_id)
);

CREATE TABLE technical_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    hardware_status VARCHAR(100) NOT NULL,
    bandwidth_cap VARCHAR(50) NOT NULL,
    action_taken TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES maintenance_orders(order_id)
);

CREATE TABLE incident_reports (
    incident_id INT AUTO_INCREMENT PRIMARY KEY,
    log_id INT NOT NULL,
    engineer_id INT NOT NULL,
    reported_time DATETIME NOT NULL,
    root_cause TEXT,
    FOREIGN KEY (log_id) REFERENCES technical_logs(log_id),
    FOREIGN KEY (engineer_id) REFERENCES engineers(engineer_id)
);

INSERT INTO telecom_towers (tower_id, tower_name, serial_number, location_zone, commission_date)
VALUES (1, 'Trạm Đông Đô', 'SN-9901-X', 'Zone A', '1999-12-03'),
       (2, 'Trạm Tây Sơn', 'SN-9902-Y', 'Zone B', '1996-11-25'),
       (3, 'Trạm Nam Hải', 'SN-9903-Z', 'Zone C', '2001-07-08'),
       (4, 'Trạm Bắc Bình', 'SN-9904-W', 'Zone A', '1998-01-19'),
       (5, 'Trạm Trung Trung', 'SN-9905-V', 'Zone D', '2000-09-30');

INSERT INTO engineers (engineer_id, full_name, skill_level, phone_number, safety_rating)
VALUES (1, 'KS. Nguyễn Văn Hải', 'Bậc 5', '0931112223', 4.8),
	   (2, 'KS. Trần Thu Hà', 'Bậc 4', '0932223334', 5.0),
       (3, 'KS. Lê Quốc Tuấn', 'Bậc 6', '0933334445', 4.6),
	   (4, 'KS. Phạm Minh Châu', 'Bậc 3', '0934445556', 4.9),
       (5, 'KS. Hoàng Gia Bảo', 'Bậc 5', '0935556667', 4.7);

INSERT INTO maintenance_orders (order_id, tower_id, engineer_id, scheduled_time, operation_cost, order_status)
VALUES (7006, 1, 1, '2024-05-20 08:00:00', 400000, 'Assigned'),
	   (7007, 2, 2, '2024-05-20 09:30:00', 450000, 'Executed'),
       (7003, 3, 3, '2024-05-20 10:15:00', 300000, 'Assigned'),
       (7004, 4, 5, '2024-05-21 07:00:00', 350000, 'Executed'),
       (7005, 5, 4, '2024-05-21 08:45:00', 220000, 'Aborted');

INSERT INTO technical_logs (log_id, order_id, hardware_status, bandwidth_cap, action_taken, created_at)
VALUES (8001, 7002, 'Nhiệt độ cao', '150 Mbps', 'Xả tải, tra keo tản nhiệt', '2024-05-20 10:00:00'),
       (8002, 7004, 'Sụt nguồn nhẹ', '300 Mbps', 'Đấu nối lại lốc nguồn phụ', '2024-05-21 08:00:00'),
       (8003, 7001, 'Nhiễu tần số', '100 Mbps', 'Cấu hình lại bộ lọc sóng', '2024-05-20 09:00:00'),
       (8004, 7003, 'Suy hao quang', '200 Mbps', 'Thay mới dây nhảy quang', '2024-05-20 11:00:00'),
	   (8005, 7005, 'Lỗi cổng chào', '0 Mbps', 'Không xử lý do lệnh hủy', '2024-05-21 09:00:00');

INSERT INTO incident_reports (incident_id, log_id, engineer_id, reported_time, root_cause)
VALUES (1, 8003, 1, '2024-05-20 09:05:00', 'Đã kiểm tra xung đột tần số'),
       (2, 8001, 2, '2024-05-20 10:05:00', 'Hoàn tất cấu hình phần cứng'),
       (3, 8004, 3, '2024-05-20 11:10:00', 'Phát hiện đứt cáp ngầm nhẹ'),
       (4, 8002, 5, '2024-05-21 08:10:00', 'Đạt độ ổn định công suất'),
       (5, 8005, 4, '2024-05-21 09:05:00', 'Trạm dừng hoạt động ngoại cảnh');
       
-- phần 2 
-- Cách 1
update maintenance_orders as mo, telecom_towers as tt
set mo.operation_cost = mo.operation_cost * 1.1 
where mo.order_status = 'Executed' 
and (mo.tower_id = tt.tower_id and year(tt.commission_date) < 2000);

SET SQL_SAFE_UPDATES = 0;
-- Cách 2
update maintenance_orders as mo
INNER JOIN telecom_towers as tt
ON mo.tower_id = tt.tower_id
set mo.operation_cost = mo.operation_cost * 1.1 
where mo.order_status = 'Assigned' and year(tt.commission_date) < 2000;

delete from incident_reports where reported_time < '2024-05-21';


-- Phần 3
-- Câu 1
SELECT full_name,skill_level,safety_rating
FROM engineers
WHERE safety_rating > 4.7 OR skill_level = 'Bậc 4';

-- Câu 2
SELECT tower_name,serial_number
FROM telecom_towers
WHERE commission_date BETWEEN '1998-01-01' AND '2001-12-31'
AND serial_number LIKE 'SN-990%';

-- Câu 3
SELECT order_id,scheduled_time,operation_cost
FROM maintenance_orders
ORDER BY operation_cost DESC 
LIMIT 2 OFFSET 2;

-- PHẦN 4: TRUY VẤN NÂNG CAO
-- CÂU 1
SELECT tt.tower_name, e.full_name, e.skill_level, mo.operation_cost, mo.scheduled_time
FROM maintenance_orders mo
JOIN telecom_towers tt ON mo.tower_id = tt.tower_id
JOIN engineers e ON mo.engineer_id = e.engineer_id;

-- CÂU 2
SELECT e.full_name, SUM(mo.operation_cost) AS toltal_cost
FROM engineers e
JOIN maintenance_orders mo ON mo.engineer_id = e.engineer_id
WHERE order_status = 'Executed'
GROUP BY e.engineer_id, e.full_name
HAVING SUM(mo.operation_cost) > 300000;

-- CÂU 3
SELECT engineer_id, full_name, safety_rating
FROM engineers
WHERE safety_rating = (
	SELECT MAX(safety_rating)
    FROM engineers
);

-- PHẦN 5: INDEX & VIEW (10 ĐIỂM)
-- Câu 1
CREATE INDEX idx_mount_cost
on maintenance_orders (order_status, operation_cost);

-- Câu 2
CREATE OR REPLACE VIEW view_engineers AS
SELECT full_name, COUNT(mo.order_id) as 'Tổng số lệnh', SUM(mo.operation_cost) as 'Tổng chi phí'
FROM engineers as e
INNER JOIN maintenance_orders as mo
ON e.engineer_id = mo.engineer_id 
WHERE order_status != 'Aborted'
GROUP BY full_name;

SELECT * FROM view_engineers;

-- PHẦN 6: TRIGGER (10 ĐIỂM)
-- Câu 1
DELIMITER //
CREATE TRIGGER trigger_after_update_maintenance_orders
AFTER UPDATE ON maintenance_orders
FOR EACH ROW
BEGIN
	IF NEW.order_status = 'Executed' 
		THEN
			INSERT INTO incident_reports VALUES
			(NULL,
			(SELECT log_id FROM technical_logs WHERE order_id = NEW.order_id)
            ,NEW.engineer_id, NOW(), 'System check completed');
	END IF;
END //
DELIMITER ;


DROP TRIGGER trigger_after_update_maintenance_orders;
UPDATE maintenance_orders
SET order_status = 'Executed'
WHERE order_id = '7006';














       
