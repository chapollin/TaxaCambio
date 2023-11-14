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
  String moedaDe = 'Dólar Americano';
  String moedaPara = 'Real Brasileiro';
  TextEditingController controladorValor = TextEditingController();
  List<String> historicoConversoes = [];

  final Map<String, String> moedas = {
    'AED': 'Dirham dos Emirados',
    'AFN': 'Afghani do Afeganistão',
    'ALL': 'Lek Albanês',
    'AMD': 'Dram Armênio',
    'ANG': 'Guilder das Antilhas',
    'AOA': 'Kwanza Angolano',
    'ARS': 'Peso Argentino',
    'AUD': 'Dólar Australiano',
    'AZN': 'Manat Azeri',
    'BAM': 'Marco Conversível',
    'BBD': 'Dólar de Barbados',
    'BDT': 'Taka de Bangladesh',
    'BGN': 'Lev Búlgaro',
    'BHD': 'Dinar do Bahrein',
    'BIF': 'Franco Burundinense',
    'BND': 'Dólar de Brunei',
    'BOB': 'Boliviano',
    'BRL': 'Real Brasileiro',
    'BSD': 'Dólar das Bahamas',
    'BTC': 'Bitcoin',
    'BWP': 'Pula de Botswana',
    'BYN': 'Rublo Bielorrusso',
    'BZD': 'Dólar de Belize',
    'CAD': 'Dólar Canadense',
    'CHF': 'Franco Suíço',
    'CHFRTS': 'Franco Suíço',
    'CLP': 'Peso Chileno',
    'CNH': 'Yuan chinês offshore',
    'CNY': 'Yuan Chinês',
    'COP': 'Peso Colombiano',
    'CRC': 'Colón Costarriquenho',
    'CUP': 'Peso Cubano',
    'CVE': 'Escudo cabo-verdiano',
    'CZK': 'Coroa Checa',
    'DJF': 'Franco do Djubouti',
    'DKK': 'Coroa Dinamarquesa',
    'DOGE': 'Dogecoin',
    'DOP': 'Peso Dominicano',
    'DZD': 'Dinar Argelino',
    'EGP': 'Libra Egípcia',
    'ETB': 'Birr Etíope',
    'ETH': 'Ethereum',
    'EUR': 'Euro',
    'FJD': 'Dólar de Fiji',
    'GBP': 'Libra Esterlina',
    'GEL': 'Lari Georgiano',
    'GHS': 'Cedi Ganês',
    'GMD': 'Dalasi da Gâmbia',
    'GNF': 'Franco de Guiné',
    'GTQ': 'Quetzal Guatemalteco',
    'HKD': 'Dólar de Hong Kong',
    'HNL': 'Lempira Hondurenha',
    'HRK': 'Kuna Croata',
    'HTG': 'Gourde Haitiano',
    'HUF': 'Florim Húngaro',
    'IDR': 'Rupia Indonésia',
    'ILS': 'Novo Shekel Israelense',
    'INR': 'Rúpia Indiana',
    'IQD': 'Dinar Iraquiano',
    'IRR': 'Rial Iraniano',
    'ISK': 'Coroa Islandesa',
    'JMD': 'Dólar Jamaicano',
    'JOD': 'Dinar Jordaniano',
    'JPY': 'Iene Japonês',
    'KES': 'Shilling Queniano',
    'KGS': 'Som Quirguistanês',
    'KHR': 'Riel Cambojano',
    'KMF': 'Franco Comorense',
    'KRW': 'Won Sul-Coreano',
    'KWD': 'Dinar Kuwaitiano',
    'KYD': 'Dólar das Ilhas Cayman',
    'KZT': 'Tengue Cazaquistanês',
    'LAK': 'Kip Laosiano',
    'LBP': 'Libra Libanesa',
    'LKR': 'Rúpia de Sri Lanka',
    'LSL': 'Loti do Lesoto',
    'LTC': 'Litecoin',
    'LYD': 'Dinar Líbio',
    'MAD': 'Dirham Marroquino',
    'MDL': 'Leu Moldavo',
    'MGA': 'Ariary Madagascarense',
    'MKD': 'Denar Macedônio',
    'MMK': 'Kyat de Mianmar',
    'MNT': 'Mongolian Tugrik',
    'MOP': 'Pataca de Macau',
    'MRO': 'Ouguiya Mauritana',
    'MUR': 'Rúpia Mauriciana',
    'MVR': 'Rufiyaa Maldiva',
    'MWK': 'Kwacha Malauiana',
    'MXN': 'Peso Mexicano',
    'MYR': 'Ringgit Malaio',
    'MZN': 'Metical de Moçambique',
    'NAD': 'Dólar Namíbio',
    'NGN': 'Naira Nigeriana',
    'NGNI': 'Naira Nigeriana',
    'NGNPARALLEL': 'Naira Nigeriana',
    'NIO': 'Córdoba Nicaraguense',
    'NOK': 'Coroa Norueguesa',
    'NPR': 'Rúpia Nepalesa',
    'NZD': 'Dólar Neozelandês',
    'OMR': 'Rial Omanense',
    'PAB': 'Balboa Panamenho',
    'PEN': 'Sol Peruano',
    'PGK': 'Kina Papuásia',
    'PHP': 'Peso Filipino',
    'PKR': 'Rúpia Paquistanesa',
    'PLN': 'Złoty Polonês',
    'PYG': 'Guarani Paraguaio',
    'QAR': 'Riyal Qatari',
    'RON': 'Leu Romeno',
    'RSD': 'Dinar Sérvio',
    'RUB': 'Rublo Russo',
    'RUBTOD': 'Rublo Russo',
    'RUBTOM': 'Rublo Russo',
    'RWF': 'Franco Ruandês',
    'SAR': 'Riyal Saudita',
    'SCR': 'Rúpia das Seychelles',
    'SDG': 'Libra Sudanêsa',
    'SDR': 'Direitos Especiais de Giro',
    'SEK': 'Coroa Sueca',
    'SGD': 'Dólar de Singapura',
    'SOS': 'Xelim Somali',
    'STD': 'Dobra Santomense',
    'SVC': 'Colón Salvadorenho',
    'SYP': 'Libra Síria',
    'SZL': 'Lilangeni da Suazilândia',
    'THB': 'Baht Tailandês',
    'TJS': 'Somoni do Tajiquistão',
    'TMT': 'Manat Turcomeno',
    'TND': 'Dinar Tunisiano',
    'TRY': 'Lira Turca',
    'TTD': 'Dólar de Trinidad e Tobago',
    'TWD': 'Novo Dólar Taiwanês',
    'TZS': 'Xelim Tanzaniano',
    'UAH': 'Hryvnia Ucraniano',
    'UGX': 'Xelim Ugandense',
    'USD': 'Dólar Americano',
    'USDT': 'Tether',
    'UYU': 'Peso Uruguaio',
    'UZS': 'Som Uzbeque',
    'VEF': 'Bolívar Venezuelano',
    'VND': 'Dong Vietnamita',
    'VUV': 'Vatu de Vanuatu',
    'XAF': 'Franco CFA Central Africano',
    'XAGG': 'Prata (1 onça troy)',
    'XBR': 'Ouro Bruto (1 quilate)',
    'XCD': 'Dólar do Caribe Oriental',
    'XOF': 'Franco CFA da África Ocidental',
    'XPF': 'Franco CFP',
    'XRP': 'Ripple',
    'YER': 'Rial Iemenita',
    'ZAR': 'Rand Sul-Africano',
    'ZMK': 'Kwacha Zambiano',
    'ZWL': 'Dólar do Zimbabwe',
    'XAU': 'Ouro (1 onça troy)',
  };

  @override
  void initState() {
    super.initState();
  }

  Future<void> _converterMoeda() async {
    double valor = double.tryParse(controladorValor.text) ?? 0.0;

    final response = await http.get(Uri.parse(
        'https://economia.awesomeapi.com.br/last/${_nomeParaAbreviacao(moedaDe)}-${_nomeParaAbreviacao(moedaPara)}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      double taxaConversao = double.parse(data[
              '${_nomeParaAbreviacao(moedaDe)}${_nomeParaAbreviacao(moedaPara)}']
          ['bid']);

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

  String _nomeParaAbreviacao(String nome) {
    return moedas.keys
        .firstWhere((key) => moedas[key] == nome, orElse: () => nome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Conversor de Moeda'),
            SizedBox(width: 8),
            Icon(Icons.attach_money),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _construirCampoValor(),
            _construirAutocompleteMoeda('De', moedaDe),
            _construirAutocompleteMoeda('Para', moedaPara),
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
      decoration: InputDecoration(
        labelText: 'Valor',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _construirAutocompleteMoeda(String rotulo, String moedaSelecionada) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return moedas.values
            .where((moeda) => moeda
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            .toList();
      },
      onSelected: (String novaMoeda) {
        setState(() {
          if (rotulo == 'De') {
            moedaDe = novaMoeda;
          } else {
            moedaPara = novaMoeda;
          }
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            labelText: rotulo,
            border: OutlineInputBorder(),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              final moeda = options.toList()[index];
              return ListTile(
                title: Text(moeda),
                onTap: () {
                  onSelected(moeda);
                },
              );
            },
          ),
        );
      },
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
