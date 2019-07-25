//
//  RemarkEmoticonInputView.h
//  Meidebi
//
//  Created by mdb-admin on 2017/2/6.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemarkStatusComposeEmoticonViewDelegate <NSObject>
@optional - (void)emoticonInputDidTapText:(NSString *)text;
@optional - (void)emoticonInputDidTapBackspace;
@end

@interface RemarkEmoticonInputView : UIView

@property (nonatomic, weak) id<RemarkStatusComposeEmoticonViewDelegate> delegate;
+ (instancetype)sharedInstance;

@end
