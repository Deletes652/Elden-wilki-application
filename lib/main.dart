// main.dart
// Flutter 3.x
// แอปสำหรับเกมเมอร์: แนะนำ Monster, Bounty, Ability + รูปภาพ + รีวิว (3 หน้า)
// ธีมดำ-ทอง สไตล์ Elden Ring พร้อมแอนิเมชันสวยงาม ทั้งหมดจบไฟล์เดียว

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:typed_data';

void main() {
  runApp(const GamerCompanionApp());
}

/// --------------------------- THEME & APP ROOT ------------------------------

class GamerCompanionApp extends StatefulWidget {
  const GamerCompanionApp({Key? key}) : super(key: key);

  @override
  State<GamerCompanionApp> createState() => _GamerCompanionAppState();
}

class _GamerCompanionAppState extends State<GamerCompanionApp> {
  late final AppStore store;

  @override
  void initState() {
    super.initState();
    store = AppStore.bootstrap(); // เตรียมข้อมูลตัวละคร 10 ตัว
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elden Ledger',
        theme: _eldenTheme,
        home: const HomePage(),
      ),
    );
  }
}

final ThemeData _eldenTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0D0D0F), // ดำเข้มอมฟ้า
  primaryColor: const Color(0xFFB9891E), // ทองเข้ม
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFFB9891E),
    secondary: const Color(0xFFD8C27A),
    surface: const Color(0xFF121214),
    onSurface: const Color(0xFFE9E3CE),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamilyFallback: ['Georgia', 'Times New Roman'],
      fontSize: 40,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    ),
    titleLarge: TextStyle(
      fontFamilyFallback: ['Georgia', 'Times New Roman'],
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 1.4,
      letterSpacing: 0.2,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamilyFallback: ['Georgia', 'Times New Roman'],
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Color(0xFFD8C27A),
      letterSpacing: 1.2,
    ),
  ),
);

/// ------------------------------- DATA LAYER --------------------------------

class Character {
  final int id;
  String name;
  String title; // ฉายา/สังกัด
  String imageUrl; // ให้ผู้ใช้แก้เป็น URL รูปได้
  String monster;
  String bounty;
  String ability;

  Character({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.monster,
    required this.bounty,
    required this.ability,
  });
}

class CommentItem {
  final int characterId;
  final String text;
  final DateTime createdAt;
  CommentItem({
    required this.characterId,
    required this.text,
    required this.createdAt,
  });
}

class AppStore extends ChangeNotifier {
  final List<Character> characters;
  final List<CommentItem> comments;

  AppStore({required this.characters, required this.comments});

  static AppStore bootstrap() {
    // รายชื่อไฟล์รูปภาพใน assets/images
    final List<String> imageAssets = [
      'assets/images/malenia.jpg',      // 0
      'assets/images/radahn.jpg',       // 1
      'assets/images/malikate.jpg',     // 2
      'assets/images/rellana.jpg',      // 3
      'assets/images/morgott.jpg',      // 4
      'assets/images/mesmer.jpg',       // 5
      'assets/images/midra.jpg',        // 6
      'assets/images/parsidusax.jpg',   // 7
      'assets/images/radagon.jpg',      // 8
      'assets/images/Elden lord.png',   // 9
    ];

    final List<String> names = [
      'Malenia', 'Radahn', 'Maliketh', 'Rellana', 'Morgott',
      'Mesmer', 'Midra', 'Placidusax', 'Radagon', 'Elden Lord'
    ];

    final List<String> titles = [
      'Blade of Miquella',
      'Scourge of the Stars',
      'The Black Blade',
      'Twin Moon Knight',
      'The Omen King',
      'Lord of Frenzied Flame',
      'Queen of the Full Moon',
      'Dragonlord',
      'Golden Order',
      'First Elden Lord'
    ];

    final List<String> monsters = [
      'เทพนักรบหญิงผู้ไร้พ่าย มีแขนกลและดาบศักดิ์สิทธิ์',
      'ขุนพลผู้ควบคุมพลังแรงโน้มถ่วงและขี่ม้า Leonard',
      'สัตว์ร้ายแห่งความตาย ผู้ถือดาบแห่ง Destined Death',
      'อัศวินจันทราคู่แฝด ผู้ใช้เวทมนตร์แห่งดวงจันทร์',
      'ราชาแห่ง Omen ผู้ถูกสาปและปกครอง Leyndell',
      'จอมเวทแห่งไฟคลั่ง ผู้ปลุกพลังแห่ง Frenzied Flame',
      'ราชินีแห่งดวงจันทร์ ผู้ใช้เวทมนตร์ Lunar',
      'มังกรโบราณผู้ครองพลังสายฟ้าและเวลา',
      'เทพแห่ง Golden Order ผู้ใช้เวทมนตร์ศักดิ์สิทธิ์',
      'เจ้าแห่ง Elden Ring ผู้ปกครอง Lands Between'
    ];

    final List<String> bounties = [
      'Remembrance of Malenia + Scarlet Aeonia • ได้รับจากการปราบ Malenia',
      'Remembrance of the Starscourge + Radahn\'s Great Rune • ได้รับจากการปราบ Radahn',
      'Remembrance of the Black Blade + Maliketh\'s Black Blade • ได้รับจากการปราบ Maliketh',
      'Remembrance of the Twin Moon + Rellana\'s Moonblade • ได้รับจากการปราบ Rellana',
      'Remembrance of the Omen King + Morgott\'s Cursed Sword • ได้รับจากการปราบ Morgott',
      'Remembrance of the Frenzied Flame + Mesmer\'s Staff • ได้รับจากการปราบ Mesmer',
      'Remembrance of the Full Moon + Midra\'s Moonlight Staff • ได้รับจากการปราบ Midra',
      'Remembrance of the Dragonlord + Placidusax\'s Ruin • ได้รับจากการปราบ Placidusax',
      'Remembrance of the Golden Order + Radagon\'s Hammer • ได้รับจากการปราบ Radagon',
      'Remembrance of the Elden Lord + Elden Lord\'s Crown • ได้รับจากการปราบ Elden Lord'
    ];

    final List<String> abilities = [
      'Waterfowl Dance, Scarlet Rot, Goddess of Rot',
      'Gravity Magic, Starcaller Cry, Colossal Strength',
      'Destined Death, Black Blade, High Mobility',
      'Moonlight Magic, Twin Swords, Lunar Barrage',
      'Cursed Blood, Royal Omen, Sword Mastery',
      'Frenzied Flame, Madness Spells, Pyromancy',
      'Lunar Magic, Moonlight Staff, Arcane Power',
      'Ancient Dragon Powers, Time Manipulation, Lightning',
      'Holy Magic, Hammer of Order, Light Manipulation',
      'Elden Power, Divine Protection, Supreme Authority'
    ];

    final List<Character> chars = List.generate(10, (i) {
      return Character(
        id: i + 1,
        name: names[i],
        title: titles[i],
        imageUrl: imageAssets[i],
        monster: monsters[i],
        bounty: bounties[i],
        ability: abilities[i],
      );
    });
    return AppStore(characters: chars, comments: []);
  }

  Character byId(int id) =>
      characters.firstWhere((c) => c.id == id, orElse: () {
        throw Exception('Character with id $id not found');
      });

  void updateCharacter({
    required int id,
    String? name,
    String? title,
    String? imageUrl,
    String? monster,
    String? bounty,
    String? ability,
  }) {
    final c = byId(id);
    if (name != null && name.isNotEmpty) c.name = name;
    if (title != null && title.isNotEmpty) c.title = title;
    if (imageUrl != null) c.imageUrl = imageUrl;
    if (monster != null) c.monster = monster;
    if (bounty != null) c.bounty = bounty;
    if (ability != null) c.ability = ability;
    notifyListeners();
  }

  List<CommentItem> commentsOf(int characterId) =>
      comments.where((e) => e.characterId == characterId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void addComment(int characterId, String text) {
    comments.add(CommentItem(
      characterId: characterId,
      text: text.trim(),
      createdAt: DateTime.now(),
    ));
    notifyListeners();
  }
}

/// Simple InheritedWidget สำหรับแชร์ AppStore ทั่วแอป (ไม่ใช้แพ็กเกจเสริม)
class AppScope extends InheritedNotifier<AppStore> {
  const AppScope({Key? key, required AppStore store, required Widget child})
      : super(key: key, notifier: store, child: child);

  static AppStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

/// ------------------------------- WIDGETS -----------------------------------

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineCtrl;

  @override
  void initState() {
    super.initState();
    _shineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _shineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elden Ledger'),
      ),
      body: Stack(
        children: [
          const _ArcaneBackdrop(),
          Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SectionHeader(
                  icon: Icons.shield_moon_outlined,
                  title: 'Tarnished Roster',
                  subtitle: 'แตะเพื่อดูรายละเอียด',
                  animation: _shineCtrl,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: AnimatedBuilder(
                  animation: store,
                  builder: (_, __) {
                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: store.characters.length,
                      itemBuilder: (context, index) {
                        final c = store.characters[index];
                        return _CharacterTile(
                          character: c,
                          onTap: () => _openDetail(context, c),
                          onLongPress: null, // ไม่อนุญาตให้เปลี่ยนรูป
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, Character c) {
    Navigator.of(context).push(_eldTransition(DetailPage(characterId: c.id)));
  }
}

class DetailPage extends StatelessWidget {
  final int characterId;
  const DetailPage({Key? key, required this.characterId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final c = store.byId(characterId);
    return Scaffold(
      appBar: AppBar(
        title: Text('${c.name} • Detail'),
        leading: const _GoldBackButton(),
      ),
      body: Stack(
        children: [
          const _ArcaneBackdrop(),
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _HeroPortrait(character: c),
              const SizedBox(height: 16),
              _InfoCard(
                title: c.name,
                subtitle: c.title,
                onEdit: () => _editNameTitle(context, c),
              ),
              const SizedBox(height: 12),
              _InfoSection(
                label: 'MONSTER',
                text: c.monster,
                onEdit: () => _editField(context, c, 'MONSTER', c.monster,
                    (v) => store.updateCharacter(id: c.id, monster: v)),
              ),
              _InfoSection(
                label: 'BOUNTY',
                text: c.bounty,
                onEdit: () => _editField(context, c, 'BOUNTY', c.bounty,
                    (v) => store.updateCharacter(id: c.id, bounty: v)),
              ),
              _InfoSection(
                label: 'ABILITY',
                text: c.ability,
                onEdit: () => _editField(context, c, 'ABILITY', c.ability,
                    (v) => store.updateCharacter(id: c.id, ability: v)),
              ),
              const SizedBox(height: 16),
              _ReviewButton(
                onPressed: () {
                  Navigator.of(context).push(_eldTransition(
                    ReviewsPage(characterId: c.id),
                  ));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editNameTitle(BuildContext context, Character c) async {
    final store = AppScope.of(context);
    final nameCtrl = TextEditingController(text: c.name);
    final titleCtrl = TextEditingController(text: c.title);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => _GoldDialog(
        title: 'แก้ไขชื่อ/ฉายา',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        confirmText: 'บันทึก',
      ),
    );
    if (ok == true) {
      store.updateCharacter(id: c.id, name: nameCtrl.text, title: titleCtrl.text);
    }
  }

  Future<void> _editField(
    BuildContext context,
    Character c,
    String label,
    String initial,
    void Function(String) onSave,
  ) async {
    final ctrl = TextEditingController(text: initial);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => _GoldDialog(
        title: 'แก้ไข $label',
        child: TextField(
          controller: ctrl,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        confirmText: 'บันทึก',
      ),
    );
    if (ok == true) onSave(ctrl.text);
  }
}

class ReviewsPage extends StatefulWidget {
  final int characterId;
  const ReviewsPage({Key? key, required this.characterId}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final c = store.byId(widget.characterId);
    final comments = store.commentsOf(widget.characterId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews • ${c.name}'),
        leading: const _GoldBackButton(),
      ),
      body: Stack(
        children: [
          const _ArcaneBackdrop(),
          Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SectionHeader(
                  icon: Icons.menu_book_outlined,
                  title: 'คอมเมนต์ทั้งหมด',
                  subtitle: 'อ่าน/เพิ่มความเห็นเกี่ยวกับตัวละครนี้',
                  animation: null,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: AnimatedBuilder(
                  animation: store,
                  builder: (_, __) {
                    if (comments.isEmpty) {
                      return const _EmptyState(
                        title: 'ยังไม่มีความคิดเห็น',
                        subtitle: 'เป็นคนแรกที่ฝากคำวิจารณ์ต่อ Tarnished ผู้นี้',
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                      itemCount: comments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final cm = comments[i];
                        return _CommentTile(item: cm);
                      },
                    );
                  },
                ),
              ),
              _ReviewComposer(
                controller: _controller,
                onSubmit: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;
                  store.addComment(widget.characterId, text);
                  _controller.clear();
                  FocusScope.of(context).unfocus();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------- UI PIECES ---------------------------------

class _CharacterTile extends StatefulWidget {
  final Character character;
  final VoidCallback onTap;
  final VoidCallback? onLongPress; // เปลี่ยนเป็น nullable
  const _CharacterTile({
    Key? key,
    required this.character,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<_CharacterTile> createState() => _CharacterTileState();
}

class _CharacterTileState extends State<_CharacterTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverCtrl;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.character;
    final hasImage = (c.imageUrl).trim().isNotEmpty;

    ImageProvider getImage(String url) {
      if (url.startsWith('assets/images/')) {
        return AssetImage(url);
      }
      return NetworkImage(url);
    }

    return MouseRegion(
      onEnter: (_) => _hoverCtrl.forward(),
      onExit: (_) => _hoverCtrl.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedBuilder(
          animation: _hoverCtrl,
          builder: (_, __) {
            final scale = 1.0 + (_hoverCtrl.value * 0.02);
            return Transform.scale(
              scale: scale,
              child: Container(
                decoration: _goldenCardDecoration,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: hasImage
                            ? Hero(
                                tag: 'portrait_${c.id}',
                                child: FadeInImage(
                                  placeholder: const AssetImagePlaceholder().image,
                                  image: getImage(c.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : _EmptyImageSlot(id: c.id),
                      ),
                    ),
                    Positioned.fill(child: _GoldEdgeGlow(opacity: 0.25)),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: _GoldenLabel(
                        title: c.name,
                        subtitle: c.title,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroPortrait extends StatelessWidget {
  final Character character;
  const _HeroPortrait({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasImage = character.imageUrl.trim().isNotEmpty;

    ImageProvider getImage(String url) {
      if (url.startsWith('assets/images/')) {
        return AssetImage(url);
      }
      return NetworkImage(url);
    }

    return Container(
      height: 260,
      decoration: _goldenCardDecoration,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: hasImage
                  ? Hero(
                      tag: 'portrait_${character.id}',
                      child: FadeInImage(
                        placeholder: const AssetImagePlaceholder().image,
                        image: getImage(character.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    )
                  : _EmptyImageSlot(id: character.id),
            ),
          ),
          Positioned.fill(child: _GoldEdgeGlow(opacity: 0.25)),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: _GoldenLabel(
              title: character.name,
              subtitle: character.title,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  const _InfoCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: _panelDecoration,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.person_outline),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.titleLarge!
                        .copyWith(color: theme.colorScheme.onSurface)),
                const SizedBox(height: 2),
                Text(subtitle, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          _GoldIconButton(
            icon: Icons.edit_outlined,
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String label;
  final String text;
  final VoidCallback onEdit;
  const _InfoSection({
    Key? key,
    required this.label,
    required this.text,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: _panelDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTag(text: label),
          const SizedBox(height: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium!
                .copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _GoldTextButton(
              text: 'แก้ไข $label',
              onPressed: onEdit,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _ReviewButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<_ReviewButton> createState() => _ReviewButtonState();
}

class _ReviewButtonState extends State<_ReviewButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = (sin(_ctrl.value * pi) + 1) / 2;
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color.lerp(const Color(0xFFB9891E), const Color(0xFFD8C27A), t),
              foregroundColor: Colors.black,
              elevation: 8,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFD8C27A), width: 1),
              ),
            ),
            onPressed: widget.onPressed,
            icon: const Icon(Icons.reviews_outlined),
            label: const Text(
              'อ่านรีวิว / เขียนคอมเมนต์',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
            ),
          ),
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentItem item;
  const _CommentTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: _panelDecoration,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.account_circle_outlined, size: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fmtDate(item.createdAt),
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.secondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                Text(item.text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  const _ReviewComposer({
    Key? key,
    required this.controller,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D0D0F), Color(0xFF1A1A1D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: const Border(
            top: BorderSide(color: Color(0xFF4B3A14), width: 1),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'พิมพ์ความคิดเห็น...',
                  filled: true,
                  fillColor: const Color(0xFF141416),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: (_) => onSubmit(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _eldenTheme.primaryColor,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final AnimationController? animation;
  const _SectionHeader({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmer =
        animation?.drive(Tween<double>(begin: 0, end: 1)) ?? kAlwaysCompleteAnimation;
    return AnimatedBuilder(
      animation: shimmer,
      builder: (_, __) {
        final t = shimmer.value;
        return Container(
          decoration: _panelDecoration,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.secondary),
              const SizedBox(width: 10),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (rect) => LinearGradient(
                    colors: const [
                      Color(0xFFD8C27A),
                      Color(0xFFB9891E),
                      Color(0xFFD8C27A),
                    ],
                    stops: [max(0.0, t - 0.2), t, min(1.0, t + 0.2)],
                  ).createShader(rect),
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: theme.colorScheme.secondary),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTag extends StatelessWidget {
  final String text;
  const _SectionTag({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1B160A),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF6A5420), width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          letterSpacing: 2,
          fontWeight: FontWeight.w700,
          color: Color(0xFFD8C27A),
        ),
      ),
    );
  }
}

class _GoldBackButton extends StatelessWidget {
  const _GoldBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'ย้อนกลับ',
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => Navigator.of(context).maybePop(),
    );
  }
}

class _GoldDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final String confirmText;
  const _GoldDialog({
    Key? key,
    required this.title,
    required this.child,
    required this.confirmText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF141416),
      title: Text(title),
      content: child,
      actions: [
        TextButton(
          child: const Text('ยกเลิก'),
          onPressed: () => Navigator.pop(context, false),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

class _GoldTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _GoldTextButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.edit_outlined, size: 18),
      label: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFD8C27A),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GoldIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _GoldIconButton({Key? key, required this.icon, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onPressed,
      radius: 24,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B160A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF6A5420)),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: const Color(0xFFD8C27A)),
      ),
    );
  }
}

class _GoldenLabel extends StatelessWidget {
  final String title;
  final String subtitle;
  const _GoldenLabel({Key? key, required this.title, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xC0141416),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6A5420)),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 8, spreadRadius: -2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge!
                  .copyWith(color: const Color(0xFFD8C27A))),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                theme.textTheme.bodyMedium!.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _EmptyImageSlot extends StatelessWidget {
  final int id;
  const _EmptyImageSlot({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111113),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.photo_outlined,
              size: 44, color: Color(0xFFD8C27A)),
          const SizedBox(height: 8),
          Text('ไม่มีรูป (#$id)',
              style:
                  const TextStyle(color: Color(0xFFD8C27A), letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _GoldEdgeGlow extends StatelessWidget {
  final double opacity;
  const _GoldEdgeGlow({Key? key, required this.opacity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: RadialGradient(
            colors: [
              const Color(0x00D8C27A),
              const Color(0x33D8C27A).withOpacity(opacity),
            ],
            radius: 1.0,
            center: Alignment.topLeft,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyState({Key? key, required this.title, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: _panelDecoration,
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 44, color: Color(0xFFD8C27A)),
            const SizedBox(height: 10),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: const Color(0xFFD8C27A))),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcaneBackdrop extends StatelessWidget {
  const _ArcaneBackdrop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ฉากหลังลายหมอกทอง + เส้นขีดพลังงานจางๆ
    return CustomPaint(
      painter: _ArcanePainter(),
      size: Size.infinite,
    );
  }
}

class _ArcanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0D0D0F), Color(0xFF151518)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final rnd = Random(42);
    final spark = Paint()
      ..color = const Color(0x22D8C27A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    for (int i = 0; i < 40; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), rnd.nextDouble() * 2 + 0.5, spark);
    }

    final line = Paint()
      ..color = const Color(0x334B3A14)
      ..strokeWidth = 1;
    for (int i = 0; i < 10; i++) {
      final y = (i + 1) * size.height / 12;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ------------------------------ DECORATIONS --------------------------------

final BoxDecoration _goldenCardDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: const Color(0xFF6A5420), width: 1),
  boxShadow: const [
    BoxShadow(color: Colors.black87, blurRadius: 16, offset: Offset(0, 8)),
  ],
);

final BoxDecoration _panelDecoration = BoxDecoration(
  color: const Color(0x12141416),
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: const Color(0xFF4B3A14), width: 1),
  boxShadow: const [
    BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 6)),
  ],
);

/// ----------------------------- UTILITIES -----------------------------------

PageRouteBuilder _eldTransition(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 550),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, animation, secondaryAnimation) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.98, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        ),
        child: page,
      ),
    ),
  );
}

String _fmtDate(DateTime dt) {
  // รูปแบบ: 13 Aug 2025 • 22:14
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final m = months[dt.month - 1];
  String two(int v) => v.toString().padLeft(2, '0');
  return '${dt.day} $m ${dt.year} • ${two(dt.hour)}:${two(dt.minute)}';
}

/// รูป placeholder แบบโปร่งแสง (ป้องกันกระพริบ)
class AssetImagePlaceholder {
  const AssetImagePlaceholder();
  ImageProvider get image => MemoryImage(_transparentPng1x1);
}

// 1x1 transparent PNG
final Uint8List _transparentPng1x1 = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x60, 0x00, 0x00, 0x00,
  0x02, 0x00, 0x01, 0xE5, 0x27, 0xD4, 0xA0, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

/// แอนิเมชันตัวช่วยเพื่อให้ ShaderMask ทำงานแม้ไม่มีคอนโทรลเลอร์
class _AlwaysCompleteAnimation extends Animation<double> {
  const _AlwaysCompleteAnimation();
  @override
  void addListener(VoidCallback listener) {}
  @override
  void addStatusListener(AnimationStatusListener listener) {}
  @override
  void removeListener(VoidCallback listener) {}
  @override
  void removeStatusListener(AnimationStatusListener listener) {}
  @override
  AnimationStatus get status => AnimationStatus.completed;
  @override
  double get value => 1.0;
}

const kAlwaysCompleteAnimation = _AlwaysCompleteAnimation();
