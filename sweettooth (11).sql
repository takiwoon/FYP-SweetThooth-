-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 30, 2025 at 08:33 PM
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
-- Database: `sweettooth`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `process_stamp_earnings` (IN `p_user_id` INT, IN `p_order_amount` DECIMAL(10,2))   BEGIN
    DECLARE v_stamps_to_add INT;
    DECLARE v_active_card_id INT;
    DECLARE v_current_stamps INT;
    DECLARE v_remaining_stamps INT;
    
    -- 计算应得印章数量 (每RM100得1个印章)
    SET v_stamps_to_add = FLOOR(p_order_amount / 100);
    
    IF v_stamps_to_add > 0 THEN
        -- 查找用户当前活跃的积点卡
        SELECT card_id, stamps_earned INTO v_active_card_id, v_current_stamps
        FROM stamp_cards 
        WHERE user_id = p_user_id AND is_active = 1
        LIMIT 1;
        
        -- 如果没有活跃卡，创建一张新卡
        IF v_active_card_id IS NULL THEN
            INSERT INTO stamp_cards (user_id, stamps_earned) VALUES (p_user_id, 0);
            SET v_active_card_id = LAST_INSERT_ID();
            SET v_current_stamps = 0;
        END IF;
        
        -- 计算添加印章后的总数
        SET v_remaining_stamps = v_current_stamps + v_stamps_to_add;
        
        -- 如果超过10个印章，处理兑换和新卡
        WHILE v_remaining_stamps >= 10 DO
            -- 兑换当前卡
            INSERT INTO stamp_redemptions (user_id, card_id, discount_amount)
            VALUES (p_user_id, v_active_card_id, 50.00);
            
            -- 标记当前卡为不活跃
            UPDATE stamp_cards SET is_active = 0 WHERE card_id = v_active_card_id;
            
            -- 创建新卡并计算剩余印章
            SET v_remaining_stamps = v_remaining_stamps - 10;
            
            -- 如果有剩余印章，创建新卡
            IF v_remaining_stamps > 0 THEN
                INSERT INTO stamp_cards (user_id, stamps_earned) 
                VALUES (p_user_id, v_remaining_stamps);
                SET v_active_card_id = LAST_INSERT_ID();
                SET v_remaining_stamps = 0;
            END IF;
        END WHILE;
        
        -- 更新当前活跃卡的印章数量
        IF v_active_card_id IS NOT NULL AND v_remaining_stamps > 0 THEN
            UPDATE stamp_cards 
            SET stamps_earned = v_remaining_stamps 
            WHERE card_id = v_active_card_id;
        END IF;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `name`, `email`, `password`) VALUES
(2, 'woonlong', 'chuahwoonlong@gmail.com', '$2y$10$9r2WG1CEm5np/UiVV5xfzuqBUUSWhUs9HzLtunzw3iv8eknuKfaBu');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`cart_id`, `user_id`, `product_id`, `quantity`, `added_at`) VALUES
(400, 17, 31, 4, '2025-04-29 13:00:16'),
(406, 17, 5, 1, '2025-04-30 00:45:38');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `category_name`) VALUES
(2, 'Dessert'),
(4, 'Donut'),
(5, 'Drink'),
(3, 'Slice cake'),
(1, 'Whole Cake');

-- --------------------------------------------------------

--
-- Table structure for table `delivery`
--

CREATE TABLE `delivery` (
  `delivery_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `address` text NOT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` varchar(50) DEFAULT NULL,
  `delivery_notes` text DEFAULT NULL,
  `status` enum('Pending','Preparing','Out for Delivery','Delivered','Failed') NOT NULL DEFAULT 'Pending',
  `preparing_time` datetime DEFAULT NULL,
  `out_for_delivery_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `delivery`
--

INSERT INTO `delivery` (`delivery_id`, `order_id`, `address`, `delivery_date`, `delivery_time`, `delivery_notes`, `status`, `preparing_time`, `out_for_delivery_time`) VALUES
(273, 295, '84, jalan pinang 17', '2025-04-19', '23:18', '', 'Delivered', '2025-04-19 20:59:03', '2025-04-19 22:18:26'),
(274, 296, '84, jalan pinang 17', '2025-04-20', '18:45', '', 'Delivered', '2025-04-19 20:59:08', '2025-04-19 22:30:48'),
(275, 297, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(276, 298, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(277, 299, '84, jalan pinang 17', NULL, NULL, '', 'Out for Delivery', '2025-04-19 22:27:32', '2025-04-19 22:31:20'),
(278, 300, 'ixora apartment', NULL, NULL, 'just put at the guard house', '', NULL, NULL),
(279, 301, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(280, 302, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(281, 303, '11,jalan putra 2/16,taman jp setia', NULL, NULL, '', 'Preparing', '2025-04-21 15:54:52', NULL),
(282, 304, '11,jalan putra 2/16,taman jp setia', NULL, NULL, '', 'Pending', NULL, NULL),
(283, 305, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(284, 306, '84, jalan pinang 17', NULL, NULL, '', 'Preparing', '2025-04-27 19:25:09', NULL),
(285, 307, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(286, 308, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(287, 309, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(288, 310, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(289, 311, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(290, 312, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(291, 313, '84, jalan pinang 17', NULL, NULL, '', '', NULL, NULL),
(292, 314, '84, jalan pinang 17', NULL, NULL, '', 'Pending', NULL, NULL),
(293, 315, '84, jalan pinang 17', NULL, NULL, '', 'Pending', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `dessert_info`
--

CREATE TABLE `dessert_info` (
  `id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `ingredients` text DEFAULT NULL,
  `allergens` text DEFAULT NULL,
  `nutrition_facts` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dessert_info`
--

INSERT INTO `dessert_info` (`id`, `menu_id`, `ingredients`, `allergens`, `nutrition_facts`) VALUES
(5, 5, 'Flour, Sugar, Cocoa Powder, Baking Powder, Baking Soda, Eggs, Milk, Butter, Vanilla Extract, Chocolate Ganache or Frosting.', 'Eggs, Dairy (Milk, Butter) and Gluten (Flour)', '(Calories: 350 kcal)\n\n(Carbohydrates: 45g)\n\n(Sugar: 30g)\n\n(Fat: 18g)\n\n(Protein: 5g)'),
(30, 31, 'Flour, Cocoa Powder, Sugar, Baking Powder & Baking Soda, Eggs, Milk, Butter, Vanilla Extract, Chocolate Ganache or Frosting, Fresh Strawberries', 'Eggs, Dairy (Milk, Butter) and Gluten (Flour)', '(Calories: 320 kcal)\n\n(Carbohydrates: 40g)\n\n(Sugar: 28g)\n\n(Fat: 15g)\n\n(Protein: 4g)'),
(31, 32, 'Dark Chocolate,\n\nHeavy Cream,\n\nSugar,\n\nEggs,\n\nOrange Zest & Juice,\n\nGelatin,\n\nVanilla Extract,\n\nCrunchy Biscuit Base', 'Dairy (Milk, Cream, Butter),\n\nEggs,\n\nGluten (Biscuit Base)', '(Calories: 340 kcal)\n\n(Carbohydrates: 38g)\n\n(Sugar: 30g)\n\n(Fat: 18g)\n\n(Protein: 5g)'),
(32, 33, 'Flour,\n\nSugar,\n\nEggs,\n\nButter,\n\nMilk,\n\nVanilla Extract,\n\nWhipped Cream,\n\nMixed Berries (Strawberries, Blueberries, Raspberries, Red Currants)', 'Dairy (Milk, Butter, Cream),\n\nEggs,\n\nGluten (Flour)', '(Calories: 290 kcal)\n\n(Carbohydrates: 35g)\n\n(Sugar: 22g)\n\n(Fat: 14g)\n\n(Protein: 4g)'),
(34, 35, 'Flour,\n\nCocoa Powder,\n\nSugar,\n\nEggs,\n\nButter,\n\nHeavy Cream,\n\nChocolate Ganache,\n\nDark Chocolate Curls', 'Dairy (Milk, Butter, Cream),\n\nEggs,\n\nGluten (Flour)', '(Calories: 360 kcal)\n\n(Carbohydrates: 44g)\n\n(Sugar: 30g)\n\n(Fat: 18g)\n\n(Protein: 5g)'),
(35, 36, 'Flour,\n\nSugar,\n\nEggs,\n\nButter,\n\nMilk,\n\nVanilla Extract,\n\nWhipped Cream,\n\nMaraschino Cherry', 'Dairy (Milk, Butter, Cream),\n\nEggs,\n\nGluten (Flour)', '(Calories: 280 kcal)\n\n(Carbohydrates: 36g)\n\n(Sugar: 24g)\n\n(Fat: 12g)\n\n(Protein: 4g)'),
(36, 37, 'Cocoa Powder,\n\nFlour,\n\nSugar,\n\nEggs,\n\nButter,\n\nHeavy Cream,\n\nDark Chocolate,\n\nChocolate Mousse', 'Dairy (Milk, Butter, Cream),\n\nEggs,\n\nGluten (Flour)', '(Calories: 350 kcal)\n\n(Carbohydrates: 40g)\n\n(Sugar: 28g)\n\n(Fat: 16g)\n\n(Protein: 5g)'),
(37, 38, 'Flour,Sugar,Eggs,Milk,\n\nButter,\n\nYeast,\n\nVanilla Extract,\n\nPink Frosting,\n\nRainbow Sprinkles', 'Dairy (Milk, Butter),\n\nEggs,\n\nGluten (Flour)', '(Calories: 250 kcal)\n\n(Carbohydrates: 35g)\n\n(Sugar: 20g)\n\n(Fat: 10g)\n\n(Protein: 3g)'),
(38, 39, 'Flour,\n\nSugar,\n\nEggs,\n\nMilk,\n\nButter,\n\nYeast,\n\nVanilla Extract,\n\nWhite Chocolate Glaze,\n\nRainbow Confetti Sprinkles,\n\nVanilla Cream Filling', 'Dairy (Milk, Butter),\n\nEggs,\n\nGluten (Flour)', '(Calories: 280 kcal)\n\n(Carbohydrates: 38g)\n\n(Sugar: 22g)\n\n(Fat: 12g)\n\n(Protein: 4g)'),
(39, 40, 'Flour,\n\nSugar,\n\nEggs,\n\nMilk,\n\nButter,\n\nYeast,\n\nChocolate Glaze,\n\nRainbow Sprinkles', 'Dairy (Milk, Butter),\n\nEggs,\n\nGluten (Flour)', '(Calories: 290 kcal)\n\n(Carbohydrates: 40g)\n\n(Sugar: 24g)\n\n(Fat: 13g)\n\n(Protein: 4g)'),
(40, 41, 'Espresso-soaked ladyfingers,\n\nMascarpone cheese,\n\nWhipped cream,\n\nSugar,\n\nCocoa powder,\n\nCoffee beans,\n\nVanilla extract', 'Dairy (Mascarpone, Whipped Cream),\n\nGluten (Ladyfingers),\n\nCaffeine (Espresso, Coffee Beans)', '(Calories: 350 kcal)\n\n(Carbohydrates: 40g)\n\n(Sugar: 22g)\n\n(Fat: 20g)\n\n(Protein: 6g)'),
(68, 115, 'Carbonated water,\n\nsugar,\n\ncaramel color,\n\nphosphoric acid,\n\nnatural flavors,\n\ncaffeine', 'None', '(Calories: 42 kcal)\n\n(Carbohydrates: 10.6g)\n\n(Sugar: 10.6g)\n\n(Fat: 0g)\n\n(Protein: 0g)'),
(69, 116, 'Carbonated water,\n\nsugar,\n\norange juice from concentrate,\n\ncitric acid,\n\nnatural orange flavoring,\n\npreservatives, color (sunset yellow),\n\nstabilizers', 'None', '(Calories: 42 kcal)\n\n(Carbohydrates: 10.4g)\n\n(Sugar: 10.4g)\n\n(Fat: 0g)\n\n(Protein: 0g)'),
(70, 117, 'Wheat flour,\n\nsugar,\n\neggs,\n\ncocoa powder,,\n\nmilk,\n\nchocolate,\n\nbutter,\n\nvegetable oil,\n\nbaking powder,\n\nvanilla extract', 'Contains wheat,\n\neggs,\n\nmilk,\n\nsoy', '(Calories: 350 kcal)\n\n(Carbohydrates: 45g)\n\n(Sugar: 30g)\n\n(Fat: 18g)\n\n(Protein: 4g)');

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) NOT NULL,
  `promotion_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `name`, `description`, `price`, `image`, `promotion_id`, `category_id`) VALUES
(5, 'Classic Chocolate Cake', 'A rich, moist chocolate cake with creamy chocolate frosting—perfect for any occasion!\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n', 60.00, 'image/c5.png', 3, 1),
(31, 'Chocolate Strawberry Layer Cake', 'A rich chocolate sponge cake layered with creamy chocolate frosting and fresh strawberries, topped with a smooth chocolate swirl and juicy berries. Perfect for any occasion!', 60.00, 'image/c7.png', NULL, 1),
(32, 'Chocolate Orange Mousse Cake', 'A luscious chocolate and orange mousse cake with a crunchy base, creamy layers, and a glossy chocolate glaze, topped with elegant chocolate decorations and fresh orange slices.', 60.00, 'image/c4.png', NULL, 1),
(33, 'Berry Vanilla Naked Cake', 'A light and airy vanilla sponge cake layered with smooth whipped cream and topped with fresh, vibrant berries for a naturally sweet and elegant treat. ', 65.00, 'image/c1.png', NULL, 1),
(35, 'Classic Chocolate Fudge Cake', 'A rich and moist chocolate fudge cake layered with silky ganache, topped with dark chocolate curls for an indulgent, melt-in-your-mouth experience.', 12.00, 'image/c2.png', NULL, 3),
(36, 'Classic Vanilla Cream Cake', 'A light and fluffy vanilla sponge cake layered with fresh whipped cream, topped with a swirl of cream and a sweet cherry for a classic, delightful treat. ', 13.00, 'image/c3.png', NULL, 3),
(37, 'Dark Chocolate Mousse Cake', 'A rich and decadent dark chocolate mousse cake with layers of moist chocolate sponge, creamy mousse filling, and a glossy chocolate glaze for the ultimate chocolate indulgence. ', 14.00, 'image/c6.png', NULL, 3),
(38, 'Classic Pink Frosted Donut', 'A soft, fluffy donut coated with a sweet pink glaze and topped with colorful sprinkles, delivering a delightful crunch with every bite. Perfect for satisfying your sweet tooth! ', 7.00, 'image/donut1.png', NULL, 4),
(39, 'Vanilla Cream-Filled Donut', 'A soft, golden donut filled with rich vanilla cream, coated in smooth white chocolate glaze, and topped with fun rainbow sprinkles. A deliciously creamy treat in every bite! ', 7.00, 'image/donut2.png', NULL, 4),
(40, 'Chocolate Sprinkle Donut', 'A fluffy, golden donut coated in a rich chocolate glaze and topped with colorful sprinkles. A classic treat for chocolate lovers! ', 7.00, 'image/donut3.png', NULL, 4),
(41, 'Classic Tiramisu', 'A luscious Italian dessert featuring layers of espresso-infused ladyfingers and creamy mascarpone, dusted with cocoa powder and topped with delicate whipped cream swirls and coffee beans. Perfect for coffee lovers! ', 30.00, 'image/tiramisu1.png', NULL, 2),
(115, 'Coca-Cola Original Taste (330ml)', 'Classic and refreshing carbonated soft drink with a signature taste enjoyed worldwide.', 5.00, 'image/coke.png', NULL, 5),
(116, 'Fanta Orange (330ml)', 'Fizzy orange-flavored soft drink with a bold, fruity taste and vibrant color.', 4.50, 'image/fantaorange.png', NULL, 5),
(117, 'Obsidian Chocolate Slice', 'A rich and velvety chocolate cake layered with smooth cream and coated in a glossy dark chocolate ganache — indulgence in every bite.', 15.50, 'image/chocolateslidecake00.png', NULL, 3);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_date` datetime NOT NULL DEFAULT current_timestamp(),
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('Pending','Processing','Completed','Cancelled') NOT NULL DEFAULT 'Pending',
  `payment_method` enum('Credit Card','DuitNow','Cash on Delivery') NOT NULL,
  `payment_status` enum('Pending','Completed','Failed') NOT NULL DEFAULT 'Pending',
  `customer_name` varchar(255) NOT NULL,
  `customer_email` varchar(255) NOT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `customer_notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `order_date`, `total_amount`, `status`, `payment_method`, `payment_status`, `customer_name`, `customer_email`, `customer_phone`, `customer_notes`) VALUES
(295, 17, '2025-04-19 20:58:10', 25.00, 'Completed', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(296, 17, '2025-04-19 20:58:38', 42.00, 'Completed', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(297, 17, '2025-04-19 20:58:54', 25.00, 'Processing', 'Credit Card', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(298, 17, '2025-04-19 21:15:56', 15.00, 'Processing', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(299, 18, '2025-04-19 22:26:49', 106.00, 'Completed', 'DuitNow', 'Completed', 'woon long', 'chuahwoonlong8879829@gmail.com', '+60167901465', ''),
(300, 17, '2025-04-19 23:06:30', 120.00, 'Processing', 'Cash on Delivery', 'Completed', 'khaiyu', 'khaiyu0000@gmail.com', '+601151676353', 'can you give me more berry'),
(301, 17, '2025-04-20 01:44:57', 45.00, 'Processing', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(302, 17, '2025-04-20 22:46:44', 17.00, 'Cancelled', 'DuitNow', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(303, 19, '2025-04-21 15:42:21', 134.00, 'Processing', 'Credit Card', 'Completed', 'Tan Khai Yu', 'khaiyu02@gmail.com', '+601127687558', ''),
(304, 19, '2025-04-21 15:46:10', 60.00, 'Pending', 'Credit Card', 'Pending', 'Tan Khai Yu', 'khaiyu02@gmail.com', '+601127687558', ''),
(305, 17, '2025-04-21 21:40:03', 19.00, 'Processing', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(306, 17, '2025-04-27 19:14:55', 281.50, 'Processing', 'Credit Card', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(307, 17, '2025-04-27 19:25:47', 131.50, 'Cancelled', 'DuitNow', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(308, 17, '2025-04-27 19:37:00', 12.00, 'Cancelled', 'DuitNow', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(309, 17, '2025-04-27 19:46:47', 180.00, 'Processing', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(310, 17, '2025-04-27 21:43:01', 60.00, 'Processing', 'DuitNow', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(311, 17, '2025-04-27 21:54:49', 35.00, 'Processing', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(312, 17, '2025-04-29 20:57:42', 333.00, 'Processing', 'Credit Card', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(313, 18, '2025-04-29 21:00:59', 120.00, 'Processing', 'Cash on Delivery', 'Completed', 'taki woon', 'chuahwoonlong8879829@gmail.com', '+60167901465', ''),
(314, 18, '2025-04-29 21:02:19', 90.00, 'Pending', 'Credit Card', 'Pending', 'taki woon', 'chuahwoonlong8879829@gmail.com', '167901465', ''),
(315, 18, '2025-04-29 21:03:09', 257.00, 'Pending', 'Credit Card', 'Pending', 'taki woon', 'chuahwoonlong8879829@gmail.com', '167901465', '');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `after_order_completed` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN
  IF NEW.payment_status = 'Completed' AND OLD.payment_status != 'Completed' THEN
    SET @stamps = FLOOR(NEW.total_amount / 100);
    
    -- 只有获得印章时才继续处理
    IF @stamps > 0 THEN
      -- 获取用户当前活跃的积点卡
      SET @current_card_id = (
        SELECT card_id FROM stamp_cards 
        WHERE user_id = NEW.user_id AND is_active = 1
        LIMIT 1
      );

      -- 如果没有活跃卡，创建一张新卡
      IF @current_card_id IS NULL THEN
        INSERT INTO stamp_cards (user_id, stamps_earned) VALUES (NEW.user_id, 0);
        SET @current_card_id = LAST_INSERT_ID();
      END IF;

      -- 更新当前活跃卡的印章数量
      UPDATE stamp_cards 
      SET stamps_earned = stamps_earned + @stamps 
      WHERE card_id = @current_card_id;

      -- 记录印章获取历史
      INSERT INTO stamp_redemptions (user_id, card_id, discount_amount)
      VALUES (NEW.user_id, @current_card_id, 0.00);
    END IF;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`item_id`, `order_id`, `product_id`, `product_name`, `quantity`, `price`) VALUES
(282, 295, 33, 'Berry Vanilla Naked Cake', 1, 20.00),
(283, 296, 41, 'Classic Tiramisu', 1, 30.00),
(284, 296, 39, 'Vanilla Cream-Filled Donut', 1, 7.00),
(285, 297, 32, 'Chocolate Orange Mousse Cake', 1, 20.00),
(286, 298, 31, 'Chocolate Strawberry Layer Cake', 1, 10.00),
(287, 299, 32, 'Chocolate Orange Mousse Cake', 1, 20.00),
(288, 299, 33, 'Berry Vanilla Naked Cake', 2, 20.00),
(289, 299, 31, 'Chocolate Strawberry Layer Cake', 1, 10.00),
(290, 299, 35, 'Classic Chocolate Fudge Cake', 3, 12.00),
(291, 300, 33, 'Berry Vanilla Naked Cake', 6, 20.00),
(292, 301, 33, 'Berry Vanilla Naked Cake', 2, 20.00),
(293, 302, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(294, 302, 115, 'Coca-Cola Original Taste (330ml)', 1, 5.00),
(295, 303, 40, 'Chocolate Sprinkle Donut', 2, 7.00),
(296, 303, 32, 'Chocolate Orange Mousse Cake', 2, 60.00),
(297, 304, 32, 'Chocolate Orange Mousse Cake', 1, 60.00),
(298, 305, 38, 'Classic Pink Frosted Donut', 2, 7.00),
(299, 306, 41, 'Classic Tiramisu', 1, 30.00),
(300, 306, 116, 'Fanta Orange (330ml)', 1, 4.50),
(301, 306, 32, 'Chocolate Orange Mousse Cake', 4, 60.00),
(302, 306, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(303, 307, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(304, 307, 116, 'Fanta Orange (330ml)', 1, 4.50),
(305, 307, 5, 'Classic Chocolate Cake', 2, 30.00),
(306, 307, 31, 'Chocolate Strawberry Layer Cake', 1, 60.00),
(307, 308, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(308, 309, 32, 'Chocolate Orange Mousse Cake', 1, 60.00),
(309, 309, 31, 'Chocolate Strawberry Layer Cake', 2, 60.00),
(310, 310, 31, 'Chocolate Strawberry Layer Cake', 1, 60.00),
(311, 311, 41, 'Classic Tiramisu', 1, 30.00),
(312, 312, 40, 'Chocolate Sprinkle Donut', 4, 7.00),
(313, 312, 31, 'Chocolate Strawberry Layer Cake', 2, 60.00),
(314, 312, 115, 'Coca-Cola Original Taste (330ml)', 1, 5.00),
(315, 312, 5, 'Classic Chocolate Cake', 3, 60.00),
(316, 313, 32, 'Chocolate Orange Mousse Cake', 2, 60.00),
(317, 314, 41, 'Classic Tiramisu', 1, 30.00),
(318, 314, 32, 'Chocolate Orange Mousse Cake', 1, 60.00),
(319, 315, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(320, 315, 31, 'Chocolate Strawberry Layer Cake', 5, 60.00);

-- --------------------------------------------------------

--
-- Table structure for table `promotions`
--

CREATE TABLE `promotions` (
  `promotion_id` int(11) NOT NULL,
  `menu_name` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `promotions`
--

INSERT INTO `promotions` (`promotion_id`, `menu_name`, `status`, `price`, `start_date`, `end_date`) VALUES
(3, 'Classic Chocolate Cake', 'Yes', 30.00, '2025-04-21', '2025-04-28');

-- --------------------------------------------------------

--
-- Table structure for table `stamp_cards`
--

CREATE TABLE `stamp_cards` (
  `card_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `stamps_earned` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stamp_cards`
--

INSERT INTO `stamp_cards` (`card_id`, `user_id`, `stamps_earned`, `is_active`, `created_at`, `updated_at`) VALUES
(11, 17, 3, 1, '2025-04-29 12:58:44', '2025-04-29 12:58:44'),
(12, 18, 10, 1, '2025-04-29 13:01:01', '2025-04-29 13:03:09');

-- --------------------------------------------------------

--
-- Table structure for table `stamp_redemptions`
--

CREATE TABLE `stamp_redemptions` (
  `redemption_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `redemption_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `discount_amount` decimal(10,2) NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT 0,
  `used_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stamp_redemptions`
--

INSERT INTO `stamp_redemptions` (`redemption_id`, `user_id`, `card_id`, `redemption_date`, `discount_amount`, `is_used`, `used_date`) VALUES
(39, 17, 11, '2025-04-29 12:58:44', 0.00, 0, NULL),
(40, 18, 12, '2025-04-29 13:01:01', 0.00, 0, NULL),
(41, 18, 12, '2025-04-29 13:03:09', 50.00, 1, '2025-04-29 13:03:09');

-- --------------------------------------------------------

--
-- Table structure for table `stock`
--

CREATE TABLE `stock` (
  `id` int(11) NOT NULL,
  `menu_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock`
--

INSERT INTO `stock` (`id`, `menu_id`, `quantity`, `last_updated`) VALUES
(5, 5, 5, '2025-04-29 12:58:44'),
(33, 31, 79, '2025-04-29 12:58:44'),
(34, 32, 91, '2025-04-29 13:01:01'),
(35, 33, 20, '2025-04-29 13:04:15'),
(37, 35, 12, '2025-04-19 17:38:38'),
(38, 36, 9, '2025-04-14 15:47:02'),
(39, 37, 9, '2025-04-18 11:54:44'),
(40, 38, 12, '2025-04-21 13:40:04'),
(41, 39, 8, '2025-04-19 12:58:42'),
(42, 40, 5, '2025-04-29 12:58:44'),
(43, 41, 61, '2025-04-27 13:54:52'),
(71, 115, 99, '2025-04-29 12:58:44'),
(72, 116, 99, '2025-04-27 11:24:28'),
(73, 117, 100, '2025-04-20 13:05:23');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `phonenumber` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `join_date` datetime DEFAULT current_timestamp(),
  `reset_token_hash` varchar(64) DEFAULT NULL,
  `reset_token_expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `phonenumber`, `email`, `password`, `address`, `first_name`, `last_name`, `join_date`, `reset_token_hash`, `reset_token_expires_at`) VALUES
(17, 'woonlong', '1151676353', 'chuahwoonlong1465@gmail.com', '$2y$10$UZ8iNpX8U1QAcGyQL62ma.lsp7ollL2XNUY8HdO8PW7khgN.zbrtW', '84, jalan pinang 17', 'chuah', 'woonlong', '2025-04-13 17:31:23', '16156cd907cde60dfbcfeaa27204de106b01eb4fa06b67099c1d082bba117b30', '2025-04-19 20:15:30'),
(18, 'woon', '167901465', 'chuahwoonlong8879829@gmail.com', '$2y$10$CzASf0bNbvCOqwgCABI2bOcSZW/OmfE0/e8nNOMnkQ/IwL6opCEfa', '84, jalan pinang 17', 'taki', 'woon', '2025-04-13 21:16:47', NULL, NULL),
(19, 'khaiyu', '1127687558', 'khaiyu02@gmail.com', '$2y$10$qzQDkYHU6lH/8oq/3lpcG.o0l7MRQJ4oB4J3gFHYpgLEkocFc1tfW', '11,jalan putra 2/16,taman jp setia', 'Tan', 'Khai Yu', '2025-04-21 15:13:29', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `idx_cart_user` (`user_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `category_name` (`category_name`);

--
-- Indexes for table `delivery`
--
ALTER TABLE `delivery`
  ADD PRIMARY KEY (`delivery_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `dessert_info`
--
ALTER TABLE `dessert_info`
  ADD PRIMARY KEY (`id`),
  ADD KEY `menu_id` (`menu_id`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_promotion` (`promotion_id`),
  ADD KEY `fk_menu_category` (`category_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `idx_orders_user` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `promotions`
--
ALTER TABLE `promotions`
  ADD PRIMARY KEY (`promotion_id`);

--
-- Indexes for table `stamp_cards`
--
ALTER TABLE `stamp_cards`
  ADD PRIMARY KEY (`card_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `stamp_redemptions`
--
ALTER TABLE `stamp_redemptions`
  ADD PRIMARY KEY (`redemption_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `card_id` (`card_id`);

--
-- Indexes for table `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`id`),
  ADD KEY `menu_id` (`menu_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `reset_token_hash` (`reset_token_hash`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=407;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `delivery`
--
ALTER TABLE `delivery`
  MODIFY `delivery_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=294;

--
-- AUTO_INCREMENT for table `dessert_info`
--
ALTER TABLE `dessert_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=316;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=321;

--
-- AUTO_INCREMENT for table `promotions`
--
ALTER TABLE `promotions`
  MODIFY `promotion_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `stamp_cards`
--
ALTER TABLE `stamp_cards`
  MODIFY `card_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `stamp_redemptions`
--
ALTER TABLE `stamp_redemptions`
  MODIFY `redemption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `stock`
--
ALTER TABLE `stock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `menu` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `delivery`
--
ALTER TABLE `delivery`
  ADD CONSTRAINT `delivery_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE;

--
-- Constraints for table `dessert_info`
--
ALTER TABLE `dessert_info`
  ADD CONSTRAINT `dessert_info_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `dessert_info_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`);

--
-- Constraints for table `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `fk_menu_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`),
  ADD CONSTRAINT `fk_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`promotion_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE;

--
-- Constraints for table `stamp_cards`
--
ALTER TABLE `stamp_cards`
  ADD CONSTRAINT `stamp_cards_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stamp_redemptions`
--
ALTER TABLE `stamp_redemptions`
  ADD CONSTRAINT `stamp_redemptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stamp_redemptions_ibfk_2` FOREIGN KEY (`card_id`) REFERENCES `stamp_cards` (`card_id`) ON DELETE CASCADE;

--
-- Constraints for table `stock`
--
ALTER TABLE `stock`
  ADD CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stock_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
