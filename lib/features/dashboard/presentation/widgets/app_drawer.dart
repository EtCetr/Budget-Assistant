import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../dashboard_strings.dart';
import 'package:budget_assistant/features/debts/presentation/debts_strings.dart';
import 'package:budget_assistant/features/reminders/presentation/reminders_strings.dart';
import 'package:budget_assistant/features/calendar/presentation/calendar_strings.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  const AppDrawer({super.key, required this.currentRoute});

  void _go(BuildContext context, String route) {
    Navigator.of(context).pop();
    if (route != currentRoute) context.go(route);
  }

  Widget _item(BuildContext context, String route, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: currentRoute == route,
      onTap: () => _go(context, route),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('Budget Assistant',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ),
            ),
            _item(context, '/', Icons.home, DashboardStrings.screenTitle),
            _item(context, '/transactions', Icons.receipt_long, DashboardStrings.navTransactions),
            _item(context, '/accounts', Icons.account_balance_wallet, DashboardStrings.navAccounts),
            _item(context, '/categories', Icons.category, DashboardStrings.navCategories),
            _item(context, '/budget', Icons.pie_chart, DashboardStrings.navBudget),
            _item(context, '/cashback', Icons.loyalty, DashboardStrings.navCashback),
            _item(context, '/savings-goals', Icons.savings, DashboardStrings.navSavingsGoals),
            _item(context, '/debts', Icons.handshake_outlined, DebtsStrings.screenTitle),
            _item(context, '/reminders', Icons.notifications_outlined, RemindersStrings.screenTitle),
            _item(context, '/calendar', Icons.calendar_month_outlined, CalendarStrings.navCalendar),
            _item(context, '/profile', Icons.person_outline, DashboardStrings.navProfile),
          ],
        ),
      ),
    );
  }
}