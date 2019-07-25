//
//  RemarkAtUserView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/5/23.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemarkAtUserViewDelegate <NSObject>

-(void)selectItemValue:(NSDictionary *)dic;

@end


@interface RemarkAtUserView : UIView

@property (nonatomic , weak)id<RemarkAtUserViewDelegate>delegate;

-(void)AtUserValueLoad:(NSMutableArray *)arr;

@end
