import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_flutter/config/app_colors.dart';
import 'package:laundry_flutter/config/failure.dart';
import 'package:laundry_flutter/config/nav.dart';
import 'package:laundry_flutter/datasources/shop_datasource.dart';
import 'package:laundry_flutter/models/shop_model.dart';
import 'package:laundry_flutter/pages/detail_shop_page.dart';
import 'package:laundry_flutter/providers/search_by_city_provider.dart';

class SearchByCity extends ConsumerStatefulWidget {
  const SearchByCity({super.key, required this.query});
  final String query;

  @override
  ConsumerState<SearchByCity> createState() => _SearchByCityState();
}

class _SearchByCityState extends ConsumerState<SearchByCity> {
  final edtSearch = TextEditingController();

  execute() {
    setSearchByCityStatus(ref, 'Loading');
    ShopDataSource.searchByCity(edtSearch.text).then((value){
      value.fold((failure) {
        switch(failure.runtimeType){
          case ServerFailure:
            setSearchByCityStatus(ref, 'Server Error');
            break;
          case NotFoundFailure:
            setSearchByCityStatus(ref, 'NotFound Error');
            break;
          case ForbiddenFailure:
            setSearchByCityStatus(ref, 'Forbidden Error');
            break;
          case BadRequestFailure:
            setSearchByCityStatus(ref, 'BadRequest Error');
            break;
          case UnauthorisedFailure:
            setSearchByCityStatus(ref, 'Unauthorized Error');
            break;
          default:
            break;
        }
      }, (result){
        setSearchByCityStatus(ref, 'Success');
        List data = result['data'];
        List<ShopModel> list = data.map((e) => ShopModel.fromJson(e)).toList();
        ref.read(searchByCityListProvider.notifier).setData(list);
      }
      );
    });
  }

  @override
  void initState() {
    if(widget.query != ''){
      edtSearch.text = widget.query;
      execute();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text('City: ',
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 16,
                height: 1),
              ),
              Expanded(child: TextField(
                controller: edtSearch,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: GoogleFonts.poppins(height: 1),
                onSubmitted: (value)=>execute(),
              ))
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: ()=>execute(), icon: const Icon(Icons.search))
        ],
      ),
      body: Consumer(
        builder: (_,wiRef,__){
          String status = wiRef.watch(searchByCityStatusProvider);
          List<ShopModel> list = wiRef.watch(searchByCityListProvider);
          print(status);
          if(status==''){
            return DView.nothing();
          }
          if(status=='Loading') return DView.loadingCircle();

          if(status=='Success'){
            return ListView.builder(
              itemCount: list.length,
                itemBuilder: (context,index){
                ShopModel shop = list[index];
                return ListTile(
                  onTap: (){
                    Nav.push(context, DetailShopPage(shop: shop));
                  },
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    radius: 18,
                    child: Text('${index+1}'),
                  ),
                  title: Text(shop.name),
                  subtitle: Text(shop.city),
                  trailing: const Icon(Icons.navigate_next),
                );
                }
                );
          }
          return DView.error(status);
        },
      ),
    );
  }
}
