//
//  MallViewController.h
//  Meidebi
//
//  Created by 杜非 on 15/4/27.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallObjct:NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger mallid;
-(id)initWithName:(NSString *)namel lid:(NSInteger )lid;

@end


@protocol MallAppraisalViewCDelaget  <NSObject>

-(void)appRriceSelect:(MallObjct *)mallobj;

@end


@interface MallViewController : UIViewController{

    NSMutableDictionary *sectionDic;
}
@property(nonatomic,weak)id<MallAppraisalViewCDelaget>delegate;
@end
