<?php
include 'config.php';

// Menangkap data yang dikirim dari Flutter melalui body request
$username = $_POST['username']; //[cite: 83, 98]
$password = $_POST['password']; //[cite: 83, 98]

// Query untuk mencari user berdasarkan username dan password
$q = mysqli_query($connect, "SELECT * FROM users WHERE username='$username' AND password='$password'");// [cite: 98]
$row = mysqli_fetch_assoc($q);// [cite: 98]

if ($row) {
    // Jika data ditemukan, kirim status sukses dan role (owner/staff)
    echo json_encode([
        'status' => 'success', 
        'role' => $row['role']
    ]);// [cite: 99]
} else {
    // Jika tidak ditemukan, kirim pesan error
    echo json_encode([
        'status' => 'error', 
        'message' => 'Username atau Password Salah!'
    ]);// [cite: 100]
}
?>