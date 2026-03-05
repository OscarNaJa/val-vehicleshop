-- SQL ที่จำเป็นสำหรับสคริปต์ val-vehicleshop
-- อ้างอิงจาก core/server.lua ที่ใช้งานตาราง owned_vehicles

CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` VARCHAR(60) NOT NULL,
  `plate` VARCHAR(12) NOT NULL,
  `vehicle` LONGTEXT NOT NULL,
  `type` VARCHAR(20) DEFAULT 'car',
  `job` VARCHAR(20) DEFAULT NULL,
  `stored` TINYINT(1) DEFAULT 1,
  PRIMARY KEY (`plate`),
  KEY `idx_owned_vehicles_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ทำให้รันซ้ำได้: เพิ่ม UNIQUE plate เฉพาะกรณียังไม่มี
SET @has_plate_key := (
  SELECT COUNT(1)
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
    AND table_name = 'owned_vehicles'
    AND column_name = 'plate'
    AND non_unique = 0
);

SET @sql := IF(
  @has_plate_key = 0,
  'ALTER TABLE `owned_vehicles` ADD UNIQUE KEY `uk_owned_vehicles_plate` (`plate`)',
  'SELECT "owned_vehicles.plate already has UNIQUE/PRIMARY key"'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
