import 'package:flutter/material.dart';
import 'package:hitster/elements/rule_card.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Правила игры', style: TextStyle(
          fontFamily: 'SwankyAndMooMooCyrillic',
          color:  Colors.white,
        ),),
        backgroundColor: Color(0xFF2B5FC7),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // intro paragraph and the rest of the content
                const Text(
                  'Угадывай, когда была выпущена каждая песня.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2B5FC7)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Подготовка',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2B5FC7)),
                ),
                _buildNumberedRule(1, 'Решите, будете вы играть в команде или индивидуально.'),
                _buildNumberedRule(2, 'Каждый игрок или команда получает 2 жетона ХИТСТЕР и 1 музыкальную карту, которую они кладут лицевой стороной вверх (стороной с датой), чтобы начать свою временную шкалу.'),
                _buildNumberedRule(3, 'Выберете c чьего телефона будет играть музыка (необходимо наличие Spotify Premium).'),
                const Text(
                  'Правила игры',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2B5FC7)),
                ),
                const SizedBox(height: 12),
                RuleCard(header: 'Сканируй', iconAsset: 'assets/images/scan.png', rule: 'Диджей сканирует карту с помощью приложения ХИТСТЕР. Затем начинает играть песня. Песня будет видна на экране, поэтому диджей должен спрятать экран телефона от угадывающей команды.'),
                const SizedBox(height: 12),
                RuleCard(header: 'Клади карточку', iconAsset: 'assets/images/guess.png', rule: 'Угадывающая команда кладёт карту лицевой стороной вниз (не глядя на нижнюю сторону) в нужное место на временной шкале. Карточка должна располагаться слева, справа или между другими музыкальными карточками, при этом самая старая песня должна быть слева.'),
                const SizedBox(height: 12),
                RuleCard(header: 'Переворачивай карточку', iconAsset: 'assets/images/guessed.png', rule: 'Перед тем, как переворачивать карту, спроси у других игроков, нет ли возражений. Теперь переворачивай карту с музыкой: если карта находится в правильном положении, игрок может её оставить. В противном случае карта должна быть сброшена, если только другой игрок не разместил свой жетон ХИТСТЕР правильно (см. «Жетон ХИТСТЕР ниже). Карты с одинаковым годом выпуска можно размещать в любом порядке, даже если одна из песен была выпущена ранее в том же году. Затем диджей включает новую песню, и ход переходит к следующему игроку.'),
                const SizedBox(height: 12),
                RuleCard(header: 'Выигрывай', iconAsset: 'assets/images/win.png', rule: 'Игра продолжается по часовой стрелке, пока один из игроков не выложит 10 карт в правильном порядке на свою временную шкалу или пока не надоест.'),
                const SizedBox(height: 24),
                const Text(
                  'Жетон ХИТСТЕР',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2B5FC7)),
                ),
                const SizedBox(height: 16),
                RuleCard(header: 'Твой ход', iconAsset: 'assets/images/coinsLoose.png', rule: 'Если ты не знаешь песню, заплати один жетон ХИТСТЕР и отсканируй новую песню. Верни жетон и карту в коробку.'),
                const SizedBox(height: 12),
                RuleCard(header: 'Ход другого игрока', iconAsset: 'assets/images/coinsAdd.png', rule: 'Думаешь, ты знаешь лучше и другой игрок неправильно разместил карту? Уточни у угадывающей команды, приняли ли они окончательное решение. Затем помести один из своих жетонов на временную шкалу оппонента на то место, где, по твоему мнению, должна находиться карта. Если ты угадал, то карта твоя и ты можешь поместить её на правильное место на твоей временной шкале. Верни использованный жетон в коробку. Если несколько игроков одновременно положили свой жетон на одно и то же место на временной шкале оппонента, игроки должны назвать предполагаемый год. Карточку получит игрок, назвавший наиболее близкий год.'),
                const SizedBox(height: 12),
                RuleCard(header: 'Угадай название и исполнителя', iconAsset: 'assets/images/coinsAdd.png', rule: 'Если сейчас твой ход, ты можешь получить жетон ХИТСТЕР, правильно угадав название песни и имя исполнителя. Ты всё ещё получишь жетон, если неправильно разместишь карту на временной шкале.'),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedRule(int number, String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              rule,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}