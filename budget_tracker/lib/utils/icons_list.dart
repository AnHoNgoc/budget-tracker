import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {

  final List<Map<String, dynamic>> homeExpensesCategories = [
    // Home Expenses
    {"name": "Gas Filling", "icon": FontAwesomeIcons.gasPump},
    {"name": "Grocery", "icon": FontAwesomeIcons.cartShopping},
    {"name": "Milk", "icon": FontAwesomeIcons.mugHot},
    {"name": "Internet", "icon": FontAwesomeIcons.wifi},
    {"name": "Electricity", "icon": FontAwesomeIcons.bolt},
    {"name": "Water", "icon": FontAwesomeIcons.water},
    {"name": "Rent", "icon": FontAwesomeIcons.home},
    {"name": "Phone Bill", "icon": FontAwesomeIcons.phone},
    {"name": "Dining Out", "icon": FontAwesomeIcons.utensils},
    {"name": "Entertainment", "icon": FontAwesomeIcons.theaterMasks},
    {"name": "Healthcare", "icon": FontAwesomeIcons.medkit},
    {"name": "Transportation", "icon": FontAwesomeIcons.bus},
    {"name": "Clothing", "icon": FontAwesomeIcons.tshirt},
    {"name": "Insurance", "icon": FontAwesomeIcons.shieldAlt},
    {"name": "Education", "icon": FontAwesomeIcons.graduationCap},
    {"name": "Others", "icon": FontAwesomeIcons.cartPlus},

    // Income
    {"name": "Salary", "icon": FontAwesomeIcons.moneyBillWave},
    {"name": "Bonus", "icon": FontAwesomeIcons.gift},
    {"name": "Investment", "icon": FontAwesomeIcons.chartLine},
    {"name": "Freelance", "icon": FontAwesomeIcons.laptopCode},
    {"name": "Rental Income", "icon": FontAwesomeIcons.building},
    {"name": "Savings Interest", "icon": FontAwesomeIcons.piggyBank},
    {"name": "Gift Received", "icon": FontAwesomeIcons.gifts},
    {"name": "Others Income", "icon": FontAwesomeIcons.coins},

    // Other Expenses
    {"name": "Travel", "icon": FontAwesomeIcons.plane},
    {"name": "Shopping", "icon": FontAwesomeIcons.shoppingBag},
    {"name": "Gym", "icon": FontAwesomeIcons.dumbbell},
    {"name": "Pet Care", "icon": FontAwesomeIcons.paw},
    {"name": "Charity", "icon": FontAwesomeIcons.handHoldingHeart},
    {"name": "Taxes", "icon": FontAwesomeIcons.fileInvoiceDollar},
    {"name": "Subscriptions", "icon": FontAwesomeIcons.tv},
    {"name": "Gifts Given", "icon": FontAwesomeIcons.gift},
    {"name": "Miscellaneous", "icon": FontAwesomeIcons.boxOpen},
  ];

  IconData getExpenseCategoryIcons(String categoryName) {

    final category = homeExpensesCategories.firstWhere(
            (category) => category["name"] == categoryName,
        orElse: () => {"icon": FontAwesomeIcons.cartShopping});

    return category["icon"];
  }
}
