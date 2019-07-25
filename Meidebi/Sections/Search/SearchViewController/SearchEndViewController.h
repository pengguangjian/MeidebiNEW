//
//  SearchEndViewController.h
//  Meidebi
//
//  Created by 杜非 on 15/2/4.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTableView.h"
@interface SearchEndViewController : UIViewController<SearchTableViewDelegate>

@property(nonatomic,strong)NSString * searchStr;



@end
