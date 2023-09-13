import 'package:flutter/material.dart';
import 'package:laundry_flutter/pages/dashboard_views/account_view.dart';
import 'package:laundry_flutter/pages/dashboard_views/home_view.dart';
import 'package:laundry_flutter/pages/dashboard_views/my_laundry_view.dart';

class AppConstants{
  static const appName = 'Laundry App';

  static const _host = 'http://192.168.1.7:8000';
  /// baseURL = 'http://192.168.1.7:8000/api'
  static const baseURL = '$_host/api';
  /// baseURL = 'http://192.168.1.7:8000/storage'
  static const baseImageURL = '$_host/storage';

  static const laundryStatusCategory = [
    'All',
    'Pickup',
    'Queue',
    'Process',
    'Washing',
    'Dried',
    'Ironed',
    'Done',
    'Delivery'
  ];

  static List<Map> navMenuDashboard = [
    {
      'view':const HomeView(),
      'icon':Icons.home_filled,
      'label': 'Home',
    },
    {
      'view':const MyLaundryView(),
      'icon':Icons.local_laundry_service,
      'label': 'My Laundry',
    },
    {
      'view': const Account(),
      'icon':Icons.account_circle_sharp,
      'label': 'Profile',
    },
  ];
  static const homeCategories = ['All', 'Regular', 'Express', 'Economical', 'Exclusive'];
}