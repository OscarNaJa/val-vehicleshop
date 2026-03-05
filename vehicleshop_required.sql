-- SQL ที่ระบบต้องใช้ทั้งหมดสำหรับ resource: val-vehicleshop
-- จากการสแกนโค้ดทั้ง resource พบว่าใช้งานฐานข้อมูลเฉพาะตารางเดียวคือ `owned_vehicles`
-- (อ่าน plate และบันทึก owner/plate/vehicle ผ่าน ON DUPLICATE KEY UPDATE)

CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` VARCHAR(60) NOT NULL,
  `plate` VARCHAR(12) NOT NULL,
  `vehicle` LONGTEXT NOT NULL,
  PRIMARY KEY (`plate`),
  KEY `idx_owned_vehicles_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- รองรับกรณีมีตารางเดิมอยู่แล้ว แต่คอลัมน์จำเป็นยังไม่ครบ
SET @has_owner_col := (
  SELECT COUNT(1)
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name = 'owned_vehicles'
    AND column_name = 'owner'
);
SET @sql := IF(
  @has_owner_col = 0,
  'ALTER TABLE `owned_vehicles` ADD COLUMN `owner` VARCHAR(60) NOT NULL',
  'SELECT "owned_vehicles.owner exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @has_plate_col := (
  SELECT COUNT(1)
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name = 'owned_vehicles'
    AND column_name = 'plate'
);
SET @sql := IF(
  @has_plate_col = 0,
  'ALTER TABLE `owned_vehicles` ADD COLUMN `plate` VARCHAR(12) NOT NULL',
  'SELECT "owned_vehicles.plate exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @has_vehicle_col := (
  SELECT COUNT(1)
  FROM information_schema.columns
  WHERE table_schema = DATABASE()
    AND table_name = 'owned_vehicles'
    AND column_name = 'vehicle'
);
SET @sql := IF(
  @has_vehicle_col = 0,
  'ALTER TABLE `owned_vehicles` ADD COLUMN `vehicle` LONGTEXT NOT NULL',
  'SELECT "owned_vehicles.vehicle exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ต้องมี UNIQUE/PRIMARY ที่ plate เพื่อให้ ON DUPLICATE KEY UPDATE ทำงานได้
SET @has_plate_unique := (
  SELECT COUNT(1)
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
    AND table_name = 'owned_vehicles'
    AND column_name = 'plate'
    AND non_unique = 0
);
SET @sql := IF(
  @has_plate_unique = 0,
  'ALTER TABLE `owned_vehicles` ADD UNIQUE KEY `uk_owned_vehicles_plate` (`plate`)',
  'SELECT "owned_vehicles.plate already has UNIQUE/PRIMARY key"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- index owner สำหรับการค้นหาตามผู้เล่น
SET @has_owner_index := (
  SELECT COUNT(1)
  FROM information_schema.statistics
  WHERE table_schema = DATABASE()
    AND table_name = 'owned_vehicles'
    AND index_name = 'idx_owned_vehicles_owner'
);
SET @sql := IF(
  @has_owner_index = 0,
  'ALTER TABLE `owned_vehicles` ADD KEY `idx_owned_vehicles_owner` (`owner`)',
  'SELECT "idx_owned_vehicles_owner exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
