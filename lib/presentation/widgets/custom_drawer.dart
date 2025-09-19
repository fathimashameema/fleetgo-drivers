import 'package:fleetgo_drivers/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:fleetgo_drivers/presentation/screens/home/profile/add_vehicle.dart';
import 'package:fleetgo_drivers/presentation/screens/home/profile/settings_screen.dart';
import 'package:fleetgo_drivers/presentation/screens/home/profile/wallet.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: screenWidth * 0.6,
      backgroundColor: Theme.of(context).highlightColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            arrowColor: TColors.textBlack,
            onDetailsPressed: () {},
            accountName: const Text("John Doe"),
            accountEmail: const Text("johndoe@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(TImages.defaultProfileDriver),
              backgroundColor: TColors.textWhite,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.wallet),
            title: const Text("Wallet"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const Wallet()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.car_rental),
            title: const Text("Add Vehicle"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AddVehicle()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.read<SignInBloc>().add(const SignOutRequired());
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
