import 'package:exam4/ui/widgets/home_screen_widgets/carusel_widgets.dart';
import 'package:exam4/ui/widgets/home_screen_widgets/drawer_widget.dart';
import 'package:exam4/ui/widgets/home_screen_widgets/events_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = GlobalKey();
  final searchText = TextEditingController();

  void _sortedProducts(String query) {
    // final List<Food> filterProducts = [];
    // for (var food in foodList) {
    //   if (food.name.toLowerCase().contains(query.toLowerCase())) {
    //     filterProducts.add(food);
    //   }
    // }
    // setState(() {
    //   products = filterProducts;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 25,
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  _sortedProducts(value);
                },
                controller: searchText,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset('assets/images/search-300.svg'),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  hintText: 'Search event',
                  suffixIcon: PopupMenuButton(
                    icon: Icon(
                      Icons.tune,
                      color: Colors.grey.shade700,
                    ),
                    itemBuilder: (context) {
                      return [
                        const CheckedPopupMenuItem(
                          child: Text("Tadbir nomi bo'yicha"),
                        ),
                        const CheckedPopupMenuItem(
                          child: Text("Manzil bo'yicha"),
                        )
                      ];
                    },
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Yaqin 7 kun ishida",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const CaruselWidgets(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: const EventsWidgets(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
