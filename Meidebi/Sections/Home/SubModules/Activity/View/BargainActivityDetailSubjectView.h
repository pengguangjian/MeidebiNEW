//
//  BargainActivityDetailSubjectView.h
//  Meidebi
//
//  Created by leecool on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BargainActivityDetailSubjectViewDelegate<NSObject>

@optional - (void)bargainActivityDetailSubjectViewDidClickParticipationBtn:(NSString *)itemID;
@optional - (void)bargainActivityDetailSubjectViewDidClickBargainBtn:(NSString *)itemID;
@optional - (void)bargainActivityDetailSubjectViewDidClickRankBtn:(NSString *)itemID;
@optional - (void)bargainActivityDetailSubjectViewDidClickShareBtn:(NSString *)itemID;
@optional - (void)bargainActivityDetailSubjectViewDidClickBuyBtn:(NSString *)prodictID;
@optional - (void)bargainActivityDetailSubjectViewDidClickRecordBtn:(NSString *)itemID;
@optional - (void)bargainActivityDetailSubjectViewDidClickUpdateAddressBtn;
@optional - (void)bargainActivityDetailSubjectViewDidClickWebUrl:(NSString *)url;

@end

@interface BargainActivityDetailSubjectView : UIView
@property (nonatomic, weak) id<BargainActivityDetailSubjectViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIImage *activityImage;
- (void)bindDataWithModel:(NSDictionary *)dict;
@end
