//
//  MyInformMessageDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/4/23.
//  Copyright © 2019 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyInformMessageDataController : NSObject

@property (nonatomic , retain) NSDictionary *dicmessage;

///删除选中消息
- (void)requestMyInformDelMessageInView:(UIView *)view
                        dicpush:(NSDictionary *)dicpush
                       Callback:(completeCallback)callback;
///全部已读
- (void)requestMyInformReadMessageInView:(UIView *)view
                                dicpush:(NSDictionary *)dicpush
                               Callback:(completeCallback)callback;


///获取消息中的爆料链接
- (void)requestMyInformYuanChuangKaPianInView:(UIView *)view
                                 dicpush:(NSDictionary *)dicpush
                                Callback:(completeCallback)callback;

@end

NS_ASSUME_NONNULL_END
