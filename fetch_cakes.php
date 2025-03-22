<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "sweettooth";

// 连接数据库
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// 获取 3 个随机蛋糕
$sql = "SELECT name, description, price, image FROM cakes ORDER BY RAND() LIMIT 3";
$result = $conn->query($sql);

$cakes = [];
while ($row = $result->fetch_assoc()) {
    $cakes[] = $row;
}

echo json_encode($cakes);
$conn->close();
?>
