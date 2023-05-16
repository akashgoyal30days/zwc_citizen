import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZeroWasteCitizenHero extends StatelessWidget {
  const ZeroWasteCitizenHero({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: "LogoText",
          child: Material(
            color: Colors.transparent,
            child: FittedBox(
              child: Text(
                "ZERO WASTE CITIZEN",
                style: GoogleFonts.poppins(
                    color: Colors.lightGreen[300],
                    fontWeight: FontWeight.bold,
                    fontSize: 100),
              ),
            ),
          ),
        ),
        Hero(
          tag: "LogText2",
          child: Material(
            color: Colors.transparent,
            child: FittedBox(
              child: Text(
                "JOIN US IN SAVING OUR PLANET",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
