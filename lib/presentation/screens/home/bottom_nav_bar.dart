import 'package:fleetgo_drivers/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/home/chat_screen.dart';
import 'package:fleetgo_drivers/presentation/screens/home/history_screen.dart';
import 'package:fleetgo_drivers/presentation/screens/home/home_page.dart';
import 'package:fleetgo_drivers/presentation/screens/home/notification_screen.dart';
import 'package:fleetgo_drivers/presentation/screens/home/payment_screen.dart';
import 'package:fleetgo_drivers/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final _pages = const [
    HomePage(),
    NotificationScreen(),
    HistoryScreen(),
    ChatScreen(),
    PaymentScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          // extendBody: true,
          body: _pages[state.selectedIndex],
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<NavigationBloc>().add(NavItemSelected(index));
            },
          ),
        );
      },
    );
  }
}
