import 'dart:math';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final _colorPedra = Colors.transparent;
  final _colorPapel = Colors.transparent;
  final _colorTesoura = Colors.transparent;

  List<String> options = ["pedra", "papel", "tesoura"];
  String _message = "Escolha uma opção abaixo";
  String _imagePath = "images/padrao.png";
  List<String> usedImages = [];

  int userScore = 0;
  int computerScore = 0;
  String? lastPlayerChoice;

  void _play(String choice) {
    if (choice == lastPlayerChoice) {
      setState(() {
        _message = "Você não pode escolher o mesmo gesto após um empate.";
      });
      return;
    }

    String randomChoice = _getRandomChoice();
    usedImages.add(randomChoice);
    _updateImagePath(randomChoice);

    if (
      (choice == "pedra" && randomChoice == "tesoura") ||
      (choice == "papel" && randomChoice == "pedra")   ||
      (choice == "tesoura" && randomChoice == "papel") 
    ) {
      setState(() {
        _message = "Parabéns! você ganhou :)";
        userScore++;
      });
      lastPlayerChoice = null;

    } else if (
      (choice == "pedra" && randomChoice == "papel")   ||
      (choice == "papel" && randomChoice == "tesoura") ||
      (choice == "tesoura" && randomChoice == "pedra") 
    ) {
      setState(() {
        _message = "Você perdeu :(";
        computerScore++;
      });
      lastPlayerChoice = null;

    } else {
      setState(() {
        _message = "Empatamos ;)";
      });
      lastPlayerChoice = choice;
    }
  }

  String _getRandomChoice() {
    List<String> remainingOptions = options.where((option) => !usedImages.contains(option)).toList();
    if (remainingOptions.isEmpty) {
      usedImages.clear();
      remainingOptions = options;
    }
    return remainingOptions[Random().nextInt(remainingOptions.length)];
  }

  void _updateImagePath(String choice) {
    setState(() {
      _imagePath = "images/$choice.png";
    });
  }

  void resetAll() {
    setState(() {
      _imagePath = "images/padrao.png";
      _message = "Escolha uma opção abaixo";
      usedImages.clear();
      userScore = 0;
      computerScore = 0;
      lastPlayerChoice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jokenpo"),
        centerTitle: true,
        actions: [IconButton(onPressed: resetAll, icon: const Icon(Icons.refresh))],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 32, bottom: 16),
              child: Text(
                "Escolha do App",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Image(image: AssetImage(_imagePath)),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 16),
              child: Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => _play("pedra"),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: _colorPedra,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: Image.asset("images/pedra.png"),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _play("papel"),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: _colorPapel,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: Image.asset("images/papel.png"),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _play("tesoura"),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: _colorTesoura,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: Image.asset("images/tesoura.png"),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Placar: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Jogador $userScore : $computerScore Computador",
                    style: const TextStyle(fontSize: 19),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
