//
//  InviteFriendListSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviteFriendListSubjectViewDelegate <NSObject>

@optional - (void)inviteFriendListSubjectViewAscendingReveal;
@optional - (void)inviteFriendListSubjectViewDescendingReveal;

@end

@interface InviteFriendListSubjectView : UIView

@property (nonatomic, weak) id<InviteFriendListSubjectViewDelegate> delegate;
- (void)bindDataWithModels:(NSArray *)models;

@end
