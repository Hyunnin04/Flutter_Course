import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_3_blabla_project/dummy_data/dummy_data.dart';
import 'package:week_3_blabla_project/screens/ride_pref/passenger_selection_screen.dart';
import 'package:week_3_blabla_project/screens/ride_pref/widgets/input_pref.dart';
import 'package:week_3_blabla_project/theme/theme.dart';
import 'package:week_3_blabla_project/widgets/display/bla_divider.dart';
import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import 'dart:math';

final Random random = Random();

/// A Ride Preference Form is a view to select:
///   - A departure location
///   - An arrival location
///   - A date
///   - A number of seats
/// The form can be created with an existing RidePref (optional).
/// This is the form to select a ride preference.
class RidePrefForm extends StatefulWidget {
  // The form can be created with an optional initial RidePref.
  final RidePref? initRidePref;

  const RidePrefForm({super.key, this.initRidePref});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState(); // Create the state
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure; // Departure and arrival locations
  Location? arrival;

  late DateTime departureDate; // Departure date
  late int requestedSeats; // Requested seats

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  /// Initialize the state with the initial RidePref.
  @override
  void initState() {
    super.initState();

    departure = widget.initRidePref
        ?.departure; // Set departure and arrival (default to empty if null)
    arrival = widget.initRidePref?.arrival;

    departureDate = widget.initRidePref?.departureDate ?? DateTime.now();
    // Set the departure date to now if not set

    requestedSeats = widget.initRidePref?.requestedSeats ?? 1;
    // Set the requested seats to 1 if not set
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------

  /// Show the date picker to select a departure date.
  void selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime(2023), // Set a reasonable first date
      lastDate: DateTime(2101), // Set a reasonable last date
    );

    if (pickedDate != null && pickedDate != departureDate) {
      // 1- If the user selected a date, update the state
      setState(() {
        departureDate = pickedDate;
      });
    }
  }

  /// Navigate to the Passenger Selection Screen.
  void _navigateToPassengerSelection() async {
    final int? selectedSeats = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerSelectionScreen(
            initialSeats:
                requestedSeats), // Create the passenger selection screen
      ),
    );

    // If the user selected a number of seats, update the state
    if (selectedSeats != null) {
      setState(() {
        requestedSeats = selectedSeats;
      });
    }
  }

  // ----------------------------------
  // Location Selection
  // ----------------------------------

  // Function to select the departure location
  void _selectDepartureLocation() async {
    final Location? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSelectionScreen(
          locations: fakeLocations,
          onLocationSelected: (location) {
            setState(() {
              departure = location;
            });
          },
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        departure = selectedLocation;
      });
    }
  }

  // Function to select the arrival location
  void _selectArrivalLocation() async {
    final Location? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSelectionScreen(
          locations: fakeLocations,
          onLocationSelected: (location) {
            setState(() {
              arrival = location;
            });
          },
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        arrival = selectedLocation;
      });
    }
  }

  // ----------------------------------
  // Build the widgets
  // ----------------------------------

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //1 - Departure Location
        InputTile(
          icon: Icons.radio_button_off,
          title: departure?.name ?? "Leaving from",
          trailingIcon: Icons.swap_vert,
          onTap: _selectDepartureLocation,
        ),

        const BlaDivider(),

        //2 - Arrival Location
        InputTile(
          icon: Icons.radio_button_off,
          title: arrival?.name ?? "Going to",
          trailingIcon: null,
          onTap: _selectArrivalLocation,
        ),

        const BlaDivider(),

        //3 - Departure Date
        InputTile(
          icon: Icons.date_range,
          title: DateFormat.yMMMd().format(departureDate),
          trailingIcon: null,
          onTap: selectDate,
        ),

        const BlaDivider(),

        //4 - Requested Seats
        InputTile(
          icon: Icons.people,
          title: "$requestedSeats",
          trailingIcon: null,
          onTap: _navigateToPassengerSelection,
        ),

        // 5 - Search Button
        Padding(
          padding: const EdgeInsets.all(
              BlaSpacings.m), // Add spacing around the button
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: (departure != null && arrival != null)
                  ? BlaColors
                      .primary // Primary color when both locations are selected
                  : BlaColors
                      .greyLight, // Secondary color when not both selected
              minimumSize: Size(
                  double.infinity, 50), // Full width and height of the tile
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20), // Rounded bottom-left corner
                  bottomRight:
                      Radius.circular(20), // Rounded bottom-right corner
                  topLeft: Radius.circular(0), // Square top-left corner
                  topRight: Radius.circular(0), // Square top-right corner
                ),
              ),
            ),
            onPressed: (departure != null && arrival != null)
                ? () {
                    // Your logic for submitting or navigating to the next step
                  }
                : null, // Disable button if locations are not selected
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

// Location Selection Screen
class LocationSelectionScreen extends StatelessWidget {
  final List<Location> locations;
  final ValueChanged<Location> onLocationSelected;

  const LocationSelectionScreen({
    super.key,
    required this.locations,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          return ListTile(
            title: Text(location.name),
            onTap: () {
              onLocationSelected(location);
              Navigator.pop(context); // Close the screen after selection
            },
          );
        },
      ),
    );
  }
}
