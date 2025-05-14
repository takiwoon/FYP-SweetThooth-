-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 14, 2025 at 03:39 AM
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
    
    -- Calculate stamps to add (1 stamp per RM100)
    SET v_stamps_to_add = FLOOR(p_order_amount / 100);
    
    IF v_stamps_to_add > 0 THEN
        -- Find user's active stamp card
        SELECT card_id, stamps_earned INTO v_active_card_id, v_current_stamps
        FROM stamp_cards 
        WHERE user_id = p_user_id AND is_active = 1
        LIMIT 1;
        
        -- If no active card, create a new one
        IF v_active_card_id IS NULL THEN
            INSERT INTO stamp_cards (user_id, stamps_earned) VALUES (p_user_id, 0);
            SET v_active_card_id = LAST_INSERT_ID();
            SET v_current_stamps = 0;
        END IF;
        
        -- Update stamp count (不再自动兑换)
        UPDATE stamp_cards 
        SET stamps_earned = v_current_stamps + v_stamps_to_add
        WHERE card_id = v_active_card_id;
        
        -- Record stamp earning
        INSERT INTO stamp_redemptions (user_id, card_id, stamps_earned, is_used)
        VALUES (p_user_id, v_active_card_id, v_stamps_to_add, 0);
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
(496, 20, 5, 1, '2025-05-07 17:20:33'),
(538, 21, 40, 1, '2025-05-13 13:35:07'),
(540, 21, 32, 1, '2025-05-13 13:41:19');

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
-- Table structure for table `contact_submissions`
--

CREATE TABLE `contact_submissions` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `submitted_at` datetime NOT NULL,
  `status` enum('unread','read','replied') DEFAULT 'unread'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_submissions`
--

INSERT INTO `contact_submissions` (`id`, `name`, `email`, `message`, `submitted_at`, `status`) VALUES
(2, 'Khai Yu Tan', 'khaiyu02@gmail.com', 'hi', '2025-05-11 17:29:13', 'unread'),
(3, 'Khai Yu Tan', 'khaiyu02@gmail.com', 'hi', '2025-05-11 17:34:48', 'unread'),
(4, 'Tan Khai Yu', 'khaiyu02@gmail.com', 'hi', '2025-05-11 18:03:35', 'unread'),
(5, 'Tan Khai Yu', 'khaiyu02@gmail.com', 'hi', '2025-05-11 18:08:10', 'unread'),
(6, 'Khai Yu Tan', 'khaiyu02@gmail.com', 'hello', '2025-05-11 19:23:59', 'unread'),
(7, 'Khai Yu Tan', 'khaiyu02@gmail.com', 'hello', '2025-05-11 19:27:50', 'unread'),
(8, 'Khai Yu Tan', 'khaiyu02@gmail.com', 'hello', '2025-05-11 19:32:59', 'unread'),
(9, 'Khai Yu Tan', 'khaiyu02@gmail.com', 'hello', '2025-05-11 19:43:45', 'unread'),
(10, 'Khai Yu Tan', 'khaiyu@gmail.com', 'hello', '2025-05-11 19:47:39', 'unread'),
(11, 'Tan Khai Yu', 'khaiyu02@gmail.com', 'hi', '2025-05-11 19:58:13', 'unread'),
(12, 'Chuah', 'chuahwoonlong1465@gmail.com', 'hi，sb woonlong', '2025-05-11 20:00:56', 'unread'),
(13, 'Khai Yu Tan', 'khaiyu02@gmail.com', 'afafa', '2025-05-11 20:07:14', 'unread'),
(14, 'Khai Yu Tan', 'khaiyu02@gmail.com', 'fr', '2025-05-11 20:22:44', 'unread'),
(0, 'khaiyu', 'tankhaiyu@gmail.com', 'i am stupid', '2025-05-12 10:44:14', 'unread'),
(0, 'khaiyu', 'khaiyu02@gmail.com', 'i am stupid', '2025-05-12 10:46:44', 'unread'),
(0, 'chuah', 'chuahwoonlong1465@gmail.com', 'demo', '2025-05-12 10:47:13', 'unread'),
(0, 'khaiyu', 'khaiyu02@gmail.com', 'i am gay', '2025-05-12 11:00:47', 'unread'),
(0, 'Name', 'Email@gmail.com', 'Message', '2025-05-13 17:00:53', 'unread');

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
(347, 369, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', '', NULL, NULL),
(348, 370, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', '', NULL, NULL),
(349, 371, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', '', NULL, NULL),
(350, 372, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', 'Preparing', NULL, NULL),
(351, 373, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', '', NULL, NULL),
(352, 374, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', 'Preparing', NULL, NULL),
(353, 375, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', 'Preparing', NULL, NULL),
(354, 376, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', '', NULL, NULL),
(355, 377, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', '', NULL, NULL),
(356, 378, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', '', NULL, NULL),
(357, 379, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', '', NULL, NULL),
(358, 380, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', 'Preparing', NULL, NULL),
(359, 381, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', 'Preparing', NULL, NULL),
(360, 382, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', 'Preparing', NULL, NULL),
(361, 383, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', 'Preparing', NULL, NULL),
(362, 384, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', 'Pending', NULL, NULL),
(363, 385, 'C0208, Jalan D1, Ayer Keroh, 75400', NULL, NULL, '', 'Preparing', NULL, NULL);

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
(5, 5, 'Flour,\n\nSugar,\n\nCocoa Powder,\n\nBaking Powder,\n\nBaking Soda,\n\nEggs,\n\nMilk,\n\nButter,\n\nVanilla Extract,\n\nChocolate Ganache or Frosting', 'Eggs,\n\nDairy (Milk, Butter),\n\nGluten (Flour)', '(Calories: 350 kcal)\n\n(Carbohydrates: 45g)\n\n(Sugar: 30g)\n\n(Fat: 18g)\n\n(Protein: 5g)'),
(30, 31, 'Flour,\n\nCocoa Powder,\n\nSugar,\n\nBaking Powder & Baking Soda,\n\nEggs,\n\nMilk,\n\nButter,\n\nVanilla Extract,\n\nChocolate Ganache or Frosting,\n\nFresh Strawberries', 'Eggs,\n\nDairy (Milk, Butter),\n\nGluten (Flour)', '(Calories: 320 kcal)\n\n(Carbohydrates: 40g)\n\n(Sugar: 28g)\n\n(Fat: 15g)\n\n(Protein: 4g)'),
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
(5, 'Classic Chocolate Cake', 'A rich, moist chocolate cake with creamy chocolate frosting—perfect for any occasion!\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n', 60.00, 'image/c5.png', 6, 1),
(31, 'Chocolate Strawberry Layer Cake', 'A rich chocolate sponge cake layered with creamy chocolate frosting and fresh strawberries, topped with a smooth chocolate swirl and juicy berries. Perfect for any occasion!', 60.00, 'image/c7.png', NULL, 1),
(32, 'Chocolate Orange Mousse Cake', 'A luscious chocolate and orange mousse cake with a crunchy base, creamy layers, and a glossy chocolate glaze, topped with elegant chocolate decorations and fresh orange slices.', 60.00, 'image/c4.png', NULL, 1),
(33, 'Berry Vanilla Naked Cake', 'A light and airy vanilla sponge cake layered with smooth whipped cream and topped with fresh, vibrant berries for a naturally sweet and elegant treat. ', 65.00, 'image/c1.png', NULL, 1),
(35, 'Classic Chocolate Fudge Cake', 'A rich and moist chocolate fudge cake layered with silky ganache, topped with dark chocolate curls for an indulgent, melt-in-your-mouth experience.', 12.00, 'image/c2.png', NULL, 3),
(36, 'Classic Vanilla Cream Cake', 'A light and fluffy vanilla sponge cake layered with fresh whipped cream, topped with a swirl of cream and a sweet cherry for a classic, delightful treat. ', 13.00, 'image/c3.png', NULL, 3),
(37, 'Dark Chocolate Mousse Cake', 'A rich and decadent dark chocolate mousse cake with layers of moist chocolate sponge, creamy mousse filling, and a glossy chocolate glaze for the ultimate chocolate indulgence. ', 14.00, 'image/c6.png', NULL, 3),
(38, 'Classic Pink Frosted Donut', 'A soft, fluffy donut coated with a sweet pink glaze and topped with colorful sprinkles, delivering a delightful crunch with every bite. Perfect for satisfying your sweet tooth! ', 7.00, 'image/donut1.png', 8, 4),
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
(369, 17, '2025-05-13 21:29:11', 420.00, 'Cancelled', 'Credit Card', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(370, 17, '2025-05-13 21:29:30', 5.00, 'Cancelled', 'Credit Card', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(371, 17, '2025-05-13 21:35:27', 5.00, 'Cancelled', 'Credit Card', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(372, 17, '2025-05-13 21:41:48', 60.00, 'Processing', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(373, 17, '2025-05-13 21:55:04', 10.00, 'Cancelled', 'Credit Card', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(374, 17, '2025-05-13 22:07:42', 60.00, 'Processing', 'Credit Card', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(375, 17, '2025-05-13 22:10:31', 60.00, 'Processing', 'Credit Card', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(376, 17, '2025-05-13 22:17:38', 12.00, 'Cancelled', 'Credit Card', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(377, 17, '2025-05-13 22:18:40', 12.00, 'Cancelled', 'Credit Card', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '1151676353', ''),
(378, 17, '2025-05-13 22:20:55', 250.00, 'Cancelled', 'DuitNow', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(379, 17, '2025-05-13 22:21:16', 5.00, 'Cancelled', 'Cash on Delivery', 'Failed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(380, 17, '2025-05-13 22:38:37', 12.00, 'Processing', 'Credit Card', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(381, 17, '2025-05-13 22:46:05', 102.00, 'Processing', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(382, 17, '2025-05-13 22:55:21', 26.00, 'Processing', 'Credit Card', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(383, 17, '2025-05-13 22:56:16', 5.00, 'Processing', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(384, 17, '2025-05-14 08:17:33', 145.00, 'Pending', 'Cash on Delivery', 'Pending', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', ''),
(385, 17, '2025-05-14 08:18:40', 490.00, 'Processing', 'Cash on Delivery', 'Completed', 'chuah woonlong', 'chuahwoonlong1465@gmail.com', '+601151676353', '');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `after_order_payment_completed` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN
  -- Only process when payment status changes to Completed
  IF NEW.payment_status = 'Completed' AND OLD.payment_status != 'Completed' THEN
    -- Call the stored procedure to handle stamp earnings
    CALL process_stamp_earnings(NEW.user_id, NEW.total_amount);
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
(402, 369, 31, 'Chocolate Strawberry Layer Cake', 6, 60.00),
(403, 369, 35, 'Classic Chocolate Fudge Cake', 5, 12.00),
(404, 370, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(405, 371, 38, 'Classic Pink Frosted Donut', 1, 32.00),
(406, 372, 32, 'Chocolate Orange Mousse Cake', 1, 60.00),
(407, 373, 31, 'Chocolate Strawberry Layer Cake', 1, 60.00),
(408, 374, 32, 'Chocolate Orange Mousse Cake', 1, 60.00),
(409, 375, 32, 'Chocolate Orange Mousse Cake', 1, 60.00),
(410, 376, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(411, 377, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(412, 378, 41, 'Classic Tiramisu', 10, 30.00),
(413, 379, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(414, 380, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(415, 381, 31, 'Chocolate Strawberry Layer Cake', 1, 60.00),
(416, 381, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(417, 381, 41, 'Classic Tiramisu', 1, 30.00),
(418, 381, 115, 'Coca-Cola Original Taste (330ml)', 1, 5.00),
(419, 382, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(420, 382, 39, 'Vanilla Cream-Filled Donut', 2, 7.00),
(421, 383, 38, 'Classic Pink Frosted Donut', 1, 32.00),
(422, 383, 40, 'Chocolate Sprinkle Donut', 1, 7.00),
(423, 384, 33, 'Berry Vanilla Naked Cake', 3, 65.00),
(424, 385, 31, 'Chocolate Strawberry Layer Cake', 9, 60.00);

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
(3, 'Classic Chocolate Cake', 'No', 30.00, '2025-04-21', '2025-04-28'),
(4, 'Classic Chocolate Cake', 'Yes', 30.00, '2025-05-01', '2025-05-23'),
(5, 'Classic Pink Frosted Donut', 'No', 6.30, '2025-05-01', '2025-05-08'),
(6, 'Classic Chocolate Cake', 'Yes', 30.00, '2025-05-07', '2025-05-14'),
(7, 'Chocolate Orange Mousse Cake', 'No', 42.00, '2025-05-07', '2025-05-07'),
(8, 'Classic Pink Frosted Donut', 'Yes', 32.00, '2025-05-07', '2025-05-14');

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
(19, 17, 24, 1, '2025-05-01 10:42:18', '2025-05-14 00:18:42'),
(20, 18, 48, 1, '2025-05-06 03:28:47', '2025-05-06 16:23:54');

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
  `stamps_earned` int(11) NOT NULL DEFAULT 0,
  `stamps_redeemed` int(11) NOT NULL DEFAULT 0,
  `is_used` tinyint(1) NOT NULL DEFAULT 0,
  `used_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stamp_redemptions`
--

INSERT INTO `stamp_redemptions` (`redemption_id`, `user_id`, `card_id`, `redemption_date`, `discount_amount`, `stamps_earned`, `stamps_redeemed`, `is_used`, `used_date`) VALUES
(60, 17, 19, '2025-05-01 10:42:18', 0.00, 4, 0, 0, NULL),
(61, 17, 19, '2025-05-01 10:42:39', 0.00, 4, 0, 0, NULL),
(62, 17, 19, '2025-05-01 10:42:58', 0.00, 6, 0, 0, NULL),
(63, 17, 19, '2025-05-01 10:43:20', 0.00, 6, 0, 0, NULL),
(64, 17, 19, '2025-05-01 10:43:55', 50.00, 0, 10, 2, '2025-05-01 10:43:55'),
(65, 17, 19, '2025-05-01 10:44:11', 0.00, 1, 0, 0, NULL),
(66, 17, 19, '2025-05-01 10:44:38', 50.00, 0, 10, 1, '2025-05-01 10:44:38'),
(67, 17, 19, '2025-05-01 10:44:39', 0.00, 1, 0, 0, NULL),
(68, 17, 19, '2025-05-01 11:19:10', 50.00, 0, 10, 1, '2025-05-01 11:19:10'),
(69, 17, 19, '2025-05-01 11:19:43', 30.00, 0, 10, 2, '2025-05-01 11:19:43'),
(70, 17, 19, '2025-05-01 11:39:34', 50.00, 0, 10, 2, '2025-05-01 11:39:34'),
(71, 18, 20, '2025-05-06 03:28:47', 0.00, 28, 0, 0, NULL),
(72, 17, 19, '2025-05-06 03:29:11', 0.00, 28, 0, 0, NULL),
(73, 18, 20, '2025-05-06 13:33:29', 0.00, 22, 0, 0, NULL),
(74, 18, 20, '2025-05-06 14:16:37', 50.00, 0, 10, 1, '2025-05-06 14:16:37'),
(75, 18, 20, '2025-05-06 14:16:38', 0.00, 14, 0, 0, NULL),
(76, 18, 20, '2025-05-06 14:31:21', 50.00, 0, 10, 1, '2025-05-06 14:31:21'),
(77, 18, 20, '2025-05-06 16:23:54', 0.00, 4, 0, 0, NULL),
(78, 17, 19, '2025-05-07 16:03:32', 5.00, 0, 10, 2, '2025-05-07 16:03:32'),
(79, 17, 19, '2025-05-13 13:29:30', 7.00, 0, 10, 2, '2025-05-13 13:29:30'),
(80, 17, 19, '2025-05-13 13:35:27', 32.00, 0, 10, 2, '2025-05-13 13:35:27'),
(81, 17, 19, '2025-05-13 13:55:04', 50.00, 0, 10, 2, '2025-05-13 13:55:04'),
(82, 17, 19, '2025-05-13 14:20:55', 50.00, 0, 10, 2, '2025-05-13 14:20:55'),
(83, 17, 19, '2025-05-13 14:21:16', 7.00, 0, 10, 2, '2025-05-13 14:21:16'),
(84, 17, 19, '2025-05-13 14:46:08', 0.00, 1, 0, 0, NULL),
(85, 17, 19, '2025-05-13 14:56:16', 39.00, 0, 10, 1, '2025-05-13 14:56:16'),
(86, 17, 19, '2025-05-14 00:17:33', 50.00, 0, 10, 1, '2025-05-14 00:17:33'),
(87, 17, 19, '2025-05-14 00:18:40', 50.00, 0, 10, 1, '2025-05-14 00:18:40'),
(88, 17, 19, '2025-05-14 00:18:42', 0.00, 4, 0, 0, NULL);

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
(5, 5, 0, '2025-05-13 12:49:19'),
(33, 31, 0, '2025-05-14 00:18:42'),
(34, 32, 7, '2025-05-13 14:17:24'),
(35, 33, 10, '2025-05-13 12:14:02'),
(37, 35, 10, '2025-05-13 12:14:04'),
(38, 36, 10, '2025-05-13 12:14:06'),
(39, 37, 10, '2025-05-13 12:14:10'),
(40, 38, 9, '2025-05-13 14:56:22'),
(41, 39, 8, '2025-05-13 14:55:29'),
(42, 40, 6, '2025-05-13 14:56:22'),
(43, 41, 9, '2025-05-13 14:46:08'),
(71, 115, 9, '2025-05-13 14:46:08'),
(72, 116, 10, '2025-05-13 12:14:20'),
(73, 117, 10, '2025-05-13 12:14:21');

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
(17, 'woonlong', '1151676353', 'chuahwoonlong1465@gmail.com', '$2y$10$UZ8iNpX8U1QAcGyQL62ma.lsp7ollL2XNUY8HdO8PW7khgN.zbrtW', 'C0208, Jalan D1, Ayer Keroh, 75400', 'chuah', 'woonlong', '2025-04-13 17:31:23', '1e3456645f12978e207f45ba6b5cffa0621acebb28bcb29a9d247b3dab21cef5', '2025-05-07 19:54:46'),
(18, 'woon', '167901465', 'chuahwoonlong8879829@gmail.com', '$2y$10$CzASf0bNbvCOqwgCABI2bOcSZW/OmfE0/e8nNOMnkQ/IwL6opCEfa', '84, jalan pinang 17', 'taki', 'woon', '2025-04-13 21:16:47', NULL, NULL),
(20, 'KY', '', 'khaiyu02@gmail.com', '$2y$10$FZ6HZ7E6C2vbtvMw1ThUKeILFnDR7Y6GqSpoKMGgh2tOSLKJSJdr.', '', 'Tan', 'Khai Yu', '2025-05-08 01:19:35', NULL, NULL),
(21, 'cwl', '', 'cwl@gmail.com', '$2y$10$heEj3mCCKKrOxLmtEp96T.PuK31c8YRohtHEWE8hOdiCiBeZyl9PO', '', 'woon', 'long', '2025-05-13 21:34:42', NULL, NULL);

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
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=560;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `delivery`
--
ALTER TABLE `delivery`
  MODIFY `delivery_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=364;

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
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=386;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=425;

--
-- AUTO_INCREMENT for table `promotions`
--
ALTER TABLE `promotions`
  MODIFY `promotion_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `stamp_cards`
--
ALTER TABLE `stamp_cards`
  MODIFY `card_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `stamp_redemptions`
--
ALTER TABLE `stamp_redemptions`
  MODIFY `redemption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `stock`
--
ALTER TABLE `stock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

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
