//Description of the expense:what it should contain as parameters
//why models--> Models are the backbone of your app's
// data layer — they define the shape and behavior of everything your app works with.
//instead of raw data--> better is to use strongly typed objects
class Expense {
  final String title;
  final int amount;
  final String category;
  final DateTime date;
  final String note;
//contructor
  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });
//serilaization
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }
//factory contructor
  factory Expense.fromMap(
      Map<String, dynamic> map) {
    return Expense(
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(
        map['date'],
      ),
      note: map['note'],
    );
  }
}
//Serialization--->
//hive(local storage)--> do not unserstand the objects it wants int bool map list etx
//serialiaztion is-->converting expense --> map --> (to get stored in) hive
//and vice versa--> to get local data ---> hive--> map-->expense


//converting expense class params to key value(map)
//------> Add to map fucntion
/*---> class paramets to key , value pair
Map<String, dynamic> toMap() {--> type any --> so dynamic
  return {
    'title': title,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'note': note,
  };
}
--> the map--------> hive can stote this data
*/


//from data to object of expense
//-----> A factory constructor creates an object from some existing data.
//           Expense.fromMap(...)
/* Map<String, dynamic> data = {
    'title': 'Pizza',
    'amount': 300,
    'category': 'Food',
    'date': '2026-06-23T22:10:00',
    'note': 'Dominos',
    };

    Expense expense =
    Expense.fromMap(data);

    ---->now agin we have info as object
    Expense
 ├── Pizza
 ├── 300
 ├── Food
 ├── Date
 └── Dominos
    */


