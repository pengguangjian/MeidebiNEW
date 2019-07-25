//
//  MDBShareActionSheet.h
//  Meidebi
//
//  Created by mdb-admin on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MDBShareType) {
    MDBShareTypeWeChat = 10000,
    MDBShareTypeWeMoments,
    MDBShareTypeQQ,
    MDBShareTypeSpace,
    MDBShareTypeSinaWeibo,
    MDBShareTypeTencentWeibo
};

@protocol MDBShareActionSheetDelegate <NSObject>

@optional - (void)shareActionSheetDidClickedSharButtonAtType:(MDBShareType)type;

@end

@interface MDBShareActionSheet : UIView
@property (nonatomic, weak) id<MDBShareActionSheetDelegate> delegate;
- (void)show;

@end
