<?php
include 'config.php'; // Menggunakan koneksi database yang sudah dibuat [cite: 94]

// 1. Menghitung Total Pendapatan dari Tabel Orders
$queryPendapatan = mysqli_query($connect, "SELECT SUM(total_harga) as total FROM orders");
$dataPendapatan = mysqli_fetch_assoc($queryPendapatan);
$totalPendapatan = $dataPendapatan['total'] ?? 0;

// 2. Simulasi/Ambil Data Pengeluaran (Bisa dibuatkan tabel 'expenses' jika ingin lebih detail)
// Untuk sementara kita asumsikan pengeluaran tetap atau ambil dari tabel pengeluaran
$totalPengeluaran = 1120000; // Contoh nilai statis atau query dari tabel pengeluaran

// 3. Mengambil 5 Menu Paling Sering Dipesan (Analisis Menu)
$queryPopuler = mysqli_query($connect, "
    SELECT nama_menu, SUM(qty) as total_qty 
    FROM order_items 
    GROUP BY nama_menu 
    ORDER BY total_qty DESC 
    LIMIT 5
");
$menuPopuler = array();
while($row = mysqli_fetch_assoc($queryPopuler)) {
    $menuPopuler[] = $row;
}

// 4. Analisis Status Meja (Heatmap Analysis)
$queryMeja = mysqli_query($connect, "SELECT status, COUNT(*) as jumlah FROM tables GROUP BY status");
$statusMeja = array();
while($row = mysqli_fetch_assoc($queryMeja)) {
    $statusMeja[] = $row;
}

// Menggabungkan semua data ke dalam satu paket JSON untuk dikirim ke Flutter [cite: 82]
echo json_encode([
    "status" => "success",
    "data" => [
        "ringkasan" => [
            "pendapatan" => (double)$totalPendapatan,
            "pengeluaran" => (double)$totalPengeluaran,
            "keuntungan" => (double)($totalPendapatan - $totalPengeluaran)
        ],
        "menu_terpopuler" => $menuPopuler,
        "statistik_meja" => $statusMeja
    ]
]);
?>