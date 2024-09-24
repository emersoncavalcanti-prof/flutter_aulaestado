import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _tarefas = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _caregarTarefas();
  }

  void _addTarefa() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _tarefas.add(_controller.text);
        _controller.clear();
        _salvarTarefas();
      });
    }
  }

  void _caregarTarefas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tarefaJson = prefs.getString('tarefas');

    if (tarefaJson != null) {
      setState(() {
        _tarefas.addAll(List<String>.from(json.decode(tarefaJson)));
      });
    }
  }

  void _salvarTarefas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tarefaJson = json.encode(_tarefas);
    await prefs.setString('tarefas', tarefaJson);
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
      _salvarTarefas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Lista de tarefas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                    labelText: 'Digite uma tarefa',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor digite uma tarefa';
                  }

                  if (value.length < 3) {
                    return 'Digite pelo menos 3 caracteres';
                  }
                  return null;
                },
              ),
            ),
          ),
          InkWell(
            onTap: _addTarefa,
            child: Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Center(
                  child: Text(
                'Adicionar',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _tarefas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://startbootstrap.github.io/startbootstrap-one-page-wonder/assets/img/01.jpg'),
                      ),
                      title: Text(_tarefas[index]),
                      subtitle: const Text('Clique na lixeira para remover'),
                      trailing: IconButton(
                        onPressed: () => _removerTarefa(index),
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
