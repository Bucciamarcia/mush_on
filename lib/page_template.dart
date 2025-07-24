import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mush_on/customer_management/alert_editors/booking.dart';
import 'package:mush_on/health/main.dart';
import 'package:mush_on/health/provider.dart';
import 'package:mush_on/kennel/main.dart';
import 'package:mush_on/services/auth.dart';
import 'package:mush_on/services/error_handling.dart';

import 'customer_management/alert_editors/customer_group.dart';
import 'customer_management/main.dart';
import 'customer_management/repository.dart';
import 'riverpod.dart';

class TemplateScreen extends ConsumerWidget {
  final Widget child;
  final String title;

  const TemplateScreen({super.key, required this.child, required this.title});

  Widget? _getFab(BuildContext context, WidgetRef ref) {
    if (child is HealthMain) {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: Icon(Icons.local_hospital),
            label: 'Add health event',
            onTap: () {
              ref.read(triggerAddhealthEventProvider.notifier).setValue(true);
            },
          ),
          SpeedDialChild(
            child: FaIcon(FontAwesomeIcons.syringe),
            label: 'Add vaccination',
            onTap: () {
              ref.read(triggerAddVaccinationProvider.notifier).setValue(true);
            },
          ),
          SpeedDialChild(
            child: FaIcon(FontAwesomeIcons.fire),
            label: 'Add heat',
            onTap: () {
              ref.read(triggerAddHeatCycleProvider.notifier).setValue(true);
            },
          ),
        ],
      );
    }
    if (child is ClientManagementMainScreen) {
      String account = ref.watch(accountProvider).value ?? "";
      final customerRepo = CustomerManagementRepository(account: account);
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: FaIcon(FontAwesomeIcons.bookOpen),
            label: "Add booking",
            onTap: () => showDialog(
              context: context,
              builder: (_) => BookingEditorAlert(
                onCustomersEdited: (customers) async {
                  try {
                    await customerRepo.setCustomers(customers);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          confirmationSnackbar(
                              context, "Customers added successfully"));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          errorSnackBar(context, "Couldn't add customers"));
                    }
                  }
                },
                onBookingEdited: (newBooking) async {
                  try {
                    await customerRepo.setBooking(newBooking);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          confirmationSnackbar(
                              context, "Booking added successfully"));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          errorSnackBar(context, "Couldn't add booking"));
                    }
                  }
                },
              ),
            ),
          ),
          SpeedDialChild(
              child: Icon(Icons.people_alt),
              label: "Add Customer Group",
              onTap: () => showDialog(
                    context: context,
                    builder: (_) => CustomerGroupEditorAlert(
                        onCgEdited: (newCustomerGroup) async {
                      try {
                        await customerRepo.setCustomerGroup(newCustomerGroup);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              confirmationSnackbar(context,
                                  "Customer group added successfully"));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorSnackBar(
                                  context, "Couldn't add customer group"));
                        }
                      }
                    }),
                  ))
        ],
      );
    }
    if (child is EditKennelMain) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          BasicLogger().trace("awoo");
          Navigator.pushNamed(context, "/adddog");
        },
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: _getFab(context, ref),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer),
              child: Text("Menu",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onPrimaryContainer)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false),
              title: const Text("Home"),
            ),
            ListTile(
              leading: Icon(Icons.group_add),
              onTap: () => Navigator.pushNamed(context, "/createteam"),
              title: const Text(
                "Create Team",
              ),
            ),
            ListTile(
              leading: Icon(Icons.pets),
              onTap: () => Navigator.pushNamed(context, "/editkennel"),
              title: const Text(
                "Kennel",
              ),
            ),
            ListTile(
              leading: Icon(Icons.history),
              onTap: () => Navigator.pushNamed(context, "/teamshistory"),
              title: const Text(
                "Teams history",
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_2),
              onTap: () => Navigator.pushNamed(context, "/client_management"),
              title: const Text(
                "Manage clients",
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                "Data",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.query_stats),
              onTap: () => Navigator.pushNamed(context, "/stats"),
              title: const Text(
                "Stats",
              ),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.magnifyingGlassChart),
              onTap: () => Navigator.pushNamed(context, "/insights"),
              title: const Text(
                "Insights",
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                "Data",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.task),
              onTap: () => Navigator.pushNamed(context, "/tasks"),
              title: const Text(
                "Tasks",
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              onTap: () => Navigator.pushNamed(context, "/settings"),
              title: const Text(
                "Settings",
              ),
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety),
              onTap: () => Navigator.pushNamed(context, "/health_dashboard"),
              title: const Text(
                "Health dashboard",
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              onTap: () async {
                await AuthService().signOut();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                }
              },
              title: const Text(
                "Log out",
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      )),
    );
  }
}
