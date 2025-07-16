import 'package:easy_radio/easy_radio.dart';
import 'package:fleetgo_drivers/bloc/check_box_bloc/check_box_bloc.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleCard extends StatelessWidget {
  final String image;
  final String role;
  final String description;
  final int value;
  final double? space;

  const RoleCard({
    super.key,
    required this.image,
    required this.role,
    required this.description,
    required this.value,
    this.space,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckBoxBloc, CheckBoxState>(
      builder: (context, state) {
        final selectedValue =
            state is SelectedRole ? state.selectedValue : null;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: TColors.grey.withAlpha(
                    Theme.of(context).brightness == Brightness.dark
                        ? 150
                        : 57)),
            boxShadow: [
              value == selectedValue
                  ? BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: TColors.darkgGey.withAlpha(
                          Theme.of(context).brightness == Brightness.dark
                              ? 200
                              : 57),
                    )
                  : const BoxShadow()
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      image,
                      height: 60,
                      width: 60,
                    ),
                    EasyRadio(
                      value: value,
                      groupValue: selectedValue,
                      onChanged: (val) {
                        context
                            .read<CheckBoxBloc>()
                            .add(SelectRole(selectedValue: val!));
                      },
                      dotColor: Theme.of(context).highlightColor,
                      dotRadius: 6,
                      inactiveBorderColor: TColors.grey,
                      activeBorderColor: TColors.headingTexts,
                      animateFillColor: true,
                      activeFillColor: TColors.headingTexts,
                      radius: 9,
                    )
                  ],
                ),
                SizedBox(height: space ?? 0),
                Text(
                  role,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        fontSize: 23,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
