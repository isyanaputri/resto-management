-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 22, 2025 at 01:07 AM
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
-- Database: `db_restora`
--

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga` double DEFAULT NULL,
  `kategori` enum('makanan utama','minuman','makanan penutup') DEFAULT NULL,
  `gambar` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `nama`, `deskripsi`, `harga`, `kategori`, `gambar`) VALUES
(1, 'Beef Steak', 'Daging sapi impor premium dengan saus pilihan', 160000, 'makanan utama', 'assets/images/beef_steak.png'),
(2, 'Chicken Steak', 'Steak ayam krispi dengan saus jamur', 85000, 'makanan utama', 'assets/images/chicken_steak.png'),
(3, 'Pizza Deluxe', 'Topping daging melimpah dan keju mozarella', 95000, 'makanan utama', 'assets/images/pizza.png'),
(4, 'Spaghetti Carbonara', 'Pasta creamy dengan topping smoke beef', 75000, 'makanan utama', 'assets/images/spaghetti.png'),
(5, 'Mojito Series', 'Minuman segar dengan daun mint dan jeruk nipis', 35000, 'minuman', 'assets/images/mojito.png'),
(6, 'Americano', 'Kopi hitam murni dari biji pilihan', 25000, 'minuman', 'assets/images/americano.png'),
(7, 'Lychee Tea', 'Teh manis dengan buah leci segar', 30000, 'minuman', 'assets/images/lychee_tea.png'),
(8, 'Milkshake Chocolate', 'Susu cokelat kental dengan es krim', 35000, 'minuman', 'assets/images/milkshake.png'),
(9, 'Strawberry Cheesecake', 'Kue keju lembut dengan selai stroberi', 45000, 'makanan penutup', 'assets/images/cheesecake.png'),
(10, 'Pudding Mango', 'Pudding sutra rasa mangga manis', 25000, 'makanan penutup', 'assets/images/pudding.png'),
(11, 'Ice Cream Matcha', 'Es krim teh hijau khas Jepang', 30000, 'makanan penutup', 'assets/images/matcha.png'),
(12, 'Fruit Parfait', 'Lapisan yogurt, granola, dan buah segar', 40000, 'makanan penutup', 'assets/images/parfait.png');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `nomor_meja` varchar(10) DEFAULT NULL,
  `total_harga` double DEFAULT NULL,
  `metode_bayar` varchar(50) DEFAULT NULL,
  `tanggal` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `nama_menu` varchar(100) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `subtotal` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `id` int(11) NOT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `res_date` datetime DEFAULT NULL,
  `people` int(11) DEFAULT NULL,
  `table_no` varchar(10) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`id`, `customer_name`, `phone`, `res_date`, `people`, `table_no`, `notes`) VALUES
(1, 'aku', '2467', '2025-12-22 19:13:00', 4, '02', 'ultah'),
(2, 'erika', '4567', '2025-12-22 21:51:00', 1, '05', 'makan');

-- --------------------------------------------------------

--
-- Table structure for table `tables`
--

CREATE TABLE `tables` (
  `id` int(11) NOT NULL,
  `nomor_meja` varchar(10) NOT NULL,
  `status` enum('kosong','terisi','dipesan') DEFAULT 'kosong',
  `kapasitas` int(11) DEFAULT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tables`
--

INSERT INTO `tables` (`id`, `nomor_meja`, `status`, `kapasitas`, `keterangan`) VALUES
(1, '01', 'terisi', 2, 'Pesanan Aktif:\n- Beef Steak (1)\n\nEst. Tagihan: Rp 160.000'),
(2, '02', 'terisi', 2, 'Pesanan Aktif:\n- Beef Steak (1 porsi)\n- Americano (1 porsi)\n\nEst. Tagihan: Rp 185.000'),
(3, '03', 'terisi', 4, 'Pesanan Aktif:\n- Chicken Steak (1)\n\nEst. Tagihan: Rp 85.000'),
(4, '04', 'kosong', 4, NULL),
(5, '05', 'kosong', 6, NULL),
(6, '06', 'kosong', 2, NULL),
(7, '07', 'kosong', 2, NULL),
(8, '08', 'kosong', 4, NULL),
(9, '09', 'kosong', 4, NULL),
(10, '10', 'kosong', 8, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `role` enum('owner','staff') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, 'Isyana', '123', 'owner'),
(2, 'rika', '123', 'staff'),
(3, 'adhan', '123', 'owner');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tables`
--
ALTER TABLE `tables`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
