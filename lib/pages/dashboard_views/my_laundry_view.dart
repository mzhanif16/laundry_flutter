import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:laundry_flutter/config/app_colors.dart';
import 'package:laundry_flutter/config/app_constants.dart';
import 'package:laundry_flutter/config/app_format.dart';
import 'package:laundry_flutter/config/app_session.dart';
import 'package:laundry_flutter/config/failure.dart';
import 'package:laundry_flutter/datasources/laundry_datasource.dart';
import 'package:laundry_flutter/models/laundry_model.dart';
import 'package:laundry_flutter/models/user_model.dart';
import 'package:laundry_flutter/widgets/error_background.dart';

import '../../providers/my_laundry_provider.dart';

class MyLaundryView extends ConsumerStatefulWidget {
  const MyLaundryView({super.key});

  @override
  ConsumerState<MyLaundryView> createState() => _MyLaundryViewState();
}

class _MyLaundryViewState extends ConsumerState<MyLaundryView> {
  late UserModel user;

  getLaundry() {
    LaundryDatasource.readByUser(user.id).then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setMyLaundryStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setMyLaundryStatus(ref, 'Not Found Error');
              break;
            case ForbiddenFailure:
              setMyLaundryStatus(ref, 'Forbbiden Error');
              break;
            case BadRequestFailure:
              setMyLaundryStatus(ref, 'Unauthorized Error');
              break;
            default:
              setMyLaundryStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setMyLaundryStatus(ref, 'Success');
          List data = result['data'];
          List<LaundryModel> laundry =
              data.map((e) => LaundryModel.fromJson(e)).toList();
          ref.read(myLaundryListProvider.notifier).setData(laundry);
        },
      );
    });
  }

  dialogClaim() {
    final edtLaundryID = TextEditingController();
    final edtClaimCode = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Form(
              key: formKey,
              child: SimpleDialog(
                titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: const Text('Claim Laundry'),
                children: [
                  DInput(
                    controller: edtLaundryID,
                    title: 'Laundry ID',
                    radius: BorderRadius.circular(10),
                    validator: (input) => input == '' ? "Dont Empty" : null,
                    inputType: TextInputType.number,
                  ),
                  DView.spaceHeight(),
                  DInput(
                    controller: edtClaimCode,
                    title: 'Claim Code',
                    radius: BorderRadius.circular(10),
                    validator: (input) => input == '' ? "Dont Empty" : null,
                    inputType: TextInputType.text,
                  ),
                  DView.spaceHeight(20),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        claimNow(edtLaundryID.text, edtClaimCode.text);
                      }
                    },
                    child: const Text('Claim Now'),
                  ),
                  DView.spaceHeight(8),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'))
                ],
              ));
        });
  }

  claimNow(String id, String claimCode) {
    LaundryDatasource.claim(id, claimCode).then((value) {
      value.fold((failure) {
        switch (failure.runtimeType) {
          case ServerFailure:
            DInfo.toastError('Server Error');
            break;
          case NotFoundFailure:
            DInfo.toastError('Not Found Error');
            break;
          case ForbiddenFailure:
            DInfo.toastError('Forbidden Error');
            break;
          case BadRequestFailure:
            DInfo.toastError('Laundry Has Been Claimed');
            break;
          case UnauthorisedFailure:
            DInfo.toastError('Unauthorized Error');
            break;
          default:
            DInfo.toastError('Request Error');
            break;
        }
      }, (result) {
        DInfo.toastSuccess('Claim Success');
        getLaundry();
      });
    });
  }

  @override
  void initState() {
    AppSession.getUser().then((value) {
      user = value!;
      getLaundry();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header(),
        categories(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => getLaundry(),
            child: Consumer(
              builder: (_, wiRef, __) {
                String statusList = wiRef.watch(myLaundryStatusProvider);
                String statusCategory = wiRef.watch(myLaundryCategoryProvider);
                List<LaundryModel> listBackup =
                    wiRef.watch(myLaundryListProvider);
                if (statusList == '') return DView.loadingCircle();
                if (statusList != 'Success') {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 80),
                    child: ErrorBackgorud(ratio: 16 / 9, message: statusList),
                  );
                }
                List<LaundryModel> list = [];
                if (statusCategory == 'All') {
                  list = List.from(listBackup);
                } else {
                  list = listBackup
                      .where((element) => element.status == statusCategory)
                      .toList();
                }
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 80),
                    child: ErrorBackgorud(
                      ratio: 16 / 9,
                      message: 'Empty',
                    ),
                  );
                }
                return GroupedListView<LaundryModel, String>(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 80),
                  elements: list,
                  groupBy: (element) => AppFormat.shortDate(element.createdAt),
                  order: GroupedListOrder.DESC,
                  itemComparator: (element1, element2) {
                    return element1.createdAt.compareTo(element2.createdAt);
                  },
                  groupSeparatorBuilder: (value) => Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        margin: const EdgeInsets.only(top: 24, bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(value)),
                  ),
                  itemBuilder: (context, element) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  element.shop.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              DView.spaceWidth(),
                              Text(
                                AppFormat.longPrice(element.total),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ],
                          ),
                          DView.spaceHeight(12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (element.withPickup)
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4)),
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  child: const Text(
                                    'Pickup',
                                    style: TextStyle(
                                        color: Colors.white, height: 1),
                                  ),
                                ),
                              if (element.withDelivery)
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4)),
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  child: const Text(
                                    'Delivery',
                                    style: TextStyle(
                                        color: Colors.white, height: 1),
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  '${element.weight}kg',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Consumer categories() {
    return Consumer(
      builder: (_, wiRef, __) {
        String categorySelected = wiRef.watch(myLaundryCategoryProvider);
        return SizedBox(
          height: 30,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.laundryStatusCategory.length,
              itemBuilder: (context, index) {
                String category = AppConstants.laundryStatusCategory[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 30 : 8,
                    right:
                        index == AppConstants.laundryStatusCategory.length - 1
                            ? 30
                            : 8,
                  ),
                  child: InkWell(
                    onTap: () {
                      setMyLaundryCategory(ref, category);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: category == categorySelected
                                ? AppColors.primary
                                : Colors.grey[400]!,
                          ),
                          color: category == categorySelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      child: Text(
                        category,
                        style: TextStyle(
                            height: 1,
                            color: category == categorySelected
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Laundry',
            style: GoogleFonts.poppins(
                fontSize: 24,
                color: AppColors.primary,
                fontWeight: FontWeight.w600),
          ),
          Transform.translate(
            offset: const Offset(0, -8),
            child: OutlinedButton.icon(
              onPressed: () => dialogClaim(),
              icon: const Icon(Icons.add),
              label: const Text(
                'Claim',
                style: TextStyle(height: 1),
              ),
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                  padding: const MaterialStatePropertyAll(
                      EdgeInsets.fromLTRB(8, 2, 16, 2))),
            ),
          ),
        ],
      ),
    );
  }
}
