//
//  PersonalInfoView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/22.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PersonalInfoViewDelegate <NSObject>
- (void)takePhotos;
- (void)selectePicture;
- (void)finishBtnClicked:(NSString *)text view:(UIView *)view;
-(void)clickToViewController: (UIViewController *)vc;
@end

@interface PersonalInfoView : UIView
@property (nonatomic ,weak) id<PersonalInfoViewDelegate> delegate;
- (void)loadPersonalInfoData: (NSDictionary *)dictionary;
- (void)setUpImageV: (UIImage *)image;
@end
