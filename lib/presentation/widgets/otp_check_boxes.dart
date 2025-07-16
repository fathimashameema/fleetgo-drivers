import 'package:fleetgo_drivers/bloc/sms_email_checkBox_bloc/sms_email_check_box_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpCheckBoxes extends StatelessWidget {
  const OtpCheckBoxes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmsEmailCheckBoxBloc, SmsEmailCheckBoxState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                      value: state.isSmsSelected,
                      onChanged: (newValue) {
                        context
                            .read<SmsEmailCheckBoxBloc>()
                            .add(SelectSmsEvent());
                      }),
                  Text(
                    'Get OTP via SMS',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: state.isEmailSelected,
                      onChanged: (newValue) {
                        context
                            .read<SmsEmailCheckBoxBloc>()
                            .add(SelectEmailEvent());
                      }),
                  Text(
                    'Get OTP via Email',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
