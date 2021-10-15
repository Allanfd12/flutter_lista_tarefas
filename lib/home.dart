import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = ['tarefa 1', 'tarefa 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Lista de Tarefas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_listaTarefas[index]),
                  );
                }),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        icon: Icon(Icons.add),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar uma nova tarefa"),
                  content: TextField(
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (texto) {},
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Salvar')),
                  ],
                );
              });
        },
        label: Text("Adicionar"),
      ),
    );
  }
}
