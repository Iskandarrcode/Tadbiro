import 'package:carousel_slider/carousel_slider.dart';
import 'package:exam4/logic/blocs/favorite_bloc/favorite_bloc.dart';
import 'package:exam4/logic/blocs/favorite_bloc/favorite_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaruselWidgets extends StatelessWidget {
  const CaruselWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    bool isTabbed = false;

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        autoPlayAnimationDuration: const Duration(seconds: 1),
        enableInfiniteScroll: true,
      ),
      items: [1, 2, 3, 4, 5].map(
        (i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://bogatyr.club/uploads/posts/2023-03/1678258863_bogatyr-club-p-geometricheskaya-setka-foni-krasivo-29.jpg"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 15,
                      left: 10,
                      child: Container(
                        width: 35,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "12",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "May",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 2,
                      child: BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, state) {
                          return IconButton(
                            onPressed: () {
                              context
                                  .read<FavoriteBloc>()
                                  .add(FavoriteEvent.toggle);
                            },
                            icon: Icon(
                              state.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: state.isFavorite
                                  ? Colors.red
                                  : Colors.grey.shade900,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ).toList(),
    );
  }
}
