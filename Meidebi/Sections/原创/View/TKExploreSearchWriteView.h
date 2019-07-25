//
//  TKExploreSearchWriteView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/5/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKExploreSearchWriteView : UIView<UITextFieldDelegate>

@property (nonatomic, retain) UITextField *searchField;

@property (nonatomic, retain) UINavigationController *nvc;

@end
