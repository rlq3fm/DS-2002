DROP database IF EXISTS `chinook_dw`;
CREATE DATABASE `chinook_dw` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE chinook_dw;

DROP TABLE IF EXISTS `dim_customers`;
CREATE TABLE `dim_customers` (
  `customer_key` int NOT NULL AUTO_INCREMENT,
  `customer_first_name` varchar(50) DEFAULT NULL,
  `customer_last_name` varchar(50) DEFAULT NULL,
  `company` varchar(50) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `postal_code` varchar(15) DEFAULT NULL,
  `phone` varchar(25) DEFAULT NULL,
  `email` varchar(60),
  `support_employee_key` int DEFAULT NULL,
  PRIMARY KEY (`customer_key`),
  KEY `support_employee_key` (`support_employee_key`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `dim_employees`;
CREATE TABLE `dim_employees` (
  `employee_key` int NOT NULL,
  `employee_last_name` varchar(20) DEFAULT NULL,
  `employee_first_name` varchar(20) DEFAULT NULL,
  `title` varchar(30) DEFAULT NULL,
  `reports_to_employee_key` int DEFAULT NULL,
  `address` varchar(70) DEFAULT NULL,
  `city` varchar(40) DEFAULT NULL,
  `state` varchar(40) DEFAULT NULL,
  `country` varchar(40) DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(24) DEFAULT NULL,
  `fax` varchar(24) DEFAULT NULL,
  `email` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`employee_key`),
  KEY `reports_to_employee_key` (`reports_to_employee_key`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `dim_tracks`;
CREATE TABLE `dim_tracks` (
  `track_key` int NOT NULL AUTO_INCREMENT,
  `track_name` varchar(200) DEFAULT NULL,
  `album_key` int DEFAULT NULL,
  `album_title` varchar(160) DEFAULT NULL,
  `artist_key` int DEFAULT NULL,
  `artist_name` varchar(120) DEFAULT NULL,
  `media_type_key` int DEFAULT NULL,
  `media_type_name` varchar(120) DEFAULT NULL,
  `genre_key` int DEFAULT NULL,
  `genre_name` varchar(120) DEFAULT NULL,
  `composer` varchar(220) DEFAULT NULL,
  `milliseconds` int DEFAULT NULL,
  `bytes` int DEFAULT NULL,
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`track_key`),
  KEY `album_key` (`album_key`),
  KEY `artist_key` (`artist_key`),
  KEY `genre_key` (`genre_key`),
  KEY `media_type_key` (`media_type_key`)
) ENGINE=InnoDB AUTO_INCREMENT=3500 DEFAULT CHARSET=utf8mb4;



DROP TABLE IF EXISTS `fact_invoices`;
CREATE TABLE `fact_invoices` (
  `fact_invoice_key` int NOT NULL AUTO_INCREMENT,
  `invoice_key` int DEFAULT NULL,
  `customer_key` int DEFAULT NULL,
  `track_key` int DEFAULT NULL,
  `invoice_date` datetime NOT NULL,
  `billing_address` varchar(70) DEFAULT NULL,
  `billing_city` varchar(40) DEFAULT NULL,
  `billing_state` varchar(40) DEFAULT NULL,
  `billing_country` varchar(40) DEFAULT NULL,
  `billing_postal_code` varchar(10) DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `invoice_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`fact_invoice_key`),
  KEY `invoice_key` (`invoice_key`),
  KEY `customer_key` (`customer_key`),
  KEY `track_key` (`track_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
