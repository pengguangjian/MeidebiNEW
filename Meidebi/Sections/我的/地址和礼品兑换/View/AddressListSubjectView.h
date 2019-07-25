//
//  AddressListSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2016/11/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressListModel.h"

@protocol AddressListSubjectViewDelegate <NSObject>

@optional
- (void)increaseAddress;
- (void)editAddress:(AddressListModel *)model;
- (void)deleteAddress:(NSString *)addressID;
- (void)nomoAddress:(NSString *)addressID;

@end

@protocol AddressListSelectSubjectViewDelegate <NSObject>
-(void)addressSelectItem:(id)value;
@end



@interface AddressListSubjectView : UIView

@property (nonatomic, weak) id<AddressListSubjectViewDelegate> delegate;

@property (nonatomic, weak) id<AddressListSelectSubjectViewDelegate> delegatelist;

- (void)bindAddressDataWithModel:(NSArray *)model;

-(NSMutableArray *)getAddressList;

@end
