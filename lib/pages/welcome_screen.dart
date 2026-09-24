import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'login_screen.dart';

const Color primaryGreen = Color(0xFF00940F);
const Color lightGreen = Color(0x1C25BF02);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = constraints.maxHeight;
                final topSpacing = screenHeight * 0.1;
                final heroImageSize = screenWidth * 0.55;
                final bottomImageWidth = (screenWidth * 0.72)
                    .clamp(220.0, 260.0)
                    .toDouble();
                final titleFontSize = screenWidth * 0.085;
                final subtitleFontSize = screenWidth * 0.055;
                final cardWidth = screenWidth * 0.82;
                final cardPadding = screenWidth * 0.055;
                final featureSpacing = screenHeight * 0.018;
                final iconSize = screenWidth * 0.065;
                final iconTextSpacing = screenWidth * 0.035;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: topSpacing.clamp(10.0, 20.0).toDouble()),
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: heroImageSize.clamp(180.0, 200.0).toDouble(),
                        height: heroImageSize.clamp(180.0, 200.0).toDouble(),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Koperasi',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: titleFontSize
                                .clamp(32.0, 36.0)
                                .toDouble(),
                            height: 1.0,
                          ),
                        ),
                        Text(
                          'Retail Sembako',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: primaryGreen,
                            fontWeight: FontWeight.w800,
                            fontSize: titleFontSize
                                .clamp(32.0, 36.0)
                                .toDouble(),
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Aplikasi belanja sembako dengan\nharga ekonomis',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: subtitleFontSize
                              .clamp(16.0, 18.0)
                              .toDouble(),
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 23.0),
                    Container(
                      width: cardWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: cardPadding.clamp(18.0, 24.0).toDouble(),
                        vertical: cardPadding.clamp(18.0, 24.0).toDouble(),
                      ),
                      decoration: BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FeatureItem(
                            label: 'Belanja Mudah',
                            iconSize: iconSize.clamp(24.0, 26.0).toDouble(),
                            iconTextSpacing: iconTextSpacing
                                .clamp(10.0, 12.0)
                                .toDouble(),
                            fontSize: subtitleFontSize
                                .clamp(18.0, 20.0)
                                .toDouble(),
                          ),
                          SizedBox(
                            height: featureSpacing.clamp(18.0, 20.0).toDouble(),
                          ),
                          _FeatureItem(
                            label: 'Harga Terjangkau',
                            iconSize: iconSize.clamp(24.0, 26.0).toDouble(),
                            iconTextSpacing: iconTextSpacing
                                .clamp(10.0, 12.0)
                                .toDouble(),
                            fontSize: subtitleFontSize
                                .clamp(18.0, 20.0)
                                .toDouble(),
                          ),
                          SizedBox(
                            height: featureSpacing.clamp(18.0, 20.0).toDouble(),
                          ),
                          _FeatureItem(
                            label: 'Produk Berkualitas',
                            iconSize: iconSize.clamp(24.0, 26.0).toDouble(),
                            iconTextSpacing: iconTextSpacing
                                .clamp(10.0, 12.0)
                                .toDouble(),
                            fontSize: subtitleFontSize
                                .clamp(18.0, 20.0)
                                .toDouble(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: min(screenHeight * 0.03, 20.0),
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: bottomImageWidth,
                            ),
                            child: Image.asset(
                              'assets/images/logo2.png',
                              width: bottomImageWidth,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              top: 10,
              right: 12,
              child: Material(
                color: Colors.white,
                elevation: 0,
                borderRadius: BorderRadius.circular(12.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Icon(Icons.close, color: Colors.black),
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

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.label,
    required this.iconSize,
    required this.iconTextSpacing,
    required this.fontSize,
  });

  final String label;
  final double iconSize;
  final double iconTextSpacing;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: primaryGreen, size: iconSize),
        SizedBox(width: iconTextSpacing),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: primaryGreen,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
