<?php
include 'config.php';

// 1. Tangkap Data dari Flutter
$table_no = $_POST['table_no'];
$total    = $_POST['total'];
$method   = $_POST['method']; // Akan berisi: 'cash', 'qris', 'debit', atau 'credit'

// (Opsional) Jika ada item detail, bisa ditangkap di sini, tapi untuk pembayaran final cukup totalnya saja.

// 2. Mulai Transaksi (Penting agar data konsisten)
mysqli_begin_transaction($connect);

try {
    // A. Masukkan Data ke Tabel Transaksi (orders)
    // Pastikan nama kolom di database kamu sesuai: nomor_meja, total_harga, metode_bayar
    $queryOrder = "INSERT INTO orders (nomor_meja, total_harga, metode_bayar) 
                   VALUES ('$table_no', '$total', '$method')";
    
    if (!mysqli_query($connect, $queryOrder)) {
        throw new Exception("Gagal menyimpan data transaksi ke tabel orders.");
    }
    
    // B. Kosongkan Status Meja (Reset jadi 'kosong' dan hapus keterangan pesanan)
    $queryClear = "UPDATE tables SET status='kosong', keterangan=NULL WHERE nomor_meja='$table_no'";
    
    if (!mysqli_query($connect, $queryClear)) {
        throw new Exception("Gagal mengupdate status meja.");
    }

    // Jika A dan B berhasil, simpan permanen (COMMIT)
    mysqli_commit($connect);
    
    echo json_encode([
        "status" => "success", 
        "message" => "Pembayaran Berhasil Disimpan!"
    ]);

} catch (Exception $e) {
    // Jika ada error, batalkan semua perubahan (ROLLBACK)
    mysqli_rollback($connect);
    
    echo json_encode([
        "status" => "error", 
        "message" => "Database Error: " . $e->getMessage()
    ]);
}
?>