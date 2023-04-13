const String uidPrefKey = 'uid';

const List initialAccountCode = [
  {
    'accountName': "Kas",
    'accountCode': 100101,
  },
  {
    'accountName': "Kas di Bank",
    'accountCode': 100201,
  },
  {
    'accountName': "Operational Car",
    'accountCode': 100404,
  },
  {
    'accountName': "Account Receiveable",
    'accountCode': 100301,
  },
  {
    'accountName': "Account Payable",
    'accountCode': 200101,
  },
  {
    'accountName': "Receiveable Income",
    'accountCode': 200102,
  },
  {
    'accountName': "Other Liabilities",
    'accountCode': 200103,
  },
  {
    'accountName': "Employee Receiveable",
    'accountCode': 100303,
  },
  {
    'accountName': "Merchandise Inventory",
    'accountCode': 100304,
  },
  {
    'accountName': "Computer, Network and IT Equipment",
    'accountCode': 100402,
  },
  {
    'accountName': "Office Furniture",
    'accountCode': 100403,
  },
  {
    'accountName': "Account Payable",
    'accountCode': 210101,
  },
  {
    'accountName': "Salary Payable",
    'accountCode': 210102,
  },
  {
    'accountName': "Equity",
    'accountCode': 300101,
  },
  {
    'accountName': "Current Year Profit",
    'accountCode': 300102,
  },
  {
    'accountName': "Retained Earning",
    'accountCode': 300103,
  },
  {
    'accountName': "Profit/Loss",
    'accountCode': 300104,
  },
  {
    'accountName': "Sales",
    'accountCode': 410101,
  },
  {
    'accountName': "Sales Discount",
    'accountCode': 410102,
  },
  {
    'accountName': "Sales Return",
    'accountCode': 410103,
  },
  {
    'accountName': "Purchase",
    'accountCode': 510101,
  },
  {
    'accountName': "Purchase Discount",
    'accountCode': 510102,
  },
  {
    'accountName': "Purchase Return",
    'accountCode': 510103,
  },
  {
    'accountName': "Cost of Goods Sold",
    'accountCode': 510111,
  },
  {
    'accountName': "Operational Expense",
    'accountCode': 510113,
  },
];

const List<Map<String, dynamic>> initialBalance = [
  {
    'accountName': "Kas",
    'accountCode': 100101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Kas di Bank",
    'accountCode': 100201,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Operational Car",
    'accountCode': 100404,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Account Receiveable",
    'accountCode': 100301,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Account Payable",
    'accountCode': 200101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Receiveable Income",
    'accountCode': 200102,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Other Liabilities",
    'accountCode': 200103,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Employee Receiveable",
    'accountCode': 100303,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Merchandise Inventory",
    'accountCode': 100304,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Computer, Network and IT Equipment",
    'accountCode': 100402,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Office Furniture",
    'accountCode': 100403,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Account Payable",
    'accountCode': 210101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Salary Payable",
    'accountCode': 210102,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Equity",
    'accountCode': 300101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Current Year Profit",
    'accountCode': 300102,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Retained Earning",
    'accountCode': 300103,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Profit/Loss",
    'accountCode': 300104,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Sales",
    'accountCode': 410101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Sales Discount",
    'accountCode': 410102,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Sales Return",
    'accountCode': 410103,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Purchase",
    'accountCode': 510101,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Purchase Discount",
    'accountCode': 510102,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Purchase Return",
    'accountCode': 510103,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Cost of Goods Sold",
    'accountCode': 510111,
    'debit': 0,
    'kredit': 0,
  },
  {
    'accountName': "Operational Expense",
    'accountCode': 510113,
    'debit': 0,
    'kredit': 0,
  },
];

List<Map<String, dynamic>> periodeList = [
  {
    'namaPeriode': 'Januari 2023',
    'mulai': DateTime(2023, 1, 1),
    'akhir': DateTime(2023, 1, 31),
    'idPeriode': 202301,
    'status': true,
  },
  {
    'namaPeriode': 'Februari 2023',
    'mulai': DateTime(2023, 2, 1),
    'akhir': DateTime(2023, 2, 29),
    'idPeriode': 202302,
    'status': true,
  },
  {
    'namaPeriode': 'Maret 2023',
    'mulai': DateTime(2023, 3, 1),
    'akhir': DateTime(2023, 3, 31),
    'idPeriode': 202303,
    'status': true,
  },
  {
    'namaPeriode': 'April 2023',
    'mulai': DateTime(2023, 4, 1),
    'akhir': DateTime(2023, 4, 30),
    'idPeriode': 202304,
    'status': true,
  },
  {
    'namaPeriode': 'Mei 2023',
    'mulai': DateTime(2023, 5, 1),
    'akhir': DateTime(2023, 5, 31),
    'idPeriode': 202305,
    'status': true,
  },
  {
    'namaPeriode': 'Juni 2023',
    'mulai': DateTime(2023, 6, 1),
    'akhir': DateTime(2023, 6, 30),
    'idPeriode': 202306,
    'status': true,
  },
  {
    'namaPeriode': 'Juli 2023',
    'mulai': DateTime(2023, 7, 1),
    'akhir': DateTime(2023, 7, 31),
    'idPeriode': 202307,
    'status': true,
  },
  {
    'namaPeriode': 'Agustus 2023',
    'mulai': DateTime(2023, 8, 1),
    'akhir': DateTime(2023, 8, 31),
    'idPeriode': 202308,
    'status': true,
  },
  {
    'namaPeriode': 'September 2023',
    'mulai': DateTime(2023, 9, 1),
    'akhir': DateTime(2023, 9, 30),
    'idPeriode': 202309,
    'status': true,
  },
  {
    'namaPeriode': 'Oktober 2023',
    'mulai': DateTime(2023, 10, 1),
    'akhir': DateTime(2023, 10, 31),
    'idPeriode': 202310,
    'status': true,
  },
  {
    'namaPeriode': 'November 2023',
    'mulai': DateTime(2023, 11, 1),
    'akhir': DateTime(2023, 11, 30),
    'idPeriode': 202311,
    'status': true,
  },
  {
    'namaPeriode': 'Desember 2023',
    'mulai': DateTime(2023, 12, 1),
    'akhir': DateTime(2023, 12, 31),
    'idPeriode': 202312,
    'status': true,
  },
];

