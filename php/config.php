<?php
// Header untuk mengizinkan akses dari Flutter Web (CORS)
header("Access-Control-Allow-Origin: *");// [cite: 94]
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); //[cite: 94]
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With"); //[cite: 94]
header("Content-Type: application/json; charset=UTF-8"); //[cite: 94]

// Konfigurasi Database
$host = "localhost";// [cite: 94]
$user = "root"; //[cite: 94]
$pass = ""; // Kosongkan jika menggunakan standar XAMPP 
$db   = "db_restora"; //[cite: 94]

// Koneksi ke MySQL
$connect = mysqli_connect($host, $user, $pass, $db);// [cite: 94]

// Cek Koneksi
if (!$connect) {// [cite: 95]
    die(json_encode([
        "status" => "error", 
        "message" => "Koneksi Database Gagal: " . mysqli_connect_error()
    ]));// [cite: 95]
}
?>