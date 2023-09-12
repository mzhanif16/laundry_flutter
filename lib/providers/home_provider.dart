import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_flutter/models/promo_model.dart';
import 'package:laundry_flutter/models/shop_model.dart';

final homeCategoryProvider = StateProvider.autoDispose((ref) => 'All');
final homeStatusProvider = StateProvider.autoDispose((ref) => '');
final homeRecommendationStatus = StateProvider.autoDispose((ref) => '');

setHomeCategory(WidgetRef ref, String newCategory){
  ref.read(homeCategoryProvider.notifier).state;
}

setHomePromoStatus(WidgetRef ref, String newStatus){
  ref.read(homeStatusProvider.notifier).state;
}

setHomeRecommendationStatus(WidgetRef ref, String newStatus){
  ref.read(homeRecommendationStatus.notifier).state;
}

final homePromoListProvider = StateNotifierProvider.autoDispose<HomePromoList,List<PromoModel>>
  ((ref) => HomePromoList([]));

class HomePromoList extends StateNotifier<List<PromoModel>>{
  HomePromoList(super.state);
  setData(List<PromoModel> newData){
    state = newData;
  }
}
final homeRecommendationListProvider = StateNotifierProvider.autoDispose<HomeRecommendationList,List<ShopModel>>
  ((ref) => HomeRecommendationList([]));

class HomeRecommendationList extends StateNotifier<List<ShopModel>>{
  HomeRecommendationList(super.state);
  setData(List<ShopModel> newData){
    state = newData;
  }
}