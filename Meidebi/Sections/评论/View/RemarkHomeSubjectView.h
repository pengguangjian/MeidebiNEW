//
//  RemarkHomeSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPhotoGroupView.h"
#import "RemarkStatusLayout.h"

typedef NS_ENUM(NSInteger, PopupMenuHandleType) {
    PopupMenuHandleTypePraise = 1,
    PopupMenuHandleTypeReply,
    PopupMenuHandleTypeQuote,
    PopupMenuHandleTypeCopy
};

@protocol RemarkHomeSubjectViewDelegate <NSObject>

@optional - (void)remarkHomeSubjectViewDidClickToolBar;
@optional - (void)remarkNextPage;
@optional - (void)remarklastPage;
@optional - (void)remarkHomeSubjectClickUrl:(NSString *)urlStr;
@optional - (void)photoGroupView:(YYPhotoGroupView *)photoGroupView
               didClickImageView:(UIView *)fromeView;
@optional - (void)popupMenuDidHandle:(PopupMenuHandleType)handeType
                        targetObject:(Remark *)remark;
@optional - (void)remarkTableViewDidDrage;
@optional - (void)remarkTableViewDidAgainUploadRemark;
@optional - (void)remarkTableViewDidClickUser:(NSString *)userid;

@end

@interface RemarkHomeSubjectView : UIView

@property (nonatomic, weak) id<RemarkHomeSubjectViewDelegate> delegate;
- (void)bindDataWithModel:(NSArray *)models;
- (void)updateDataWithModel:(Remark *)aRemark;
- (void)refreshUploadingRemakInfo:(BOOL)state;
- (void)successPrise;
@end
