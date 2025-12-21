<?php
include 'config.php';

// Tangkap data dari Flutter
$table_no = $_POST['table_no'];
$total    = $_POST['total'];
$items    = json_decode($_POST['items'], true); // List menu yang dipesan

// Validasi jika JSON gagal didecode
if (json_last_error() !== JSON_ERROR_NONE) {
    echo json_encode(["status" => "error", "message" => "Format data item tidak valid"]);
    exit;
}

// 1. Format teks pesanan untuk 'Info Meja'
$infoPesanan = "Pesanan Aktif:\n";
if (!empty($items)) {
    foreach ($items as $item) {
        $nama = $item['name'];
        $qty  = $item['qty'];
        // Format: - Nasi Goreng (2)
        $infoPesanan .= "- $nama ($qty)\n";
    }
}
$infoPesanan .= "\nEst. Tagihan: Rp " . number_format($total, 0, ',', '.');

// 2. PENTING: Amankan string sebelum masuk database (Mencegah error karena tanda kutip/simbol)
$infoPesananSafe = mysqli_real_escape_string($connect, $infoPesanan);
$tableNoSafe     = mysqli_real_escape_string($connect, $table_no);

// 3. Update status meja jadi 'terisi' dan simpan list pesanan
$query = "UPDATE tables SET status='terisi', keterangan='$infoPesananSafe' WHERE nomor_meja='$tableNoSafe'";

if (mysqli_query($connect, $query)) {
    echo json_encode([
        "status" => "success", 
        "message" => "Order Berhasil! Meja $table_no sekarang TERISI."
    ]);
} else {
    echo json_encode([
        "status" => "error", 
        "message" => "Database Error: " . mysqli_error($connect)
    ]);
}
?>