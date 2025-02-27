import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_3_blabla_project/screens/ride/ride_screen.dart';
import 'package:week_3_blabla_project/screens/ride_pref/passenger_selection_screen.dart';
import 'package:week_3_blabla_project/screens/ride_pref/widgets/input_pref.dart';
import 'package:week_3_blabla_project/theme/theme.dart';
import 'package:week_3_blabla_project/utils/animations_util.dart';
import 'package:week_3_blabla_project/widgets/display/bla_divider.dart';
import 'package:week_3_blabla_project/widgets/inputs/location_selection.dart';
import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import 'dart:math';

final Random random = Random();

class RidePrefForm extends StatefulWidget {
  final RidePref? initRidePref;
  const RidePrefForm({super.key, this.initRidePref});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  Location? arrival;
  late DateTime departureDate;
  late int requestedSeats;

  @override
  void initState() {
    super.initState();
    departure = widget.initRidePref?.departure;
    arrival = widget.initRidePref?.arrival;
    departureDate = widget.initRidePref?.departureDate ?? DateTime.now();
    requestedSeats = widget.initRidePref?.requestedSeats ?? 1;
  }

  void selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != departureDate) {
      setState(() {
        departureDate = pickedDate;
      });
    }
  }

  void _navigateToPassengerSelection() async {
    final int? selectedSeats = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerSelectionScreen(initialSeats: requestedSeats),
      ),
    );
    if (selectedSeats != null) {
      setState(() {
        requestedSeats = selectedSeats;
      });
    }
  }

  void _selectLocation(bool isDeparture) async {
    final Location? selectedLocation = await Navigator.push(
      context,
      AnimationUtils.createBottomToTopRoute(
        LocationPicker(
          onLocationSelected: (location) {
            setState(() {
              if (isDeparture) {
                departure = location;
              } else {
                arrival = location;
              }
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void switchLocations() {
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  bool isChecked = false;

  void _toggleRadio() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputTile(
          icon: isChecked ? Icons.radio_button_checked : Icons.radio_button_off,
          title: departure?.name ?? "Leaving from",
          trailingIcon: Icons.swap_vert,
          onPressed: switchLocations,
          onTap: () => _selectLocation(true),
        ),
        const BlaDivider(),
        InputTile(
          icon: Icons.radio_button_off,
          title: arrival?.name ?? "Going to",
          onTap: () => _selectLocation(false), trailingIcon: null,
        ),
        const BlaDivider(),
        InputTile(
          icon: Icons.date_range,
          title: DateFormat.yMMMd().format(departureDate),
          onTap: selectDate, trailingIcon: null,
        ),
        const BlaDivider(),
        InputTile(
          icon: Icons.person_outline,
          title: "$requestedSeats",
          onTap: _navigateToPassengerSelection, trailingIcon: null,
        ),
        Padding(
          padding: const EdgeInsets.all(BlaSpacings.m),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: (departure != null && arrival != null) ? BlaColors.primary : BlaColors.greyLight,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: (departure != null && arrival != null)
                ? () {
                    final currentPref = RidePref(
                      departure: departure!,
                      arrival: arrival!,
                      departureDate: departureDate,
                      requestedSeats: requestedSeats,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RidesScreen(selectedPref: currentPref),
                      ),
                    );
                  }
                : null,
            child: Text(
              'Search',
              style: BlaTextStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}