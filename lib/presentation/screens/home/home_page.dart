import 'package:fleetgo_drivers/presentation/widgets/custom_drawer.dart';
import 'package:fleetgo_drivers/presentation/widgets/ride_stat_card.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:fleetgo_drivers/resources/images/images.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String getGreeting() {
      final hour = DateTime.now().hour;

      if (hour >= 5 && hour < 12) {
        return 'Good Morning';
      } else if (hour >= 12 && hour < 17) {
        return 'Good Afternoon';
      } else if (hour >= 17 && hour < 21) {
        return 'Good Evening';
      } else {
        return 'Good Night';
      }
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        drawer: CustomDrawer(screenWidth: screenWidth),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: TColors.headingTexts,
          toolbarHeight: screenHeight * 0.16,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage(TImages.defaultProfileDriver),
                        backgroundColor: TColors.textWhite,
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    getGreeting(),
                    style: GoogleFonts.cardo(
                        fontSize: 20,
                        color: TColors.textBlack,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ride statistics',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Center(child: Image.asset('assets/images/screens/graph.png')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RideStatCard(
                      title: 'Total Trips',
                      data: Text(
                        '49',
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    RideStatCard(
                      title: 'Total Km',
                      data: Text(
                        '749 Km',
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Center(
                  child: RideStatCard(
                    title: 'Your Rating',
                    data: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/screens/Group 33.png',
                          width: 80,
                        ),
                        Text(
                          'Your average rating is 4.02',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
