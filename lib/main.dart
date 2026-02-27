
import 'package:flutter/material.dart';
import 'grpc_client.dart';
import 'models.dart';

void main() {
  runApp(const TexsasPokerApp());
}

class TexsasPokerApp extends StatelessWidget {
  const TexsasPokerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TexSas Poker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E2E),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final client = PokerGrpcClient();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HandEvaluatorScreen(client: client),
      CompareHandsScreen(client: client),
      MonteCarloScreen(client: client),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
            labelType: NavigationRailLabelType.all,
            backgroundColor: Theme.of(context).colorScheme.surface,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.style),
                label: Text('Evaluator'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.compare_arrows),
                label: Text('Compare'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calculate),
                label: Text('Monte Carlo'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}

class HandEvaluatorScreen extends StatefulWidget {
  final PokerGrpcClient client;
  const HandEvaluatorScreen({super.key, required this.client});

  @override
  State<HandEvaluatorScreen> createState() => _HandEvaluatorScreenState();
}

class _HandEvaluatorScreenState extends State<HandEvaluatorScreen> {
  final List<String> hole = [];
  final List<String> community = [];
  String result = '';
  String bestHand = '';
  bool loading = false;

  void _addCard(String card, bool isHole) {
    setState(() {
      if (isHole && hole.length < 2) {
        hole.add(card);
      } else if (!isHole && community.length < 5) {
        community.add(card);
      }
    });
  }

  void _evaluate() async {
    if (hole.length != 2 || community.length != 5) return;
    setState(() => loading = true);
    try {
      final res = await widget.client.evaluateHand(hole, community);
      setState(() {
        result = res.handName;
        bestHand = res.bestHand.join(', ');
        loading = false;
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text('Hand Evaluator', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            _SectionHeader(title: 'Hole Cards (${hole.length}/2)'),
            _CardList(cards: hole, onClear: () => setState(() => hole.clear())),
            const SizedBox(height: 16),
            _SectionHeader(title: 'Community Cards (${community.length}/5)'),
            _CardList(cards: community, onClear: () => setState(() => community.clear())),
            const SizedBox(height: 24),
            _CardPicker(onPick: (c) {
              if (hole.length < 2) _addCard(c, true);
              else if (community.length < 5) _addCard(c, false);
            }),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: (hole.length == 2 && community.length == 5) ? _evaluate : null,
                icon: loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.analytics),
                label: const Text('EVALUATE'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
              ),
            ),
            if (result.isNotEmpty) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(result, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Best 5: $bestHand', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClear;
  const _SectionHeader({required this.title, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (onClear != null) TextButton(onPressed: onClear, child: const Text('Clear')),
      ],
    );
  }
}

class _CardList extends StatelessWidget {
  final List<String> cards;
  final VoidCallback onClear;
  const _CardList({required this.cards, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              itemBuilder: (context, idx) => _CardWidget(cardStr: cards[idx]),
            ),
          ),
          IconButton(onPressed: onClear, icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
        ],
      ),
    );
  }
}

class _CardWidget extends StatelessWidget {
  final String cardStr;
  const _CardWidget({required this.cardStr});

  @override
  Widget build(BuildContext context) {
    final card = PokerCard.fromString(cardStr);
    return Container(
      width: 60,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
      ),
      child: Center(
        child: Text(
          card.displayName,
          style: TextStyle(color: card.suit.color, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}

class CompareHandsScreen extends StatefulWidget {
  final PokerGrpcClient client;
  const CompareHandsScreen({super.key, required this.client});

  @override
  State<CompareHandsScreen> createState() => _CompareHandsScreenState();
}

class _CompareHandsScreenState extends State<CompareHandsScreen> {
  final List<String> p1 = [];
  final List<String> p2 = [];
  final List<String> community = [];
  String result = '';
  String p1Best = '';
  String p2Best = '';
  bool loading = false;

  void _compare() async {
    if (p1.length != 2 || p2.length != 2 || community.length != 5) return;
    setState(() => loading = true);
    try {
      final res = await widget.client.compareHands(p1, p2, community);
      setState(() {
        result = 'Winner: ${res.winner}';
        p1Best = '${res.player1HandName} (${res.player1BestHand.join(", ")})';
        p2Best = '${res.player2HandName} (${res.player2BestHand.join(", ")})';
        loading = false;
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Head-to-Head', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Player 1 (${p1.length}/2)'),
          _CardList(cards: p1, onClear: () => setState(() => p1.clear())),
          const SizedBox(height: 16),
          _SectionHeader(title: 'Player 2 (${p2.length}/2)'),
          _CardList(cards: p2, onClear: () => setState(() => p2.clear())),
          const SizedBox(height: 16),
          _SectionHeader(title: 'Community (${community.length}/5)'),
          _CardList(cards: community, onClear: () => setState(() => community.clear())),
          const SizedBox(height: 24),
          _CardPicker(onPick: (c) {
            if (p1.length < 2) setState(() => p1.add(c));
            else if (p2.length < 2) setState(() => p2.add(c));
            else if (community.length < 5) setState(() => community.add(c));
          }),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
              onPressed: (p1.length == 2 && p2.length == 2 && community.length == 5) ? _compare : null,
              icon: loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.compare),
              label: const Text('COMPARE'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            ),
          ),
          if (result.isNotEmpty) ...[
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(result, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text('P1: $p1Best', style: Theme.of(context).textTheme.bodyLarge),
                  Text('P2: $p2Best', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MonteCarloScreen extends StatefulWidget {
  final PokerGrpcClient client;
  const MonteCarloScreen({super.key, required this.client});

  @override
  State<MonteCarloScreen> createState() => _MonteCarloScreenState();
}

class _MonteCarloScreenState extends State<MonteCarloScreen> {
  final List<String> hole = [];
  final List<String> community = [];
  int players = 2;
  int simulations = 10000;
  String result = '';
  bool loading = false;

  void _run() async {
    if (hole.length != 2) return;
    setState(() => loading = true);
    try {
      final res = await widget.client.getProbabilities(hole, community, players, simulations);
      setState(() {
        result = 'Win Probability: ${(res.winProbability * 100).toStringAsFixed(2)}%';
        loading = false;
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monte Carlo Simulation', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Hole Cards (${hole.length}/2)'),
          _CardList(cards: hole, onClear: () => setState(() => hole.clear())),
          const SizedBox(height: 16),
          _SectionHeader(title: 'Known Community (${community.length}/5 max)'),
          _CardList(cards: community, onClear: () => setState(() => community.clear())),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _IntPicker(
                  label: 'Players',
                  value: players,
                  min: 2,
                  max: 9,
                  onChanged: (v) => setState(() => players = v),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _IntPicker(
                  label: 'Simulations',
                  value: simulations,
                  min: 1000,
                  max: 100000,
                  step: 1000,
                  onChanged: (v) => setState(() => simulations = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _CardPicker(onPick: (c) {
            if (hole.length < 2) setState(() => hole.add(c));
            else if (community.length < 5) setState(() => community.add(c));
          }),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
              onPressed: (hole.length == 2) ? _run : null,
              icon: loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.flash_on),
              label: const Text('SIMULATE'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            ),
          ),
          if (result.isNotEmpty) ...[
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo.shade900, Colors.deepPurple.shade900]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)],
              ),
              child: Center(
                child: Text(result, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IntPicker extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  const _IntPicker({required this.label, required this.value, required this.min, required this.max, this.step = 1, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        Row(
          children: [
            IconButton(onPressed: (value > min) ? () => onChanged(value - step) : null, icon: const Icon(Icons.remove)),
            Text('$value', style: Theme.of(context).textTheme.titleLarge),
            IconButton(onPressed: (value < max) ? () => onChanged(value + step) : null, icon: const Icon(Icons.add)),
          ],
        ),
      ],
    );
  }
}
