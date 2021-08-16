import 'package:auto_route/auto_route.dart';
import 'package:dekornata_test/blocs/makeup/makeup_bloc.dart';
import 'package:dekornata_test/presentations/router/router.gr.dart';
import 'package:dekornata_test/presentations/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainRootScreen extends StatelessWidget {
  const MainRootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [HomeScreenRouter(), CategoryScreenRouter()],
      appBarBuilder: (context, tabsRouter) {
        return AppBar(
          title: const Text(
            'Dekornata',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    context.router.push(const CartScreenRouter());
                  },
                  icon: const Icon(Icons.shopping_cart_rounded),
                ),
                context.select((MakeupBloc bloc) => bloc.state.cart.length) == 0
                    ? Container()
                    : Positioned(
                        right: 4,
                        top: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(context
                                .select(
                                    (MakeupBloc bloc) => bloc.state.cart.length)
                                .toString()),
                          ),
                        ),
                      ),
              ],
            )
          ],
        );
      },
      builder: (context, child, animation) {
        return Scaffold(
          body: child,
          bottomNavigationBar: _buildBottomNavBar(context.tabsRouter),
        );
      },
    );
  }

  BottomNavigationBar _buildBottomNavBar(TabsRouter router) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Category'),
      ],
      selectedItemColor: DekornataColors.primaryColor,
      onTap: (index) => router.setActiveIndex(index),
      currentIndex: router.activeIndex,
    );
  }
}
