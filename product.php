<?php
include 'db_connect.php';

// Get category filter
$selectedCategory = isset($_GET['category']) ? $_GET['category'] : 'all';

// Get sorting option
$sortOption = isset($_GET['sort']) ? $_GET['sort'] : 'name_asc';

// Base query
$sql = "SELECT * FROM cakes WHERE 1"; 
$params = [];
$types = "";

// Apply category filter
if ($selectedCategory !== 'all') {
    $sql .= " AND category = ?";
    $params[] = $selectedCategory;
    $types .= "s";
}

// Apply promotion filter
if ($sortOption === "promotion") {
    $sql .= " AND promotion_status = 'Yes'";
}

// Apply sorting
switch ($sortOption) {
    case "price_high":
        $sql .= " ORDER BY COALESCE(promotion_price, price) DESC";
        break;
    case "price_low":
        $sql .= " ORDER BY COALESCE(promotion_price, price) ASC";
        break;
    case "name_desc":
        $sql .= " ORDER BY name DESC";
        break;
    default:
        $sql .= " ORDER BY name ASC"; // Default sorting
}

// Prepare and execute query
$stmt = $conn->prepare($sql);
if (!empty($params)) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$result = $stmt->get_result();

// Store results in an array
$products = [];
while ($row = $result->fetch_assoc()) {
    $products[] = $row;
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SweetTooth</title>
    <link rel="shortcut icon" type="image/png" href="./image/logo.png">
    <link rel="stylesheet" href="css/product.css">
    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js"></script>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Uchen&display=swap" rel="stylesheet">
    <!-- Icons -->
    <link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css' rel='stylesheet'>
    <!-- Animation -->
    <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css">
</head>
<body>

<!-- loading animation -->
<div id="loading-screen">
    <div class="loader"></div>
</div>

<style>
/* Loading animation */
#loading-screen {
    position: fixed;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}
.loader {
    border: 5px solid #f3f3f3;
    border-top: 5px solid #3498db;
    border-radius: 50%;
    width: 50px;
    height: 50px;
    animation: spin 1s linear infinite;
}
@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
</style>

<script>
document.addEventListener("DOMContentLoaded", function() {
    setTimeout(() => {
        document.getElementById("loading-screen").style.display = "none";
    }, 100); 
});
</script>

<!-- Header -->
<div id="header"></div>

<div class="all-content">
    <h2 class="product-title">MENU</h2>
    <div class="product-underline"></div>

    <div class="filter-container">
        <label for="categoryFilter">Filter by Category:</label>
        <select id="categoryFilter">
            <option value="all">All</option>
            <option value="cake">Cake</option>
            <option value="Tiramisu">Tiramisu</option>
            <option value="donut">Donut</option>
            <option value="ice cream">Ice Cream</option>
            <option value="Drink">Drink</option>
            <option value="other">Other</option>
        </select>

        <label for="sortFilter">Sort by:</label>
        <select id="sortFilter">
            <option value="name_asc">Name (A-Z)</option>
            <option value="name_desc">Name (Z-A)</option>
            <option value="price_low">Price (Low to High)</option>
            <option value="price_high">Price (High to Low)</option>
            <option value="promotion">Promotion</option>
        </select>
    </div>

    <div class="container">
        <div class="row">
            <?php foreach ($products as $row): ?>
                <div class="col-md-4 product-card" data-category="<?= htmlspecialchars($row['category']); ?>">
                <a href="dessert_details.php?id=<?= $row['id']; ?>" class="card-link">
                    <img src="<?= htmlspecialchars($row['image']); ?>" 
                         alt="<?= htmlspecialchars($row['name']); ?>" 
                         class="product-image"
                         onerror="this.onerror=null; this.src='image/default.jpg';">
                    
                    <h2><?= htmlspecialchars($row['name']); ?></h2>
                    <p><?= htmlspecialchars($row['description']); ?></p>

                    <?php if ($row['promotion_status'] === "Yes" && $row['promotion_price'] > 0): ?>
                        <p class="original-price">RM<?= number_format($row['price'], 2); ?></p>
                        <p class="promotion-price">RM<?= number_format($row['promotion_price'], 2); ?>
                            <span class="discount-label">(<?= round((($row['price'] - $row['promotion_price']) / $row['price']) * 100, 2); ?>% OFF)</span>
                        </p>
                    <?php else: ?>
                        <p class="price">RM<?= number_format($row['price'], 2); ?></p>
                    <?php endif; ?>

                    <!-- Updated button -->
                    <a href="dessert_details.php?id=<?= urlencode($row['id']); ?>" class="custom-btn add-cart">View Details</a>
                </div>
            <?php endforeach; ?>
        </div>
    </div>
</div>

<div id="footer"></div>

<script>
window.onload = function () {
    // Restore scroll position if available
    if (sessionStorage.getItem("scrollPosition") !== null) {
        window.scrollTo(0, sessionStorage.getItem("scrollPosition"));
        sessionStorage.removeItem("scrollPosition"); // Clear it after restoring
    }

    let urlParams = new URLSearchParams(window.location.search);
    document.getElementById('categoryFilter').value = urlParams.get('category') || 'all';
    document.getElementById('sortFilter').value = urlParams.get('sort') || 'name_asc';
};

// Save scroll position before navigating away
function saveScrollPosition() {
    sessionStorage.setItem("scrollPosition", window.scrollY);
}

// Apply filters (Save scroll before reloading)
document.getElementById('categoryFilter').addEventListener('change', function () {
    saveScrollPosition();
    let sortValue = document.getElementById('sortFilter').value;
    window.location.href = 'product.php?category=' + this.value + '&sort=' + sortValue;
});

document.getElementById('sortFilter').addEventListener('change', function () {
    saveScrollPosition();
    let categoryValue = document.getElementById('categoryFilter').value;
    window.location.href = 'product.php?category=' + categoryValue + '&sort=' + this.value;
});

// Save scroll when clicking any product
document.querySelectorAll('.product-link').forEach(item => {
    item.addEventListener('click', saveScrollPosition);
});

// Fetch header and footer
fetch("header.html").then(response => response.text()).then(data => { document.getElementById("header").innerHTML = data; });

fetch("footer.html").then(response => response.text()).then(data => { document.getElementById("footer").innerHTML = data; });
</script>



<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>AOS.init();</script>

</body>
</html>
