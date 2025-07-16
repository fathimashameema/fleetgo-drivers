import 'package:file_picker/file_picker.dart';
import '../../../widgets/input_box.dart';
import '../../../widgets/page_heading.dart';
import '../../../../resources/colors/colors.dart';
import '../../../../resources/icons/icons.dart';
import 'package:flutter/material.dart';

class CompleteProfile extends StatelessWidget {
  const CompleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    String? userType;
    List<String> vehicles = [
      "Rickshaw",
      "Car",
      "Tourist",
      "Ambulance",
      "Electric",
      "Truck",
      "Bike",
    ];
    String selectedVehicle = "";
    final TextEditingController modelController = TextEditingController();
    final TextEditingController seatingController = TextEditingController();
    final TextEditingController fareController = TextEditingController();
    final TextEditingController moreController = TextEditingController();
    final List<Map<String, String>> uploadedDocs = [];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: TIcons.backButton,
                ),
                const PageHeading(
                  mainHeading: 'Complete your profile',
                  subHeading: 'Tell us more about yourself.',
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: [
                  TIcons.checkMark,
                  const SizedBox(width: 15),
                  Text(
                    'Which describes you well?',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            RadioListTile(
              radioScaleFactor: 0.8,

              title: Text(
                "Taxi Driver",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: "Taxi Driver",
              groupValue: userType,
              onChanged: (value) {},
            ),
            RadioListTile(
              radioScaleFactor: 0.8,
              title: Text(
                "Vehicle Renter",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: "Vehicle Renter",
              groupValue: userType,
              onChanged: (value) {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: [
                  TIcons.checkMark,
                  const SizedBox(width: 15),
                  Text(
                    'Select your vehicle',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 10,
              children:
                  vehicles.map((vehicle) {
                    return ChoiceChip(
                      selectedColor: TColors.headingTexts,
                      showCheckmark: false,
                      backgroundColor: TColors.primaryLight,
                      label: Text(vehicle),
                      selected: selectedVehicle == vehicle,
                      onSelected: (selected) {},
                    );
                  }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: [
                  TIcons.dashMark,
                  const SizedBox(width: 15),
                  Text(
                    'Details about your vehicle',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            InputBox(hintText: 'Model name', textController: modelController),
            InputBox(
              hintText: 'Seating capacity',
              textController: seatingController,
            ),
            InputBox(hintText: 'Base fare', textController: fareController),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: [
                  TIcons.dashMark,
                  const SizedBox(width: 15),
                  Text(
                    'Tell us more',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            InputBox(
              hintText: 'Eg, Ac/non Ac , extra luggage capacity....',
              textController: moreController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: [
                  TIcons.dashMark,
                  const SizedBox(width: 15),
                  Text(
                    'Upload necessary documents',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            ...["Driving License", "Vehicle Insurance", "RC Book"].map((
              docType,
            ) {
              return ListTile(
                title: Text(
                  docType,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: ElevatedButton.icon(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'jpg', 'png'],
                        );

                    if (result != null) {
                      uploadedDocs.add({
                        "type": docType,
                        "file": result.files.single.name,
                      });
                    }
                  },
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Upload"),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
