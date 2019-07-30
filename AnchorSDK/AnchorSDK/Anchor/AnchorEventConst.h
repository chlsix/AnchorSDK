//
//  AnchorEventConst.h
//  AnchorSDK
//
//  Created by chenlei on 2019/7/30.
//  Copyright © 2019 webeye. All rights reserved.
//

#ifndef AnchorEventConst_h
#define AnchorEventConst_h

#pragma mark APP基础事件 未完成
//w_app_start：打开APP
#define WE_APP_START                        @"w_app_start"
//w_first_install：首次打开
#define WE_FIRST_INSTALL                    @"w_first_install"
//w_token_acquire：获取推送token  未添加
#define WE_TOKEN_ACQUIRE                    @"w_token_acquire"
//w_engagement：使用时长  未添加
#define WE_ENGAGEMENT                       @"w_engagement"
//w_judge： 判断用户是否root
#define WE_JUDGE                            @"w_judge"
//w_offset_acquire：获取设备时区offset
#define WE_OFFSET_ACQUIRE                   @"w_offset_acquire"

//w_sign_up：注册
#define WE_SIGN_UP                          @"w_sign_up"
//w_log_in：登录
#define WE_LOG_IN                           @"w_log_in"
//w_log_out：登出
#define WE_LOG_OUT                          @"w_log_out"
//w_purchase_request：内购请求
#define WE_PURCHASE_REQUEST                 @"w_purchase_request"
//w_purchase_success：内购成功
#define WE_PURCHASE_SUCCESS                 @"w_purchase_success"
//w_purchase_cancel：取消内购
#define WE_PURCHASE_CANCEL                  @"w_purchase_cancel"
//w_purchase_failed：内购失败
#define WE_PURCHASE_FAILED                  @"w_purchase_failed"
//w_sub_request：发起订阅请求
#define WE_SUB_REQUEST                      @"w_sub_request"
//w_sub_success：订阅成功
#define WE_SUB_SUCCESS                      @"w_sub_success"
//w_sub_failed：订阅失败
#define WE_SUB_FAILED                       @"w_sub_failed"
//w_sub_cancel：取消订阅
#define WE_SUB_CANCEL                       @"w_sub_cancel"


#endif /* AnchorEventConst_h */
