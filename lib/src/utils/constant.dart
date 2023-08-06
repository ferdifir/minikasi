const String uidPrefKey = 'uid';
const List<Map<String, dynamic>> initialAccountCode = [
  {
    'accountName': "Kas",
    'accountCode': 1101,
    'accountType': 'Aset Lancar',
  },
  {
    'accountName': "Kas di Bank",
    'accountCode': 1102,
    'accountType': 'Aset Lancar',
  },
  {
    'accountName': "Piutang Usaha",
    'accountCode': 1103,
    'accountType': 'Aset Lancar',
  },
  {
    'accountName': "Perlengkapan",
    'accountCode': 1104,
    'accountType': 'Aset Lancar',
  },
  {
    'accountName': "Tanah",
    'accountCode': 1201,
    'accountType': 'Aset Tetap',
  },
  {
    'accountName': "Bangunan",
    'accountCode': 1202,
    'accountType': 'Aset Tetap',
  },
  {
    'accountName': "Peralatan",
    'accountCode': 1203,
    'accountType': 'Aset Tetap',
  },
  {
    'accountName': "Utang Usaha",
    'accountCode': 2101,
    'accountType': 'Liabilitas Jangka Pendek',
  },
  {
    'accountName': "Utang Gaji",
    'accountCode': 2102,
    'accountType': 'Liabilitas Jangka Pendek',
  },
  {
    'accountName': "Utang Pajak",
    'accountCode': 2103,
    'accountType': 'Liabilitas Jangka Pendek',
  },
  {
    'accountName': "Utang Bank",
    'accountCode': 2201,
    'accountType': 'Liabilitas Jangka Panjang',
  },
  {
    'accountName': "Modal Pemilik",
    'accountCode': 3101,
    'accountType': 'Ekuitas',
  },
  {
    'accountName': "Hibah",
    'accountCode': 3201,
    'accountType': 'Ekuitas',
  },
  {
    'accountName': "Sumbangan",
    'accountCode': 3301,
    'accountType': 'Ekuitas',
  },
  {
    'accountName': "Pendapatan Jasa",
    'accountCode': 4101,
    'accountType': 'Pendapatan Operasional',
  },
  {
    'accountName': "Pendapatan Bunga",
    'accountCode': 4102,
    'accountType': 'Pendapatan Non Operasional',
  },
  {
    'accountName': "Pendapatan Lain-lain",
    'accountCode': 4103,
    'accountType': 'Pendapatan Non Operasional',
  },
  {
    'accountName': "Beban Gaji",
    'accountCode': 5101,
    'accountType': 'Beban Operasional',
  },
  {
    'accountName': "Beban Perlengkapan",
    'accountCode': 5102,
    'accountType': 'Beban Operasional',
  },
  {
    'accountName': "Beban Sewa",
    'accountCode': 5103,
    'accountType': 'Beban Operasional',
  },
  {
    'accountName': "Beban Listrik",
    'accountCode': 5104,
    'accountType': 'Beban Operasional',
  },
  {
    'accountName': "Beban Air",
    'accountCode': 5105,
    'accountType': 'Beban Operasional',
  },
  {
    'accountName': "Beban Telepon",
    'accountCode': 5106,
    'accountType': 'Beban Operasional',
  },
  {
    'accountName': "Prive Pemilik",
    'accountCode': 6101,
    'accountType': 'Pengembalian Ekuitas',
  },
  {
    'accountName': "Akumulasi Penyusutan Kendaraan",
    'accountCode': 7103,
    'accountType': 'Akun Lain-lain',
  },
  {
    'accountName': "Akumulasi Penyusutan Mesin",
    'accountCode': 7104,
    'accountType': 'Akun Lain-lain',
  },
  {
    'accountName': "Cadangan Kerugian Piutang",
    'accountCode': 7105,
    'accountType': 'Akun Lain-lain',
  },
];

List<String> accountTypeList = [
  'Aset Lancar',
  'Aset Tetap',
  'Liabilitas Jangka Pendek',
  'Liabilitas Jangka Panjang',
  'Ekuitas',
  'Pendapatan Operasional',
  'Pendapatan Non Operasional',
  'Beban Operasional',
  'Beban Non Operasional',
  'Pengembalian Ekuitas',
  'Akun Lain-lain',
];

const List<Map<String, int>> initialBalance = [
  {
    'accountCode': 1101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 1102,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 1103,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 1104,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 1201,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 1202,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 1203,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 2101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 2102,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 2103,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 2201,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 3101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 3201,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 3301,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 4101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 4102,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 4103,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 5101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 5102,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 5103,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 5104,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 5105,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 5106,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 6101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 7103,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 7104,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountCode': 7105,
    'debit': 0,
    'kredit': 0,
  },
];
