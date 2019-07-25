//
//  InviteFriendSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/21.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviteFriendSubjectViewDelegate <NSObject>

@optional - (void)inviteFriendSubjectViewDidClickInviteBtn;

@end

@interface InviteFriendSubjectView : UIView

@property (nonatomic , retain )NSString *stryaoqingmoney;

@property (nonatomic, weak) id<InviteFriendSubjectViewDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)dict;

@end
