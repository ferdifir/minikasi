class DetailTransaksi {
  int? kodeAkun;
  int? debit;
  int? kredit;

  DetailTransaksi({
    this.kodeAkun,
    this.debit,
    this.kredit,
  });

  DetailTransaksi.fromDoc(Map<String, dynamic> doc) {
    kodeAkun = doc['kodeAkun'];
    debit = doc['debit'];
    kredit = doc['kredit'];
  }
}