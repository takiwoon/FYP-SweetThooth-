<?php
$servername = "localhost";
$username = "root"; 
$password = ""; 
$dbname = "sweettooth";


$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("fail to connect database: " . $conn->connect_error);
}
?>
