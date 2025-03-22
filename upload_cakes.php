<?php
include 'db_connect.php';

$cakes = [
    ["Cream Cake", "Delicious creamy cake.", 50.10, "image/c1.png"],
    ["Choco Cake", "Rich chocolate cake.", 60.50, "image/c2.png"],
    ["Slice Cake", "Fresh slice of cake.", 100.10, "image/c3.png"],
    ["Fruit Cake", "Cake topped with fresh fruits.", 30.20, "image/c4.png"],
    ["Brown Cake", "Soft and moist brown cake.", 10.50, "image/c5.png"],
    ["Cup Cake", "Small and sweet cupcake.", 50.10, "image/c6.png"]
];

foreach ($cakes as $cake) {
    $sql = "INSERT INTO cakes (name, description, price, image) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssds", $cake[0], $cake[1], $cake[2], $cake[3]);
    $stmt->execute();
}

echo "蛋糕数据已上传成功！";
$conn->close();
?>
