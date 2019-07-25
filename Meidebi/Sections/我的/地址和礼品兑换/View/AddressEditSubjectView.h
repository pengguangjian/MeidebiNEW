//
//  AddressEditSubjectView.h
//  Meidebi
//
//  Created by mdb-admin on 2016/11/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressListModel.h"

@class AddressEditSubjectView;


@protocol AddressEditSubjectViewDelegate <NSObject>

@optional
- (void)addressEditSubjectView:(AddressEditSubjectView *)subjectView
            saveCurrentAddress:(NSDictionary *)addressDict;

@end

@interface AddressEditSubjectView : UIView

@property (nonatomic, weak) id<AddressEditSubjectViewDelegate> delegate;

- (void)bindAddressDataWithModel:(AddressListModel *)model;
@end
