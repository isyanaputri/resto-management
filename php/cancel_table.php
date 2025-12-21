<?php
include 'config.php';

$table_no = $_POST['table_no'];

// Kita kembalikan status meja menjadi 'kosong' dan hapus keterangannya
$query = "UPDATE tables SET status='kosong', keterangan=NULL WHERE nomor_meja='$table_no'";

if (mysqli_query($connect, $query)) {
    echo json_encode([
        "status" => "success", 
        "message" => "Status meja $table_no berhasil dibatalkan/dikosongkan."
    ]);
} else {
    echo json_encode([
        "status" => "error", 
        "message" => "Gagal mengupdate status meja."
    ]);
}
?>