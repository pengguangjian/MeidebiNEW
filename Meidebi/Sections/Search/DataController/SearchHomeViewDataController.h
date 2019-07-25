//
//  SearchHomeViewDataController.h
//  Meidebi
//
//  Created by mdb-losaic on 2019/2/15.
//  Copyright © 2019年 meidebi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHomeViewDataController : NSObject

@property (nonatomic, retain)NSMutableArray *arrkeys;

- (void)requestSearchHomeViewDataWithView:(UIView *)view
                                pushValue:(NSDictionary *)dicvalue
                             callback:(completeCallback)callback;

@end

NS_ASSUME_NONNULL_END
