import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpenseItem extends StatelessWidget{

  const ExpenseItem(this.expense,this.onEditExpense,{super.key});
  final Expense expense;
  final void Function(Expense expense) onEditExpense;

@override
Widget build(BuildContext context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(expense.title,
                style: Theme.of(context).textTheme.titleLarge
          ),
          const SizedBox(height: 4),
          // Amount + Category Row
          Row(
            children: [
              Text('\u20B9${expense.amount.toStringAsFixed(2)}'),
              const Spacer(),
              Icon(categoryIcon[expense.category]),
              const SizedBox(width: 8),
              Text(expense.formatedDate),
            ],
          ),
           const SizedBox(height: 10),
          // Centered Edit Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                    onEditExpense(expense);
              },
              child: const Text("Edit"),
            ),
          ),
        ],
      ),
    ),
  );
}
}