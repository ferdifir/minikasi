class DetailTransaksi {
  String? namaAkun;
  int? kodeAkun;
  int? debit;
  int? kredit;

  DetailTransaksi({
    this.namaAkun,
    this.kodeAkun,
    this.debit,
    this.kredit,
  });

  DetailTransaksi.fromDoc(Map<String, dynamic> doc) {
    namaAkun = doc['namaAkun'];
    kodeAkun = doc['kodeAkun'];
    debit = doc['debit'];
    kredit = doc['kredit'];
  }
}
