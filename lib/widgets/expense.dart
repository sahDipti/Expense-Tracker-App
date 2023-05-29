import 'package:expenses/models/expenses.dart';
import 'package:expenses/widgets/chart/chart.dart';
import 'package:expenses/widgets/expenses_list/expenses_list.dart';
import 'package:expenses/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget{
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }

}

class _ExpensesState extends State<Expenses>{
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99, 
      category: Category.food, 
      date: DateTime.now(),
    ),
    Expense(
      title: 'Cinema',
      amount: 15.99, 
      category: Category.leisure, 
      date: DateTime.now(),
    ),
  ];

  void _openAddExpensesOverlay (){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context, 
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense);
      }, //here context is not used to make it different
      );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content:const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: (){
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found, Start adding some!'),
    );

    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(
              expenses: _registeredExpenses,
              onRemoveExpense: _removeExpense,
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpensesOverlay, 
            icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: width < 600 ? Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: mainContent
            ),
        ],
      ) 
      : Row(
        children: [
          Expanded(
            child: Chart(
              expenses: _registeredExpenses)
            ),
          Expanded(
            child: mainContent
            ),
        ],
      ) ,
    );
  }
}