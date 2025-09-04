import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'edit_profile.dart';
import 'settings.dart';
import 'package:provider/provider.dart';
import 'profile_model.dart';

void main() {
  runApp(const ProfileDemoApp());
}

class ProfileDemoApp extends StatelessWidget {
  const ProfileDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Screen',
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'SF Pro',
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool onDuty = true;

  Future<void> _confirmLogout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/editProfile');
            },
            child: const Text("Edit Profile"),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (confirmed == true) {
      // Exit the application
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double w = size.width;

    final double avatarSize = w * 0.34;
    final double nameFont = w * 0.05;
    final double tileHeight = w * 0.14;
    final double tileIcon = w * 0.060;
    final double tileText = w * 0.045;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          children: [
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [

                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundImage: context.watch<ProfileModel>().avatarImage,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.watch<ProfileModel>().name,
                    style: TextStyle(
                      fontSize: nameFont,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),


                  _OnDutyPill(
                    value: onDuty,
                    label: 'On-Duty',
                    onChanged: (v) => setState(() => onDuty = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _ShadowSeparator(),
            const SizedBox(height: 18),


            _MenuButton(
              icon: Icons.person_outline,
              label: 'Edit Profile',
              height: tileHeight,
              iconSize: tileIcon,
              textSize: tileText,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
            _MenuButton(
              icon: Icons.receipt_long,
              label: 'Transactions',
              height: tileHeight,
              iconSize: tileIcon,
              textSize: tileText,
              onTap: () {},
            ),
            _MenuButton(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Wallet',
              height: tileHeight,
              iconSize: tileIcon,
              textSize: tileText,
              onTap: () {},
            ),
            _MenuButton(
              icon: Icons.settings_outlined,
              label: 'Settings',
              height: tileHeight,
              iconSize: tileIcon,
              textSize: tileText,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            _MenuButton(
              icon: Icons.logout_rounded,
              label: 'Log Out',
              height: tileHeight,
              iconSize: tileIcon,
              textSize: tileText,
              onTap: _confirmLogout,
            ),
            SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}

class _OnDutyPill extends StatefulWidget {
  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;
  const _OnDutyPill({required this.value, required this.label, this.onChanged});

  @override
  State<_OnDutyPill> createState() => _OnDutyPillState();
}

class _OnDutyPillState extends State<_OnDutyPill> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant _OnDutyPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {

    const Color onColor = Color(0xFF0F3F7F);
    const Color offColor = Color(0xFFCBD5E1);

    return GestureDetector(
      onTap: () {
        setState(() => _value = !_value);
        widget.onChanged?.call(_value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: 140,
        height: 42,
        decoration: BoxDecoration(
          color: _value ? onColor : offColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(color: Color(0x26000000), blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Stack(
          children: [

            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: Text(
                  _value ? 'On-Duty' : 'Off-Duty',
                  key: ValueKey<bool>(_value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),


            AnimatedAlign(
              alignment: _value ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0x33000000)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.height,
    this.iconSize,
    this.textSize,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final double? height;
  final double? iconSize;
  final double? textSize;

  static const Color tileColor = Color(0xFFA9C3FF);
  static const Color tileBorder = Color(0xFF0F3F7F);

  @override
  Widget build(BuildContext context) {

    final double effectiveHeight = height ?? 90;
    final double effectiveIcon = iconSize ?? 32;
    final double effectiveText = textSize ?? 28;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Ink(
          height: effectiveHeight,
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(color: Color(0x80000000), blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),
              Icon(icon, size: effectiveIcon, color: Colors.black),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(fontSize: effectiveText, fontWeight: FontWeight.w700, color: Colors.black),
              ),
              const Spacer(),

            ],
          ),
        ),
      ),
    );
  }
}

class _ShadowSeparator extends StatelessWidget {
  const _ShadowSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        color: Color(0xFF9AA0A6),
        boxShadow: [
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
