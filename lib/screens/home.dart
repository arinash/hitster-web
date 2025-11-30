import 'package:flutter/material.dart';
import 'package:hitster/elements/styled_button.dart';

class Home extends StatelessWidget {
  const Home({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          const SizedBox(height: 48),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Угадай песню!',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'SwankyAndMooMooCyrillic',
                    color: Color(0xFF2B5FC7),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'ХИТСТЕР',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SwankyAndMooMooCyrillic',
                    color: Color(0xFF2B5FC7),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(
                    'assets/images/bg.png',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: StyledButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/play');
                },
                child: const Text('ИГРАТЬ',
                  style: TextStyle(fontWeight: FontWeight.bold)
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50, left:50, bottom: 50),
            child: SizedBox(
              width: double.infinity,
              child: StyledButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/rules');
                },
                child: const Text('ПРАВИЛА', 
                  style: TextStyle(fontWeight: FontWeight.bold)
                )
              ),
            ),
          ),
            ],
          ),
        ],
      ),
    );
  }
}