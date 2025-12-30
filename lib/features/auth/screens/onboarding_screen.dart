import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../home/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? _selectedGender;
  String? _selectedAgeRange;

  final List<String> _genderOptions = ['Men', 'Women'];
  final List<String> _ageRangeOptions = [
    '18-24',
    '25-34',
    '35-44',
    '45-54',
    '55+',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 161),
                    Text(
                      'Tell us About yourself',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 62),

                    // Who do you shop for?
                    Text(
                      'Who do you shop for ?',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 18),

                    // Gender Selection
                    Row(
                      children: _genderOptions.map((gender) {
                        final isSelected = _selectedGender == gender;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: gender == 'Men' ? 8 : 0,
                              left: gender == 'Women' ? 8 : 0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedGender = gender;
                                });
                              },
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF8E6CEF)
                                      : theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Text(
                                    gender,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 79),

                    // How Old are you?
                    Text(
                      'How Old are you ?',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 15),

                    // Age Range Dropdown
                    GestureDetector(
                      onTap: () => _showAgeRangeBottomSheet(context),
                      child: Container(
                        width: 342,
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedAgeRange ?? 'Age Range',
                              style: TextStyle(
                                color: _selectedAgeRange != null
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                fontSize: 16,
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/icons/arrow-down.svg',
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  Container(
                    color: theme.colorScheme.surface,
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: 342,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8E6CEF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text('Finish'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAgeRangeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._ageRangeOptions.map((age) {
                return ListTile(
                  title: Text(age),
                  onTap: () {
                    setState(() {
                      _selectedAgeRange = age;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
