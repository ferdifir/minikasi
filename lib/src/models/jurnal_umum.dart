import 'detail_transaksi.dart';

class JurnalUmum {
  String? tanggal;
  String? keterangan;
  List<DetailTransaksi>? detailTransaksi;

  JurnalUmum({
    this.tanggal,
    this.keterangan,
    this.detailTransaksi,
  });

  JurnalUmum.fromDoc(Map<String, dynamic> doc) {
    tanggal = doc['tanggal'];
    keterangan = doc['keterangan'];
    detailTransaksi = doc['detailTransaksi']
        .map<DetailTransaksi>((e) => DetailTransaksi.fromDoc(e))
        .toList();
  }
}