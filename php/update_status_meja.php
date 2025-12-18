<?php
include 'config.php'; // Mengambil konfigurasi database // [cite: 94]

// Menangkap data transaksi dari aplikasi Flutter
$table_no      = $_POST['table_no'];
$total_bayar   = $_POST['total_bayar'];
$metode        = $_POST['metode']; // 'CASH' atau 'QRIS'
$cash_received = $_POST['cash_received'] ?? 0; // Uang yang diterima (untuk Cash)
$cash_return   = $_POST['cash_return'] ?? 0;   // Kembalian (untuk Cash)

// 1. Simpan data ke tabel transactions untuk keperluan Analisis Pendapatan
$sql_transaksi = "INSERT INTO transactions (table_no, total_bayar, metode, cash_received, cash_return) 
                  VALUES ('$table_no', '$total_bayar', '$metode', '$cash_received', '$cash_return')";

if(mysqli_query($connect, $sql_transaksi)) {
    
    // 2. Jika transaksi berhasil dicatat, ubah status meja menjadi 'available' (kosong kembali)
    $sql_update_meja = "UPDATE tables SET status='available' WHERE nomor_meja='$table_no'";
    
    if(mysqli_query($connect, $sql_update_meja)) {
        // Kirim respon sukses ke Flutter
        echo json_encode([
            "status" => "success", 
            "message" => "Pembayaran berhasil dicatat dan meja telah dikosongkan"
        ]);
    } else {
        echo json_encode([
            "status" => "error", 
            "message" => "Gagal memperbarui status meja"
        ]);
    }
} else {
    // Kirim respon jika gagal menyimpan transaksi
    echo json_encode([
        "status" => "error", 
        "message" => "Gagal menyimpan riwayat transaksi: " . mysqli_error($connect)
    ]);
}
?>