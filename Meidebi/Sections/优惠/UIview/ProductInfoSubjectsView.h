//
//  ProductInfoSubjectsView.h
//  Meidebi
//
//  Created by mdb-admin on 16/4/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfoSubjectsViewModel.h"
#import "YYPhotoGroupView.h"
#import "RemarkStatusLayout.h"
#import "NJFlagView.h"
typedef NS_ENUM(NSInteger, UpdateViewType){
    UpdateViewTypeZan,
    UpdateViewTypeShou
};
@class ProductInfoSubjectsView;
@class ProductInfoTabBarView;
@protocol ProductInfoSubjectsViewDelegate <NSObject>

- (void)productInfoSubjectsView:(ProductInfoSubjectsView *)subjectView
              didPressItemIndex:(NSInteger)index;
@optional - (void)tabBarViewdidPressZanItem;
@optional - (void)tabBarViewdidPressShouItemWithLinkType:(NSString *)linkType;
@optional - (void)tabBarViewdidPressComItem;
@optional - (void)tabBarViewDidPressReportItem;
@optional - (void)tabBarViewdidPressNonstopItemWithOutUrlStr:(NSString *)urlLink andsafari:(NSString *)safaritype;
@optional - (void)tabBarViewdidPressNonstopItemWithTmallUrlStr:(NSString *)urlLink;
@optional - (void)tabBarViewdidPressNonstopItemWithTmallidStr:(NSString *)tmallid;
@optional - (void)productInfoSubjectsViewDidPressCourseBtnWithLink:(NSString *)courseLink
                                                           sitName:(NSString *)name;
@optional - (void)remarkHomeSubjectClickUrl:(NSString *)urlStr;
@optional - (void)photoGroupView:(YYPhotoGroupView *)photoGroupView
               didClickImageView:(UIView *)fromeView;
@optional - (void)detailSubjectViewDidCickReadMoreRemark;
@optional - (void)relevanceCellDidCilckCellWithID:(NSString *)relevanceID;
@optional - (void)relevanceRecommendCellDidCilckCellWithID:(NSString *)recommendID;
@optional - (void)relevanceCellDidCilckCellWithLinkUrl:(NSString *)link;
@optional - (void)relevanceCellDidCilckLikeBtn:(NSString *)relevanceID didComplete:(void (^)(void))didComplete;
@optional - (void)detailSubjectViewDidCickFlagViewSimpleSearch:(NSString *)searchStr;
@optional - (void)detailSubjectViewDidCickFlagViewComplexSearchID:(NSString *)searchID
                                                             name:(NSString *)name
                                                             type:(FlagType)type;
@optional - (void)detailSubjectViewDidCickAddFollowWithUserid:(NSString *)userid
                                                  didComplete:(void (^)(BOOL status))didComplete;
@optional - (void)detailSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid;
@optional - (void)detailSubjectViewShowGuideElementRects:(NSArray *)rects;
@optional - (void)detailSubjectViewDidCickRewardButton;
@optional - (void)detailSubjectViewDidCickRewardInfo;
@optional - (void)detailSubjectViewDidCickByButtonWithType:(NSString *)type
                                               didComplete:(void (^)(BOOL status))didComplete;
@optional - (void)hotShowdanCellDidCilckCellWithID:(NSString *)shwodanID;

///d京东链接跳转
@optional - (void)tabBarViewdidPressNonstopItemWithOutUrlStrJDPush:(NSString *)urlLink;
///详情中的链接
@optional - (void)detailViewdidPressNonstopItemWithOutUrlStr:(NSString *)urlLink andsafari:(NSString *)safaritype;

///拼单代购
-(void)bindPinDanOrder:(int)itype andgoodsid:(NSString *)goodsid andgeid:(NSString *)strguigeid andnum:(NSString *)strnum;

///加入购物车
-(void)bindPinDanAddCar:(int)itype andgoodsid:(NSString *)goodsid andgeid:(NSString *)strguigeid andnum:(NSString *)strnum;

///求开团
-(void)qiukaituanPushAction:(NSString *)strmessage;

///求开团获取同款商品
-(void)qiukaituanItemsPushAction;

///免邮教程
-(void)mianyoujiaochengPushAction:(NSString *)strlink;

-(void)fenxianghongbaov;

////关注按钮显示问题
-(void)guanzhuButtonShow;


@end

@interface ProductInfoSubjectsView : UIView
@property (nonatomic, weak) id<ProductInfoSubjectsViewDelegate> delegate;
@property (nonatomic, retain, readonly) UIImage *productImage;

@property (nonatomic , assign) BOOL istljshare;

- (void)bindDataWithViewModel:(ProductInfoSubjectsViewModel *)viewModel;
- (void)updateSubjectViewWithType:(UpdateViewType)type isMinus:(BOOL)minus;
- (void)bindCommentData:(NSArray *)models;

-(void)zhidalianjiezidong;

///页面消失
-(void)backNavAction;

///求开团获取同款商品
-(void)qiukaituanItemsPushAction:(NSArray *)arrmessage;

@end


@protocol ProductInfoTabBarViewDelegate <NSObject>

@optional;
- (void)tabBarViewDidPressZanBton;
- (void)tabBarViewDidPressShouBton;
- (void)tabBarViewDidPressComBton;
- (void)tabBarViewDidPressNonstopBton;
- (void)tabBarViewDidPressReportItem;

@end

@interface ProductInfoTabBarView : UIView

@property (nonatomic, weak) id<ProductInfoTabBarViewDelegate> delegate;
@property (nonatomic, retain) NSString *zanNumberStr;
@property (nonatomic, retain) NSString *comNumberStr;
@property (nonatomic, retain) NSString *shouNumberStr;
@property (nonatomic, assign) BOOL isEnshrine;
- (void)updateTabBarStatuesWithType:(UpdateViewType)type isMinus:(BOOL)minus;
@end
