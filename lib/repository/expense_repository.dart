import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/expense.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Expense> addExpense(Expense expense) async {
    final uid = _auth.currentUser!.uid;

    // Create a new Firestore document reference.
    // Firestore generates the ID here.
    final docRef = _firestore
        .collection("users")
        .doc(uid)
        .collection("expenses")
        .doc();

    // Save the expense data.
    await docRef.set(expense.toMap());

    // Return the expense with its Firestore ID.
    return Expense(
      id: docRef.id,
      title:expense.title,
      amount: expense.amount,
      category: expense.category,
      note: expense.note,
      date: expense.date,
    );
  }




  Future<List<Expense>> getExpenses() async {
  final uid = _auth.currentUser!.uid;

  final snapshot = await _firestore
      .collection("users")
      .doc(uid)
      .collection("expenses")
      .orderBy("date", descending: true)
      .get();

  return snapshot.docs.map((doc) {
    return Expense.fromMap(
      doc.data(),
      doc.id,
    );
  }).toList();
}


Future<void> deleteExpense(String expenseId) async {
  final uid = _auth.currentUser!.uid;

  await _firestore
      .collection("users")
      .doc(uid)
      .collection("expenses")
      .doc(expenseId)
      .delete();
}
}