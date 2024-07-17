import 'package:flutter/material.dart';

class ProfileInfoWidget extends StatelessWidget {
  final IconData icons;
  final String text1;

  const ProfileInfoWidget({
    super.key,
    required this.icons,
    required this.text1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icons),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text1,
                    style: const TextStyle(
                      fontFamily: "worksans",
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios_sharp,
            size: 18,
          ),
        ],
      ),
    );
  }
}
