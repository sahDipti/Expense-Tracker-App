import 'package:flutter/material.dart';
import 'package:expenses/models/expenses.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year-1,now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context, 
      initialDate: now, 
      firstDate: firstDate, 
      lastDate: now,
    );
    setState(() {
      _selectedDate= pickedDate;
    });
  }

  void _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount==null || enteredAmount<=0;
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate==null){
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Do enter valid title, amount, date and category'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              }, 
              child: const Text('Okay'))
            ],
        )
      );
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text, 
        amount: enteredAmount, 
        category: _selectedCategory, 
        date:_selectedDate!
      ));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('title'),
            ),
          ),

          Row(
            children: [
              //here texfield width is not restricted so we use expanded to correct it 
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    prefixText: '\$',
                    label: Text('Amount'),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_selectedDate == null ? 'No date selected' :formatter.format(_selectedDate!) ),
                    IconButton(
                      onPressed: _presentDatePicker, 
                      icon: const Icon(
                        Icons.calendar_month,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 16,),

          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.name.toUpperCase(),
                    ),
                  ), 
                ).toList(), 
                onChanged: (value){
                  if(value==null){
                    return;
                  }
                  setState(() {
                    _selectedCategory=value;
                  });
                },
              ),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),

              const SizedBox(
                width: 10,
              ),

              ElevatedButton(
                onPressed: () {
                  _submitExpenseData();
                },
                child: const Text('Save expense'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
