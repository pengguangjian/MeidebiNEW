//
//  CommentWebView.h
//  Meidebi
//
//  Created by fishmi on 2017/6/15.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentWebViewDelegate <NSObject>

@optional - (void)webViewDidPreseeUrlWithLink:(NSString *)link;

@end

@interface CommentWebView : UIView
@property (nonatomic, weak) id<CommentWebViewDelegate>delegate;
@property (nonatomic ,strong)NSString *str;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIImageView *imageV;
@property (nonatomic ,strong) UIWebView *webView;
@property (nonatomic ,strong) UIView *view;
@property (nonatomic ,copy) void (^callback) (CGFloat height);

@end
