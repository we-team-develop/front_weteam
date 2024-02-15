import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../data/color_data.dart';
import '../../util/wtm_utils.dart';

class WTMCurrent extends StatelessWidget {
  const WTMCurrent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 15.h,
            vertical: 10.v,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildComponentTen(),
              SizedBox(height: 15.v),
              SizedBox(
                height: 436.v,
                width: 327.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 31.v),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //시간 위치
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 13.h),
                              child: Column(
                                children: [
                                  Container(
                                    width: 254.h,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15.h),
                                    child: Row(
                                      //날짜 요일
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 12.h,
                                          child: Text(
                                            "금".tr,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                //스타일 수정
                                                ),
                                          ),
                                        ),
                                        Spacer(
                                          flex: 19,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4.v),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          // 이 부분 걍 파일 하나 만들어서 위젯을 붙여넣기 해도 될 듯. 엄청 여러 개 쓸 거니까
                                          Container(
                                            height: 17.v,
                                            width: 43.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.G_04, //임의,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                8.h,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3.v),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 388.v,
                                        width: 43.h,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Container(
                                                height: 17.v,
                                                width: 43.h,
                                                margin:
                                                    EdgeInsets.only(top: 165.v),
                                                decoration: BoxDecoration(
                                                  color: AppColors.G_04, //임의
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    8.h,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.v),
            ],
          ),
        ),
      ),
    );
  }

  // 명단 섹션
  Widget _buildComponentTen() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
        ],
      ),
    );
  }
}
