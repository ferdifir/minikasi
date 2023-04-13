import 'detail_transaksi.dart';

class GeneralLedger {
  String? tanggal;
  String? keterangan;
  List<DetailTransaksi?>? detailtransaksi;

  GeneralLedger({this.tanggal, this.keterangan, this.detailtransaksi});

  GeneralLedger.fromDoc(Map<String, dynamic> doc) {
    tanggal = doc['tanggal'];
    keterangan = doc['keterangan'];
    if (doc['detail_transaksi'] != null) {
      detailtransaksi = <DetailTransaksi>[];
      doc['detail_transaksi'].forEach((v) {
        detailtransaksi!.add(DetailTransaksi.fromDoc(v));
      });
    }
  }
}
