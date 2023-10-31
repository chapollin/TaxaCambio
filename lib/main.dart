import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Moeda',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConversorMoeda(),
    );
  }
}

class ConversorMoeda extends StatefulWidget {
  @override
  _ConversorMoedaState createState() => _ConversorMoedaState();
}

class _ConversorMoedaState extends State<ConversorMoeda> {
  String moedaDe = 'USD';
  String moedaPara = 'BRL';
  TextEditingController controladorValor = TextEditingController();
  List<String> historicoConversoes = [];

  Future<void> _converterMoeda() async {
    double valor = double.tryParse(controladorValor.text) ?? 0.0;

    final response = await http.get(Uri.parse(
        'https://economia.awesomeapi.com.br/last/$moedaDe-$moedaPara'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      double taxaConversao = double.parse(data['$moedaDe$moedaPara']['bid']);

      double resultado = valor * taxaConversao;

      String resultadoFormatado =
          '$valor $moedaDe = ${resultado.toStringAsFixed(2)} $moedaPara';

      setState(() {
        historicoConversoes.insert(0, resultadoFormatado);
      });
    } else {
      throw Exception('Falha ao carregar as taxas de câmbio');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Moeda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _construirCampoValor(),
            _construirDropdownMoeda('De', moedaDe),
            _construirDropdownMoeda('Para', moedaPara),
            _construirBotaoConverter(),
            _construirHistoricoConversoes(),
          ],
        ),
      ),
    );
  }

  Widget _construirCampoValor() {
    return TextField(
      controller: controladorValor,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Valor'),
    );
  }

  Widget _construirDropdownMoeda(String rotulo, String moedaSelecionada) {
    return DropdownButton<String>(
      value: moedaSelecionada,
      onChanged: (String? novaMoeda) {
        setState(() {
          if (rotulo == 'De') {
            moedaDe = novaMoeda!;
          } else {
            moedaPara = novaMoeda!;
          }
        });
      },
      items: [
        'USD',
        'EUR',
        'BRL',
        'BTC'
      ] // Adicione mais moedas conforme necessário
          .map<DropdownMenuItem<String>>((String valor) {
        return DropdownMenuItem<String>(
          value: valor,
          child: Text(valor),
        );
      }).toList(),
      hint: Text(rotulo),
    );
  }

  Widget _construirBotaoConverter() {
    return ElevatedButton(
      onPressed: _converterMoeda,
      child: Text('Converter'),
    );
  }

  Widget _construirHistoricoConversoes() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Histórico de Conversões',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: historicoConversoes.length,
              itemBuilder: (context, indice) {
                return ListTile(
                  title: Text(historicoConversoes[indice]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
