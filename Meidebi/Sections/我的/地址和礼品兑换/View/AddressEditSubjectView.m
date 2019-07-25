//
//  AddressEditSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2016/11/3.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "AddressEditSubjectView.h"
#import "UITextView+Placeholder.h"
#import "LMLJDDownToUpAddressPicker.h"
#import "MDB_UserDefault.h"
@interface AddressEditSubjectView ()
<
UITextViewDelegate
>
@property (nonatomic, strong) NSArray *addressTitles;
@property (nonatomic, strong) NSMutableArray *inputViews;
@property (nonatomic, strong) LMLJDDownToUpAddressPicker *addressPicker;
@property (nonatomic, strong) NSString *address_id;
@end

@implementation AddressEditSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    UIView *addressInputView = [UIView new];
    [self addSubview:addressInputView];
    [addressInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(8);
        make.left.right.equalTo(self);
    }];
    addressInputView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
    UIView *lastView = nil;
    for (NSUInteger i = 0; i<self.addressTitles.count; i++) {
        BOOL isResponds = NO;
        if (i==2) {
            isResponds = YES;
        }
        UIView *inputView = [self createSingleInputViewWithTitle:self.addressTitles[i][@"title"]
                                                  placeholderStr:self.addressTitles[i][@"placeholder"]
                                                      isResponds:isResponds];
        [inputView setTag:i];
        [addressInputView addSubview:inputView];
        UITextView *textView = (UITextView *)[inputView viewWithTag:100];
        if (i==1 || i==4) {
            textView.keyboardType = UIKeyboardTypeNumberPad;
//            if(i==1)
//            {
//                [textView setTag:1];
//            }
        }
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(1);
            }else{
                make.top.equalTo(addressInputView.mas_top).offset(1);
            }
            make.left.right.equalTo(addressInputView);
            if (i==3) {
                make.height.offset(65);
            }else{
                make.height.offset(40);
            }
        }];
        [self.inputViews addObject:inputView];
        lastView = inputView;
        
    }
    [addressInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(1);
    }];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressInputView.mas_bottom).offset(30);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.offset(45);
    }];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 5.f;
//    saveBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
//    saveBtn.layer.borderWidth = 1.f;
    saveBtn.backgroundColor = RGB(253,122,14);
//    [UIColor colorWithHexString:@"#F2F2F2"];
    saveBtn.tag = 1100;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [saveBtn addTarget:self
               action:@selector(respondsToBtnEvents:)
     forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIView *)createSingleInputViewWithTitle:(NSString *)title
                            placeholderStr:(NSString *)placeholderStr
                                isResponds:(BOOL)responds{
    UIView *contairView = [UIView new];
    contairView.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [UIView new];
    [contairView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(contairView);
        make.width.equalTo(contairView.mas_width).multipliedBy(0.25);
    }];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIView *lineView = [UIView new];
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(headerView);
        make.width.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
    UILabel *titleLabel = [UILabel new];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(13);
        make.left.equalTo(headerView.mas_left).offset(20);
    }];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    titleLabel.text = title;
    
    UITextView *contentTextView = [UITextView new];
    [contairView addSubview:contentTextView];
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_right).offset(20);
        make.right.equalTo(contairView.mas_right).offset(-10);
        make.top.equalTo(contairView.mas_top).offset(5);
        make.bottom.equalTo(contairView.mas_bottom).offset(-5);
    }];
    contentTextView.textColor = titleLabel.textColor;
    contentTextView.font = titleLabel.font;
    contentTextView.placeholder = placeholderStr;
    contentTextView.tag = 100;
    contentTextView.scrollEnabled = NO;
    contentTextView.delegate = self;
    
    if (responds) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [contairView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(contentTextView);
        }];
        button.tag = 1000;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self
                   action:@selector(respondsToBtnEvents:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    return contairView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)respondsToBtnEvents:(id)sender{
    [self endEditing:YES];
    UIButton *button = (UIButton *)sender;
    if(button.tag == 1000){
        [self addSubview:self.addressPicker];
        __weak typeof(self) weakSelf = self;
        self.addressPicker.addressBlock =^(NSString *addressStr, NSDictionary *parameterDict) {
            UIView *inputView = weakSelf.inputViews[2];
            UITextView *textView = (UITextView *)[inputView viewWithTag:100];
            textView.text = addressStr;
        };
        [self.addressPicker show];
    }else if (button.tag == 1100){
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.addressPicker.addressDict];
        NSString *name = [self fetchContentWithInputView:self.inputViews[0]];
        NSString *phone = [self fetchContentWithInputView:self.inputViews[1]];
        NSString *address = [self fetchContentWithInputView:self.inputViews[3]];
        NSString *code = [self fetchContentWithInputView:self.inputViews[4]];
        if ([name isEqualToString:@""]) {
            [MDB_UserDefault showNotifyHUDwithtext:@"请填写收货人姓名" inView:self];
            return;
        }
        if ([phone isEqualToString:@""]) {
            [MDB_UserDefault showNotifyHUDwithtext:@"请填写收货人手机号" inView:self];
            return;
        }
        if ([phone isEqualToString:@""]) {
            [MDB_UserDefault showNotifyHUDwithtext:@"*请填写收货人手机号" inView:self];
            return;
        }
        if ([address isEqualToString:@""] || self.addressPicker.addressDict == nil) {
            [MDB_UserDefault showNotifyHUDwithtext:@"请填写收货地址" inView:self];
            return;
        }
//        if ([code isEqualToString:@""]) {
//            [MDB_UserDefault showNotifyHUDwithtext:@"请填写邮编" inView:self];
//            return;
//        }
        
        [dict setObject:name forKey:@"name"];
        [dict setObject:phone forKey:@"phone"];
        [dict setObject:address forKey:@"address"];
        if (_address_id) {
            [dict setObject:_address_id forKey:@"address_id"];
        }
        [dict setObject:code forKey:@"postcode"];
        if ([self.delegate respondsToSelector:@selector(addressEditSubjectView:saveCurrentAddress:)]) {
            [self.delegate addressEditSubjectView:self saveCurrentAddress:dict.mutableCopy];
        }
    }
   
}

- (NSString *)fetchContentWithInputView:(UIView *)inputView{
    UITextView *textView = (UITextView *)[inputView viewWithTag:100];
    return [NSString nullToString:textView.text];
}

- (UITextView *)fetchInputView:(UIView *)inputView{
    UITextView *textView = (UITextView *)[inputView viewWithTag:100];
    return textView;
}

- (void)bindAddressDataWithModel:(AddressListModel *)model{
    if (!model) return;
    [self fetchInputView:self.inputViews[0]].text = [NSString nullToString:model.strname];
    [self fetchInputView:self.inputViews[1]].text = [NSString nullToString:model.strphone];
     NSString *addressInfoStr = [NSString stringWithFormat:@"%@%@%@",model.strprovince,model.strcity,model.strarea];
    [self fetchInputView:self.inputViews[2]].text = addressInfoStr;
    [self fetchInputView:self.inputViews[3]].text = [NSString nullToString:model.straddressdetal];
    [self fetchInputView:self.inputViews[4]].text = [NSString nullToString:model.strcode];
    [self.addressPicker setDefaultAddressWithProvinceid:[NSString nullToString:model.strprovinceid]
                                                 cityid:[NSString nullToString:model.strcityid]
                                             districtid:[NSString nullToString:model.strareaid]
                                            provicename:[NSString nullToString:model.strprovince]
                                               cityname:[NSString nullToString:model.strcity]
                                           districtname:[NSString nullToString:model.strarea]];
    
    
    
    
    _address_id = [NSString nullToString:model.strid];
     
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if(textView.superview.tag == 1)
    {
        
        if(textView.text.length>=11 && ![text isEqualToString:@""])
        {
            return NO;
        }
        
    }
    
    return YES;
}

#pragma mark - setters and getters
- (NSArray *)addressTitles{
    if (!_addressTitles) {
        _addressTitles = @[@{@"title":@"收货人",
                             @"placeholder":@"收货人"},
                           @{@"title":@"手机号",
                            @"placeholder":@"手机"},
                           @{@"title":@"所在地区",
                             @"placeholder":@"所在地"},
                           @{@"title":@"详细地址",
                             @"placeholder":@"详细地址"},
                           @{@"title":@"邮编",
                             @"placeholder":@"邮编"}];
    }
    return _addressTitles;
}

- (LMLJDDownToUpAddressPicker *)addressPicker{
    if (!_addressPicker) {
        [self layoutIfNeeded];
        float fother = 0;
         if (@available(iOS 11.0, *))
         {
             fother = kTabBarHeight;
         }
        else
        {
             fother = 0;
        }
        _addressPicker = [[LMLJDDownToUpAddressPicker alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.x, self.bounds.size.width, self.bounds.size.height-fother)];
        _addressPicker.isOpenState = NO;
    }
    return _addressPicker;
}

- (NSMutableArray *)inputViews{
    if (!_inputViews) {
        _inputViews = [NSMutableArray array];
    }
    return _inputViews;
}
@end
