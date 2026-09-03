-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 03, 2026 at 10:19 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sunrise_dental_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `appointment_no` int(11) NOT NULL,
  `patient_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `contact_number` varchar(15) NOT NULL,
  `dentist_name` varchar(100) NOT NULL,
  `treatment_id` int(11) DEFAULT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `total_cost` double DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`appointment_no`, `patient_name`, `email`, `address`, `contact_number`, `dentist_name`, `treatment_id`, `appointment_date`, `appointment_time`, `total_cost`) VALUES
(1, 'D.W.G.P.B.D.Kumarasinghe', NULL, 'Matale Road, Rattota.', '0770562060', 'Dr. Silva', 1, '2026-09-02', '10:00:00', 3500),
(2, 'Hiranya Senavirthna', NULL, 'kandy Road, matale.', '0763043194', 'Dr. Perera', 1, '2026-09-10', '08:30:00', 2500),
(8, 'Srima Nilmini', NULL, 'Colombo, Rajagiriya', '0777431788', 'Dr. Silva', 2, '2026-09-29', '08:00:00', 3500),
(9, 'Dilshan Senarathne', NULL, 'Trinkomalee Road, kandy', '0781234569', 'Dr. Perera', 1, '2026-09-25', '10:10:00', 15000),
(12, 'Pramod Badrajith', 'badrajithpramod@gmail.com', 'Matale Road, Rattota.', '0770563020', 'Dr. Silva', 1, '2026-09-03', '15:00:00', 2500),
(13, 'Bathiya Bandara', 'badrajithpramod@gmail.com', 'Kandy Road, Matale', '0761258493', 'Dr. Fernando', 4, '2026-09-26', '09:00:00', 50000),
(15, 'Mihira Dilnuwan ', NULL, 'kandy Road, Matale', '0777894561', 'Dr. Silva', 1, '2026-09-18', '09:00:00', 3500),
(17, 'Sagara Jayasuriya', NULL, 'Colombo 4, Colombo.', '0741593578', 'Dr. Silva', 1, '2026-09-12', '19:30:00', 3500);

--
-- Triggers `appointments`
--
DELIMITER $$
CREATE TRIGGER `CalculateTotalCost_Insert` BEFORE INSERT ON `appointments` FOR EACH ROW BEGIN
    DECLARE t_cost DOUBLE;
    SELECT consultation_fee INTO t_cost FROM treatments WHERE treatment_id = NEW.treatment_id;
    SET NEW.total_cost = t_cost + 1000;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `CalculateTotalCost_Update` BEFORE UPDATE ON `appointments` FOR EACH ROW BEGIN
    DECLARE t_cost DOUBLE;
    SELECT consultation_fee INTO t_cost FROM treatments WHERE treatment_id = NEW.treatment_id;
    SET NEW.total_cost = t_cost + 1000;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `treatments`
--

CREATE TABLE `treatments` (
  `treatment_id` int(11) NOT NULL,
  `treatment_name` varchar(100) NOT NULL,
  `consultation_fee` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `treatments`
--

INSERT INTO `treatments` (`treatment_id`, `treatment_name`, `consultation_fee`) VALUES
(1, 'Teeth Cleaning', 2500),
(2, 'Tooth Extraction', 3500),
(3, 'Root Canal', 15000),
(4, 'Dental Braces', 50000);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(20) DEFAULT 'Staff'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role`) VALUES
(1, 'admin', '202cb962ac59075b964b07152d234b70', 'Admin'),
(3, 'Uththarangii', '250cf8b51c773f3f8dc8b4be867a9a02', 'STAFF'),
(4, 'pramod', '68053af2923e00204c3ca7c6a3150cf7', 'STAFF');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`appointment_no`),
  ADD KEY `treatment_id` (`treatment_id`);

--
-- Indexes for table `treatments`
--
ALTER TABLE `treatments`
  ADD PRIMARY KEY (`treatment_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `appointment_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `treatments`
--
ALTER TABLE `treatments`
  MODIFY `treatment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`treatment_id`) REFERENCES `treatments` (`treatment_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
