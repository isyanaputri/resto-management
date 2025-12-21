<?php
include 'config.php';

// Menangkap data dari Flutter
$old_username = $_POST['old_username'];
$old_password = $_POST['old_password'];
$new_username = $_POST['new_username'];
$new_password = $_POST['new_password'];

// 1. Cek apakah User Lama Valid (Username & Password lama cocok)
$checkQuery = mysqli_query($connect, "SELECT * FROM users WHERE username='$old_username' AND password='$old_password'");
$userData = mysqli_fetch_assoc($checkQuery);

if ($userData) {
    // Jika data lama benar, lakukan Update ke data baru
    $id_user = $userData['id']; // Asumsi ada kolom id
    
    $updateQuery = "UPDATE users SET username='$new_username', password='$new_password' WHERE id='$id_user'";
    
    if (mysqli_query($connect, $updateQuery)) {
        echo json_encode([
            "status" => "success", 
            "message" => "Data Login Berhasil Diperbarui! Silakan login ulang."
        ]);
    } else {
        echo json_encode([
            "status" => "error", 
            "message" => "Gagal mengupdate data database."
        ]);
    }
} else {
    // Jika username/password lama salah
    echo json_encode([
        "status" => "error", 
        "message" => "Username atau Password Lama Salah!"
    ]);
}
?>