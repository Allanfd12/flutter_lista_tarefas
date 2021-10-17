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
                  // return ListTile(
                  //   title: Text(_listaTarefas[index]['titulo']),
                  // );
                  return CheckboxListTile(
                      title: Text(_listaTarefas[index]['titulo']),
                      value: _listaTarefas[index]['realizada'],
                      onChanged: (valor) {
                        setState(() {
                          _listaTarefas[index]['realizada'] = valor;
                        });
                        _salvaArquivo();
                      });
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
