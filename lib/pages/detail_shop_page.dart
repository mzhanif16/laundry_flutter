
import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_flutter/config/app_assets.dart';
import 'package:laundry_flutter/config/app_colors.dart';
import 'package:laundry_flutter/config/app_constants.dart';
import 'package:laundry_flutter/config/app_format.dart';
import 'package:laundry_flutter/config/nav.dart';
import 'package:laundry_flutter/models/shop_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class DetailShopPage extends StatelessWidget {
  const DetailShopPage({super.key, required this.shop});
  final ShopModel shop;
  launchWa(BuildContext context, String number) async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 'Chat Via Whatsapp', 'Yes to confirm',
    );
    if(yes ?? false){
      final link = WhatsAppUnilink(
        phoneNumber: number,
        text: 'TEST'
      );
      if(await canLaunchUrl(link.asUri())){
        launchUrl(link.asUri(),mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          headerImage(context),
          DView.spaceHeight(6),
          groupItemInfo(context),
          DView.spaceHeight(6),
          category(),
          DView.spaceHeight(6),
          description(),
          DView.spaceHeight(8),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 26),
            child: ElevatedButton(onPressed: (){},
                child: const Text(
                  'Order',
                  style: TextStyle(height: 1,fontSize: 18),
                )
            ),
          ),
          DView.spaceHeight(8),
        ],
      ),
    );
  }

  Padding description() {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DView.textTitle('Description', color: Colors.black87),
              DView.spaceHeight(6),
              Text(shop.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16
              ),
              )
            ],
          ),
        );
  }

  Padding category() {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DView.textTitle('Category',color: Colors.black87),
              DView.spaceHeight(8),
              Wrap(
                spacing: 8,
                children: [
                'Regular',
                'Express',
                'Economical',
                'Exclusive',
              ].map((e) {
                return Chip(
                  visualDensity: const VisualDensity(vertical: -2),
                  label: Text(e, style: GoogleFonts.poppins(height: 0, fontSize: 11)),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.primary),
                );
              }).toList(),
              ),
            ],
          ),
        );
  }

  Padding groupItemInfo(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  itemInfo(const Icon(
                    Icons.location_city_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                    shop.city,
                  ),
                  DView.spaceHeight(6),
                  itemInfo(const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 20,
                  ),
                    shop.location,
                  ),
                  DView.spaceHeight(6),
                  GestureDetector(
                    onTap: ()=> launchWa(context, shop.whatsapp),
                    child: itemInfo(
                      Image.asset(AppAssets.wa,height: 20,),
                      shop.whatsapp,
                    ),
                  ),
                ],),
              ),
              DView.spaceWidth(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(AppFormat.longPrice(shop.price),
                  textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      height: 1,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary
                    ),
                  ),
                  const Text('/kg')
                ],
              )
            ],
          ),
        );
  }

  Widget headerImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${AppConstants.baseImageURL}/shop/${shop.image}',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(colors: [
                      Colors.black, Colors.transparent
                    ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                    )
                  ),
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      DView.spaceHeight(8),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: shop.rate,
                            itemCount: 5,
                            allowHalfRating: true,
                            itemPadding: const EdgeInsets.all(0),
                            unratedColor: Colors.grey[300],
                            itemBuilder: (context, index)=>
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemSize: 12,
                            onRatingUpdate: (value) {},
                            ignoreGestures: true,
                          ),
                          DView.spaceWidth(4),
                          Text(
                            '(${shop.rate})',
                            style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 11),
                          ),
                        ],
                      ),
                      !shop.pickup && !shop.delivery
                          ? DView.nothing()
                          :Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            if(shop.pickup) childOrder('Pickup'),
                            if(shop.delivery) DView.spaceWidth(8),
                            if(shop.delivery) childOrder('Delivery'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 36,
              left: 16,
              child: SizedBox(
                height: 35,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  heroTag: 'fab-back-button',
                    onPressed: ()=>Navigator.pop(context),
                    label: const Text('Back',
                    style: TextStyle(
                    height: 1, fontSize: 16, fontWeight: FontWeight.bold
                    ),
                    ),
                  icon: const Icon(Icons.navigate_before ),
                  extendedIconLabelSpacing: 0,
                  extendedPadding: const EdgeInsets.only(left: 10,right: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container childOrder(String name) {
    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              name,
                            style: const TextStyle(
                              color: Colors.white, height: 1
                            ),
                          ),
                          DView.spaceWidth(4),
                          Icon(Icons.check_circle,
                          color: Colors.white, size: 14),
                        ],
                      ),
                    );
  }

  Widget itemInfo(Widget icon, String text){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(
        width: 30,
          height: 20,
          alignment: Alignment.centerLeft,
          child: icon),
        Expanded(child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 16,
          ),
        ))
    ],
    );
  }
}
