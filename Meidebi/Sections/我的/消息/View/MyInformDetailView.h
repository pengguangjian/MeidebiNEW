//
//  MyInformDetailView.h
//  Meidebi
//
//  Created by fishmi on 2017/7/3.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyInformDetailViewDelegate <NSObject>
- (void)touchWithId: (NSString *)Id;

-(void)webViewDidPresseeUrlWithLinkType:(NSString *)strtype andid:(NSString *)strid andurl:(NSString *)strurl;

@optional - (void)webViewDidPreseeUrlWithLink:(NSString *)link;



@end

@interface MyInformDetailView : UIView
@property (nonatomic ,weak) id <MyInformDetailViewDelegate> delegate;
@property (nonatomic ,strong) NSDictionary *dataDic;

@end
