import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _tarefas = [];

  void _addTarefa() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tarefas.add(_controller.text);
        _controller.clear();
      });
    }
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
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
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  labelText: 'Digite uma tarefa', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: _addTarefa,
            child: Container(
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
