//
//  TKECamOrPhotosView.h
//  Meidebi
//
//  Created by mdb-losaic on 2018/5/22.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKECamOrPhotosViewDelegate <NSObject>
 - (void)selectItem:(NSInteger)item;
@end

@interface TKECamOrPhotosView : UIView

@property (nonatomic , weak) id<TKECamOrPhotosViewDelegate>delegate;

@end
