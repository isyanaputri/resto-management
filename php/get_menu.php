<?php
// Menghubungkan ke konfigurasi database
include 'config.php';

/**
 * Query untuk mengambil semua item menu.
 * Data diambil dari tabel 'menu' yang berisi:
 * nama, deskripsi, harga, kategori, dan path gambar.
 */
$query = mysqli_query($connect, "SELECT * FROM menu ORDER BY kategori ASC, nama ASC");

$result = array();

while($row = mysqli_fetch_assoc($query)) {
    // Memasukkan setiap baris menu ke dalam array hasil
    $result[] = $row;
}

/**
 * Mengirimkan data menu dalam format JSON.
 * Data ini akan diproses oleh OrderScreen di Flutter untuk menampilkan 12 menu.
 */
echo json_encode($result);
?>