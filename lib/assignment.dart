// create an abstract class named Bank Account with private properties.
abstract class BankAccount {
  // private account number
  String _accountNumber;
  // private account holder name
  String _accountHolderName;
  // private account balance
  double _balance;
  // list to store transactions
  List<String> _transactions = [];

  // constructor
  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // getters to read private data
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;
  List<String> get transactions => _transactions;

  // setter to update account holder name
  set accountHolderName(String name) => _accountHolderName = name;

  void deposit(double amount);
  void withdraw(double amount);

  // show account details
  void displayInfo() {
    print('Account Number: $_accountNumber');
    print('Holder: $_accountHolderName');
    print('Balance: \$$_balance');
    print('Transaction History:');
    for (var trans in _transactions) {
      print('  $trans');
    }
  }
}

// interface for interest feature
abstract class InterestBearing {
  void calculateInterest();
}

// Savings Account (child of BankAccount)
class SavingsAccount extends BankAccount implements InterestBearing {
  // track number of withdrawals (limit 3)
  int _withdrawalsThisMonth = 0;

  SavingsAccount(String accountNumber, String accountHolderName, double balance)
    : super(accountNumber, accountHolderName, balance);

  @override
  // deposit money
  void deposit(double amount) {
    if (amount <= 0) {
      print('Invalid deposit amount');
      return;
    }
    _balance += amount;
    _transactions.add('Deposited \$$amount');
  }

  @override
  // withdraw money
  void withdraw(double amount) {
    if (amount <= 0) {
      print('Invalid withdrawal amount');
      return;
    }
    if (_balance - amount < 500) {
      print('Cannot withdraw: minimum balance \$500');
      return;
    }
    if (_withdrawalsThisMonth >= 3) {
      print('Withdrawal limit reached');
      return;
    }
    _balance -= amount;
    _withdrawalsThisMonth++;
    _transactions.add('Withdrew \$$amount');
  }

  @override
  // calculate and add interest
  void calculateInterest() {
    double interest = _balance * 0.02;
    _balance += interest;
    _transactions.add('Interest applied: \$$interest');
  }
}

// Checking Account
class CheckingAccount extends BankAccount {
  CheckingAccount(String accountNumber, String holder, double balance)
    : super(accountNumber, holder, balance);

  @override
  // deposit money
  void deposit(double amount) {
    if (amount <= 0) {
      print('Invalid deposit amount');
      return;
    }
    _balance += amount;
    _transactions.add('Deposited \$$amount');
  }

  @override
  // withdraw money (apply overdraft fee if negative)
  void withdraw(double amount) {
    if (amount <= 0) {
      print('Invalid withdrawal amount');
      return;
    }
    _balance -= amount;

    if (_balance < 0) {
      _balance -= 35;
      _transactions.add('Overdraft fee applied: \$35');
    }
    _transactions.add('Withdrew \$$amount');
  }
}

// Premium Account
class PremiumAccount extends BankAccount implements InterestBearing {
  PremiumAccount(String accountNumber, String holder, double balance)
    : super(accountNumber, holder, balance);

  @override
  // deposit money
  void deposit(double amount) {
    if (amount <= 0) {
      print('Invalid deposit amount');
      return;
    }
    _balance += amount;
    _transactions.add('Deposited \$$amount');
  }

  @override
  // withdraw money (keep at least 10,000)
  void withdraw(double amount) {
    if (amount <= 0) {
      print('Invalid withdrawal amount');
      return;
    }
    if (_balance - amount < 10000) {
      print('Cannot withdraw: minimum balance \$10,000 required');
      return;
    }
    _balance -= amount;
    _transactions.add('Withdrew \$$amount');
  }

  @override
  // calculate and add interest
  void calculateInterest() {
    double interest = _balance * 0.05;
    _balance += interest;
    _transactions.add('Interest applied: \$$interest');
  }
}

// Student Account
class StudentAccount extends BankAccount {
  StudentAccount(String accountNumber, String holder, double balance)
    : super(accountNumber, holder, balance);

  @override
  // deposit money (max balance 5000)
  void deposit(double amount) {
    if (amount <= 0) {
      print('Invalid deposit amount');
      return;
    }
    if (_balance + amount > 5000) {
      print('Cannot deposit: maximum balance \$5000');
      return;
    }
    _balance += amount;
    _transactions.add('Deposited \$$amount');
  }

  @override
  // withdraw money
  void withdraw(double amount) {
    if (amount <= 0) {
      print('Invalid withdrawal amount');
      return;
    }
    _balance -= amount;
    _transactions.add('Withdrew \$$amount');
  }
}

// Bank class to manage all accounts
class Bank {
  List<BankAccount> _accounts = [];

  // add new account
  void createAccount(BankAccount account) {
    _accounts.add(account);
  }

  // find account by number
  BankAccount? findAccount(String accountNumber) {
    try {
      return _accounts.firstWhere((acc) => acc.accountNumber == accountNumber);
    } catch (e) {
      return null;
    }
  }

  // transfer money between accounts
  void transfer(String fromAccNum, String toAccNum, double amount) {
    var from = findAccount(fromAccNum);
    var to = findAccount(toAccNum);
    if (from != null && to != null && from.balance >= amount && amount > 0) {
      from.withdraw(amount);
      to.deposit(amount);
      print('Transfer successful');
    } else {
      print('Transfer failed: invalid accounts or insufficient funds');
    }
  }

  // show all accounts info
  void generateReport() {
    for (var acc in _accounts) {
      acc.displayInfo();
      print('---');
    }
  }

  // apply interest to accounts that support it
  void applyMonthlyInterest() {
    for (var acc in _accounts) {
      if (acc is InterestBearing) {
        (acc as InterestBearing).calculateInterest();
      }
    }
  }
}

void main() {
  // Example use
  var bank = Bank();

  var savings = SavingsAccount('S001', 'Alice', 1000);
  var checking = CheckingAccount('C001', 'Bob', 500);
  var premium = PremiumAccount('P001', 'Charlie', 15000);
  var student = StudentAccount('ST001', 'Dave', 1000);

  bank.createAccount(savings);
  bank.createAccount(checking);
  bank.createAccount(premium);
  bank.createAccount(student);

  savings.deposit(100);
  savings.withdraw(50);
  checking.withdraw(600); // overdraft
  premium.deposit(500);
  student.deposit(4000); // max balance check

  bank.applyMonthlyInterest();

  bank.generateReport();
}
