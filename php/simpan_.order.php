<?php
include 'config.php';

// Menangkap data dari Flutter
$table_no = $_POST['table_no'];
$total    = $_POST['total'];
$method   = $_POST['method']; // 'cash' atau 'barcode'
// Data items dikirim dalam bentuk JSON string dari Flutter
$items    = json_decode($_POST['items'], true); 

// Menggunakan Transaction agar jika salah satu proses gagal, data tidak berantakan
mysqli_begin_transaction($connect);

try {
    // 1. Masukkan data ke tabel 'orders'
    $queryOrder = "INSERT INTO orders (nomor_meja, total_harga, metode_bayar) 
                   VALUES ('$table_no', '$total', '$method')";
    mysqli_query($connect, $queryOrder);
    
    // Ambil ID order yang baru saja dibuat
    $order_id = mysqli_insert_id($connect);

    // 2. Masukkan rincian item ke tabel 'order_items' (untuk analisis menu terlaris)
    if (!empty($items)) {
        foreach ($items as $item) {
            $nama_menu = $item['name'];
            $qty       = $item['qty'];
            $price     = $item['price'];
            $subtotal  = $qty * $price;

            $queryItems = "INSERT INTO order_items (order_id, nama_menu, qty, subtotal) 
                           VALUES ('$order_id', '$nama_menu', '$qty', '$subtotal')";
            mysqli_query($connect, $queryItems);
        }
    }

    // 3. Update status meja kembali menjadi 'kosong' dan bersihkan keterangan
    $queryTable = "UPDATE tables SET status='kosong', keterangan='' 
                   WHERE nomor_meja='$table_no'";
    mysqli_query($connect, $queryTable);

    // Jika semua berhasil, simpan permanen
    mysqli_commit($connect);

    echo json_encode([
        "status" => "success", 
        "message" => "Pembayaran berhasil, meja $table_no telah dikosongkan"
    ]);

} catch (Exception $e) {
    // Jika ada error, batalkan semua perubahan data
    mysqli_rollback($connect);
    echo json_encode([
        "status" => "error", 
        "message" => "Gagal memproses pesanan: " . $e->getMessage()
    ]);
}
?>