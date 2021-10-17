import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [];
  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/listaTrefas.json");
  }

  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text;
    _controllerTarefa.text = '';
    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = textoDigitado;
    tarefa['realizada'] = false;

    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvaArquivo();
  }

  _salvaArquivo() async {
    var arquivo = await _getFile();
    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      var arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
    super.initState();
  }

  Widget criarItemLista(context, index) {

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(
              Icons.delete,
              color: Colors.white,
            )
          ],
        ),
      ),
      onDismissed: (direction) {


        Map<String, dynamic> tarefa = Map();
        tarefa['titulo'] = _listaTarefas[index]['titulo'];
        tarefa['realizada'] = _listaTarefas[index]['realizada'];
        _listaTarefas.removeAt(index);
        _salvaArquivo();
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            content: const Text("Tarefa Removida"),
            action: SnackBarAction(label: "Desfazer", onPressed: () {
              setState(() {
                _listaTarefas.add(tarefa);
              });
              _salvaArquivo();

            },)
        ));

      },
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      child: CheckboxListTile(
          title: Text(_listaTarefas[index]['titulo']),
          value: _listaTarefas[index]['realizada'],
          onChanged: (valor) {
            setState(() {
              _listaTarefas[index]['realizada'] = valor;
            });
            _salvaArquivo();
          }),
    );
  }

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
                itemCount: _listaTarefas.length, itemBuilder: criarItemLista),
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
                    autofocus: true,
                    controller: _controllerTarefa,
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (texto) {},
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar')),
                    TextButton(
                        onPressed: () {
                          _salvarTarefa();
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
