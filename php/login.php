<?php
include 'config.php';

// [PERUBAHAN]: Menangkap input username & password
$username = $_POST['username'];
$password = $_POST['password'];

// [PERUBAHAN]: Query ke tabel 'users' yang baru dibuat
$q = mysqli_query($connect, "SELECT * FROM users WHERE username='$username' AND password='$password'");
$row = mysqli_fetch_assoc($q);

if ($row) {
    // Login Sukses
    echo json_encode([
        'status' => 'success', 
        'role' => $row['role'],
        'user_id' => $row['id'] // Tambahan: berguna jika nanti butuh ID kasir
    ]);
} else {
    // Login Gagal
    echo json_encode([
        'status' => 'error', 
        'message' => 'Username atau Password Salah!'
    ]);
}
?>