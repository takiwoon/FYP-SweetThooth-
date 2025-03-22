<?php
// Database connection
$conn = new mysqli("localhost", "root", "", "sweettooth");

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get dessert ID from URL
if (isset($_GET['id'])) {
    $cake_id = intval($_GET['id']);

    // Fetch dessert details, stock, and additional info
    $sql = "SELECT cakes.*, stock.quantity, dessert_info.ingredients, dessert_info.allergens, dessert_info.nutrition_facts 
            FROM cakes
            LEFT JOIN stock ON cakes.id = stock.cake_id
            LEFT JOIN dessert_info ON cakes.id = dessert_info.cake_id
            WHERE cakes.id = ?";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $cake_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $dessert = $result->fetch_assoc();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dessert Details</title>

    <style>
        /* General styles */
body {
    font-family: 'Poppins', sans-serif;
    background-color: #3e1e00; /* Dark chocolate background */
    color: #fff; /* White text */
    margin: 0;
    padding: 0;
    text-align: center;
}

/* Container */
.container {
    max-width: 800px;
    margin: 50px auto;
    background-color: #5a2d0c; /* Lighter brown for contrast */
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
}

/* Dessert Image */
img {
    width: 100%;
    max-width: 400px;
    height: auto;
    border-radius: 10px;
    margin-bottom: 15px;
    transition: transform 0.3s ease-in-out;
}

img:hover {
    transform: scale(1.05);
}

/* Dessert Details */
h2 {
    font-size: 28px;
    color: #f8c471; /* Golden color */
}

p {
    font-size: 18px;
    margin: 10px 0;
}

strong {
    color: #ffcc80; /* Light brown */
}

/* Quantity Input */
input[type="number"] {
    width: 60px;
    padding: 8px;
    font-size: 16px;
    border-radius: 5px;
    border: 1px solid #ffcc80;
    text-align: center;
    background-color: #fff;
    color: #333;
}

/* Buttons */
button, .back-btn {
    background-color: #d35400; /* Orange shade */
    color: white;
    border: none;
    padding: 10px 15px;
    font-size: 18px;
    cursor: pointer;
    border-radius: 5px;
    margin-top: 15px;
    transition: background 0.3s ease-in-out;
}

button:hover, .back-btn:hover {
    background-color: #e67e22; /* Lighter orange */
}

/* Back to Products Button */
.back-btn {
    display: inline-block;
    background-color: #8B4513; /* Chocolate brown */
    color: #fff;
    padding: 12px 20px;
    font-size: 18px;
    border-radius: 25px;
    text-decoration: none;
    font-weight: bold;
    margin-top: 20px;
    transition: all 0.3s ease-in-out;
    border: 2px solid transparent;
    position: absolute;
    top: 10px;
    left: 10px;
}

.back-btn:hover {
    background-color: #A0522D; /* Lighter brown */
    color: #ffcc80;
    border: 2px solid #ffcc80;
    transform: scale(1.05);
    box-shadow: 0 4px 10px rgba(255, 204, 128, 0.5);
}
    </style>
</head>
<body>
<a href="product.php" class="back-btn" onclick="saveScrollPosition()">Back to Products</a>

<script>
function saveScrollPosition() {
    sessionStorage.setItem("scrollPosition", window.scrollY);
}
</script>



<div class="container">
    <?php if ($dessert) { ?>
        <h2><?php echo $dessert['name']; ?></h2>
        <img src="<?php echo $dessert['image']; ?>" alt="<?php echo $dessert['name']; ?>" style="width:300px; height:auto;">
        <p><strong>Description:</strong> <?php echo $dessert['description']; ?></p>
        <p><strong>Price:</strong> RM<?php echo $dessert['price']; ?></p>
        <p><strong>Stock Available:</strong> <?php echo $dessert['quantity']; ?></p>
        <p><strong>Ingredients:</strong> <?php echo $dessert['ingredients']; ?></p>
        <p><strong>Allergens:</strong> <?php echo $dessert['allergens']; ?></p>
        <p><strong>Nutrition Facts:</strong> <?php echo $dessert['nutrition_facts']; ?></p>

        <form action="add_to_cart.php" method="POST">
    <input type="hidden" name="cake_id" value="<?php echo $dessert['id']; ?>">

    <?php if ($dessert['quantity'] > 0) { ?>
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="1" max="<?php echo $dessert['quantity']; ?>" required oninput="checkStock()">
        <button type="submit">Add to Cart</button>
    <?php } else { ?>
        <button type="button" disabled style="background-color: gray; cursor: not-allowed;">Sold Out</button>
    <?php } ?>
</form>

    <?php } else { ?>
        <p>No dessert selected.</p>
    <?php } ?>
</div>

<script>
    function checkStock() {
        var quantityInput = document.getElementById("quantity");
        var stock = parseInt(quantityInput.getAttribute("max"));
        if (quantityInput.value > stock) {
            alert("Stock is limited, cannot buy more than available.");
            quantityInput.value = stock;
        }
    }
</script>

</body>
</html>
