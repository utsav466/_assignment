// create an abstract class named Bank Account with private properties.
abstract class BankAccount {
  // private accountNumber
  String _accountNumber;
  // Private account holder name
  String _accountHolderName;
  // private balance
  double _balance;
  List<String> _transactions = [];

  // constructor for the class Bank Account

  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // getter to get the data (Hiding the data using getter)

  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;
  List<String> get transactions => _transactions;

  // setter to set the Account Holder Name
  set accountHolderName(String name) => _accountHolderName = name;

  void deposit(double amount);
  void withdraw(double amount);

  // method to display an account information
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

abstract class InterestBearing {
  void calculateInterest();
}

// Saving Account child clas of Bank Account

class SavingsAccount extends BankAccount implements InterestBearing {
  // to track the withdrawal limit which is 3
  int _withdrawalsThisMonth = 0;

  SavingsAccount(String accountNumber, String accountHolderName, double balance)
    : super(accountNumber, accountHolderName, balance);

  @override
  // deposit Amount
  void deposit(double amount) {
    if (amount <= 0) {
      print('Invalid deposit amount');
      return;
    }
    // Add amount to the balance.
    _balance += amount;
    // add those transaction
    _transactions.add('Deposited \$$amount');
  }

  @override
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
    // withdraw amount
    _balance -= amount;
    // add the withdrawal in the month (limit 3)
    _withdrawalsThisMonth++;
    // transaction added in the array of string
    _transactions.add('Withdrew \$$amount');
  }

  @override
  void calculateInterest() {
    double interest = _balance * 0.02;
    _balance += interest;
    _transactions.add('Interest applied: \$$interest');
  }
}

// checking Account created in Bank Account

class CheckingAccount extends BankAccount {
  CheckingAccount(String accountNumber, String holder, double balance)
    : super(accountNumber, holder, balance);

  @override
  //deposit method
  void deposit(double amount) {
    if (amount <= 0) {
      print('Invalid deposit amount');
      return;
    }
    _balance += amount;
    _transactions.add('Deposited \$$amount');
  }

  // withdraw method
  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      print('Invalid withdrawal amount');
      return;
    }
    _balance -= amount;

    // If I have 35 dollar and I try to withdraw 70 dollar, then -35$ is overdraft
    if (_balance < 0) {
      _balance -= 35; // overdraft fee
      _transactions.add('Overdraft fee applied: \$35');
    }
    _transactions.add('Withdrew \$$amount');
  }
}

//Premium Account

class PremiumAccount extends BankAccount implements InterestBearing {
  PremiumAccount(String accountNumber, String holder, double balance)
    : super(accountNumber, holder, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print('Invalid deposit amount');
      return;
    }
    _balance += amount;
    _transactions.add('Deposited \$$amount');
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) {
      print('Invalid withdrawal amount');
      return;
    }

    // 10000 should be in account
    if (_balance - amount < 10000) {
      print('Cannot withdraw: minimum balance \$10,000 required');
      return;
    }
    _balance -= amount;
    _transactions.add('Withdrew \$$amount');
  }

  @override
  void calculateInterest() {
    double interest = _balance * 0.05;
    _balance += interest;
    _transactions.add('Interest applied: \$$interest');
  }
}

class StudentAccount extends BankAccount {
  StudentAccount(String accountNumber, String holder, double balance)
    : super(accountNumber, holder, balance);

  @override
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
  void withdraw(double amount) {
    if (amount <= 0) {
      print('Invalid withdrawal amount');
      return;
    }
    _balance -= amount;
    _transactions.add('Withdrew \$$amount');
  }
}

class Bank {
  List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
  }

  BankAccount? findAccount(String accountNumber) {
    try {
      return _accounts.firstWhere((acc) => acc.accountNumber == accountNumber);
    } catch (e) {
      return null;
    }
  }

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

  void generateReport() {
    for (var acc in _accounts) {
      acc.displayInfo();
      print('---');
    }
  }

  void applyMonthlyInterest() {
    for (var acc in _accounts) {
      if (acc is InterestBearing) {
        (acc as InterestBearing).calculateInterest();
      }
    }
  }
}

void main() {
  // Example usage
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
  checking.withdraw(600); // Overdraft
  premium.deposit(500);
  student.deposit(4000); // Max balance check

  bank.applyMonthlyInterest();

  bank.generateReport();
}