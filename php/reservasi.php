<?php
include 'config.php';

// Menangkap data yang dikirimkan dari aplikasi Flutter melalui metode POST 
$name   = $_POST['name'];   // Nama pelanggan 
$phone  = $_POST['phone'];  // Nomor telepon/kontak 
$date   = $_POST['date'];   // Tanggal dan jam reservasi (format: YYYY-MM-DD HH:MM:SS) 
$people = $_POST['people']; // Jumlah tamu 
$table  = $_POST['table_no']; // Nomor meja yang dipilih 
$notes  = $_POST['notes'] ?? ''; // Catatan tambahan (jika ada) 

/**
 * 1. Menyimpan data reservasi ke dalam tabel 'reservations'
 * Menggunakan kolom: customer_name, phone, res_date, people, table_no, notes 
 */
$sql = "INSERT INTO reservations (customer_name, phone, res_date, people, table_no, notes) 
        VALUES ('$name', '$phone', '$date', '$people', '$table', '$notes')";

if(mysqli_query($connect, $sql)) {
    /**
     * 2. Update status meja menjadi 'dipesan' (reserved)
     * Ini akan mengubah warna meja di denah (Heatmap) aplikasi Flutter secara real-time.
     */
    $updateTable = "UPDATE tables SET status='dipesan' WHERE nomor_meja='$table'";
    mysqli_query($connect, $updateTable);

    // Mengirim respon sukses ke Flutter [cite: 104]
    echo json_encode([
        "status" => "success", 
        "message" => "Reservasi Berhasil! Meja $table telah ditandai."
    ]);
} else {
    // Mengirim respon error jika query gagal [cite: 105]
    echo json_encode([
        "status" => "error", 
        "message" => "Gagal menyimpan data reservasi"
    ]);
}
?>