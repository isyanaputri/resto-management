<?php
include 'config.php';

// Menangkap data dari Flutter
$name   = $_POST['name'];
$phone  = $_POST['phone'];
$date   = $_POST['date']; // Format: YYYY-MM-DD HH:MM:SS
$people = $_POST['people'];
$table  = $_POST['table_no'];
$notes  = $_POST['notes'] ?? '-';

// 1. Masukkan ke tabel Reservasi
$sql = "INSERT INTO reservations (customer_name, phone, res_date, people, table_no, notes) 
        VALUES ('$name', '$phone', '$date', '$people', '$table', '$notes')";

if(mysqli_query($connect, $sql)) {
    
    // 2. Update Status Meja jadi 'dipesan'
    // Kita juga update kolom 'keterangan' supaya di Detail Meja muncul infonya
    $info = "Booked a.n $name ($people Org)\nJam: $date";
    $updateTable = "UPDATE tables SET status='dipesan', keterangan='$info' WHERE nomor_meja='$table'";
    
    mysqli_query($connect, $updateTable);

    echo json_encode([
        "status" => "success", 
        "message" => "Reservasi Berhasil! Meja $table telah diamankan."
    ]);
} else {
    echo json_encode([
        "status" => "error", 
        "message" => "Gagal menyimpan reservasi: " . mysqli_error($connect)
    ]);
}
?>