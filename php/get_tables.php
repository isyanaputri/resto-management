<?php
// Menghubungkan ke file konfigurasi database [cite: 96]
include 'config.php';

/**
 * Query untuk mengambil semua data meja.
 * Data diurutkan berdasarkan ID agar tampilan grid di Flutter tetap konsisten. [cite: 96]
 */
$query = mysqli_query($connect, "SELECT * FROM tables ORDER BY id ASC");

// Inisialisasi array untuk menampung hasil [cite: 96]
$result = array();

// Melakukan perulangan untuk mengambil setiap baris data [cite: 97]
while($row = mysqli_fetch_assoc($query)) {
    /**
     * Memasukkan data meja ke dalam array.
     * Kolom yang diambil meliputi:
     * - id
     * - nomor_meja
     * - status ('kosong', 'terisi', 'dipesan')
     * - kapasitas
     * - keterangan (info pengunjung/pesanan aktif) [cite: 97]
     */
    $result[] = $row;
}

/**
 * Mengirimkan data dalam format JSON.
 * Data ini akan diterima oleh ApiService().getTables() di Flutter. [cite: 97]
 */
echo json_encode($result);
?>