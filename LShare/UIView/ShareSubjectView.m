//
//  ShareSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/8/2.
//  Copyright © 2016年 meidebi. All rights reserved.
//
#import "ShareSubjectView.h"
#import "UIColor+Hex.h"
#import "UITextView+Placeholder.h"
#import "MDB_ShareExstensionUserDefault.h"
#import "NSString+extend.h"
#import "ShareDataController.h"
#import "BrokeTypeActionSheetView.h"
#import "NJFlagView.h"
@interface NJShareScrollView : UIScrollView

@end

@implementation NJShareScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    @try
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    @finally
    {
        
    }
}

@end

@interface ShareSubjectView ()
<
BrokeTypeActionSheetViewDelegate,
UITextFieldDelegate,
UITextViewDelegate
>
@property (nonatomic, strong) UILabel *linkLabel;
@property (nonatomic, strong) UITextField *productNameTextField;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UITextField *productPriceTextField;
@property (nonatomic, strong) UILabel *productTypeConentLabel;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) BrokeInfoViewModel *viewModel;
@property (nonatomic, strong) NJShareScrollView *scrollView;
@property (nonatomic, strong) NJFlagView *flagView;


@end

@implementation ShareSubjectView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    UIButton *brokeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:brokeBtn];
    brokeBtn.backgroundColor = [UIColor colorWithHexString:@"#FF7623"];
    brokeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [brokeBtn setTitle:@"立即爆料" forState:UIControlStateNormal];
    brokeBtn.tag = 100;
    [brokeBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *noBrokeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:noBrokeBtn];
    noBrokeBtn.backgroundColor = [UIColor colorWithHexString:@"#DCDCDC"];
    noBrokeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [noBrokeBtn setTitle:@"取消爆料" forState:UIControlStateNormal];
    [noBrokeBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    noBrokeBtn.tag = 110;
    [noBrokeBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [brokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(noBrokeBtn.mas_width);
        make.height.offset(50);
    }];
    
    [noBrokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.height.width.equalTo(brokeBtn);
        make.right.equalTo(brokeBtn.mas_left);
        make.left.equalTo(self.mas_left);
    }];
    
    
    _scrollView = [NJShareScrollView new];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(brokeBtn.mas_top);
    }];
    
    UIView *contairView = [UIView new];
    [_scrollView addSubview:contairView];
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    UIView *linkContairView = [UIView new];
    [contairView addSubview:linkContairView];
    [linkContairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contairView.mas_top).offset(24);
        make.left.equalTo(contairView.mas_left).offset(17);
        make.right.equalTo(contairView.mas_right).offset(-17);
    }];
    linkContairView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    
     _linkLabel = [UILabel new];
    [linkContairView addSubview:_linkLabel];
    [_linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(linkContairView.mas_left).offset(15);
        make.right.equalTo(linkContairView.mas_right).offset(-15);
        make.top.equalTo(linkContairView.mas_top).offset(12);
    }];
    _linkLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _linkLabel.font = [UIFont systemFontOfSize:14.f];
    _linkLabel.numberOfLines = 0;
    
    [linkContairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_linkLabel.mas_bottom).offset(12);
    }];
    
    
    _productImageView = [UIImageView new];
    [contairView addSubview:_productImageView];
    [_productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(linkContairView);
        make.top.equalTo(linkContairView.mas_bottom).offset(17);
        make.height.offset(140);
    }];
    _productImageView.contentMode = UIViewContentModeScaleAspectFit;
    _productImageView.layer.masksToBounds = YES;
    _productImageView.layer.borderWidth = 1;
    _productImageView.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    
    UILabel *headlineLabel = [UILabel new];
    [contairView addSubview:headlineLabel];
    [headlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productImageView.mas_left);
        make.top.equalTo(_productImageView.mas_bottom).offset(16);
    }];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(5);
        return;
    });
    
    headlineLabel.text = @"标   题：";
    headlineLabel.font = [UIFont systemFontOfSize:14.f];
    headlineLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    _productNameTextField = [UITextField new];
    [contairView addSubview:_productNameTextField];
    [_productNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_productImageView);
        make.top.equalTo(headlineLabel.mas_bottom).offset(13);
        make.height.offset(41);
    }];
    _productNameTextField.font = [UIFont systemFontOfSize:14];
    _productNameTextField.textColor = [UIColor colorWithHexString:@"#555555"];
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView.backgroundColor = [UIColor clearColor];
    _productNameTextField.leftView = leftView;
    _productNameTextField.leftViewMode = UITextFieldViewModeAlways;
    _productNameTextField.layer.masksToBounds = YES;
    _productNameTextField.layer.borderWidth = 1;
    _productNameTextField.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    _productNameTextField.delegate = self;
    
    UILabel *remarkLabel = [UILabel new];
    [contairView addSubview:remarkLabel];
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productNameTextField.mas_left);
        make.top.equalTo(_productNameTextField.mas_bottom).offset(16);
    }];
    remarkLabel.text = @"推荐理由：";
    remarkLabel.font = headlineLabel.font;
    remarkLabel.textColor = headlineLabel.textColor;
    
    UIView *remarkContairView = [UIView new];
    [contairView addSubview:remarkContairView];
    [remarkContairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_productImageView);
        make.top.equalTo(remarkLabel.mas_bottom).offset(14);
        make.height.offset(100);
    }];
    remarkContairView.layer.masksToBounds = YES;
    remarkContairView.layer.borderWidth = 1;
    remarkContairView.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    
    _descriptionTextView = [UITextView new];
    [remarkContairView addSubview:_descriptionTextView];
    [_descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(remarkContairView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    _descriptionTextView.textColor = _productNameTextField.textColor;
    _descriptionTextView.font = _productNameTextField.font;
    _descriptionTextView.placeholder = @"请详细描述如何低价购买商品，写得好将会设为推荐，赚取丰厚铜币换礼品！";
    _descriptionTextView.delegate = self;
    
    _flagView = [NJFlagView new];
    [contairView addSubview:_flagView];
    [_flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkContairView.mas_bottom).offset(16);
        make.left.right.equalTo(contairView);
    }];
    _flagView.flagTitleName = @"标 签";
    _flagView.flagTitleFont = headlineLabel.font;
    _flagView.flagTitleColor = headlineLabel.textColor;
    __weak typeof (self) weakSelf = self;
    _flagView.callback = ^(CGFloat height) {
        [weakSelf.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(height);
        }];
    };
    
    UILabel *productTypeLabel = [UILabel new];
    [contairView addSubview:productTypeLabel];
    [productTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productNameTextField.mas_left);
        make.top.equalTo(_flagView.mas_bottom).offset(16);
    }];
    productTypeLabel.text = @"商品分类：";
    productTypeLabel.font = headlineLabel.font;
    productTypeLabel.textColor = headlineLabel.textColor;
    
    
    UIControl *productTypeControl = [UIControl new];
    [contairView addSubview:productTypeControl];
    [productTypeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_productImageView);
        make.top.equalTo(productTypeLabel.mas_bottom).offset(13);
        make.height.offset(41);
    }];
    productTypeControl.layer.masksToBounds = YES;
    productTypeControl.layer.borderWidth = 1;
    productTypeControl.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    [productTypeControl addTarget:self action:@selector(respondsToTypeBtnSelect) forControlEvents:UIControlEventTouchUpInside];
    
    _productTypeConentLabel = [UILabel new];
    [contairView addSubview:_productTypeConentLabel];
    [_productTypeConentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(productTypeControl).insets(UIEdgeInsetsMake(10, 10, 10, 50));
    }];
    _productTypeConentLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    _productTypeConentLabel.font = [UIFont systemFontOfSize:14];
    _productTypeConentLabel.text = @"请选择商品分类";
    
    UIButton *selectTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:selectTypeBtn];
    [selectTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(productTypeControl);
        make.width.offset(46);
    }];
    selectTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#D2D2D2"];
    [selectTypeBtn setImage:[UIImage imageNamed:@"selectProductType"] forState:UIControlStateNormal];
    [selectTypeBtn addTarget:self
                      action:@selector(respondsToTypeBtnSelect)
            forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *productPricePromptLabel = [UILabel new];
    [contairView addSubview:productPricePromptLabel];
    [productPricePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(productTypeControl.mas_left);
        make.top.equalTo(productTypeControl.mas_bottom).offset(16);
    }];
    productPricePromptLabel.text = @"商品价格：";
    productPricePromptLabel.font = headlineLabel.font;
    productPricePromptLabel.textColor = headlineLabel.textColor;
    
    _productPriceTextField = [UITextField new];
    [contairView addSubview:_productPriceTextField];
    [_productPriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(productPricePromptLabel.mas_right).offset(14);
        make.right.equalTo(_productImageView.mas_right);
        make.centerY.equalTo(productPricePromptLabel.mas_centerY);
        make.height.offset(30);
    }];
    _productPriceTextField.textColor = [UIColor colorWithHexString:@"#FD7A0F"];
    _productPriceTextField.font = [UIFont systemFontOfSize:14.f];
    _productPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _productPriceTextField.delegate = self;
    
    UIView *lineView = [UIView new];
    [contairView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_productImageView);
        make.top.equalTo(productPricePromptLabel.mas_bottom).offset(19);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView.mas_bottom).offset(20);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)bindDataWithViewModel:(BrokeInfoViewModel *)viewModel{
    _viewModel = viewModel;
    [[MDB_ShareExstensionUserDefault defaultInstance] setViewWithImage:_productImageView url:viewModel.linkImgeLink options:SDWebImageHighPriority];
    _productNameTextField.text = viewModel.title;
    _productPriceTextField.text = viewModel.proprice;
    [_flagView flag:@[@"口红",@"护肤"]];
}

- (void)respondsToTypeBtnSelect{
    
    ShareDataController *dataController = [[ShareDataController alloc] init];
    [dataController requestGetCateDataWithInView:self callback:^(NSError *error) {
        if (dataController.resultMessage) {
            [MDB_ShareExstensionUserDefault showNotifyHUDwithtext:dataController.resultMessage inView:self];
        }else{
            [self shousheetview:dataController.requestCateResults];
        }
    }];
}

-(void)shousheetview:(id)value
{
    BrokeTypeActionSheetView *actionSheetView = [[BrokeTypeActionSheetView alloc] init];
    actionSheetView.types = value;
    actionSheetView.delegate = self;
    [self addSubview:actionSheetView];
    [actionSheetView mas_makeConstraints:^(MASConstraintMaker *make) {
        @try
        {
            make.edges.equalTo(self);
        }
        @catch(NSException *exc)
        {
            
        }
        @finally
        {
            
        }
        
    }];
}

- (void)respondsToBtnEvent:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 100:
        {
            if ([self.delegate respondsToSelector:@selector(shareSubjectView:didPressBrokeBtnWithInfo:)]) {
                @try
                {
                    NSDictionary *dict = @{
                                           @"url":_brokeLink,
                                           @"image":[NSString nullToString:_viewModel.linkImgeLink],
                                           @"title":[NSString nullToString:_productNameTextField.text],
                                           @"category":[NSString nullToString:_typeId],
                                           @"proprice":[NSString nullToString:_productPriceTextField.text],
                                           @"description":[NSString nullToString:_descriptionTextView.text],
                                           @"token":[NSString nullToString:_viewModel.token],
                                           @"session":[NSString nullToString:_viewModel.session]
                                           };
                    [self.delegate shareSubjectView:self didPressBrokeBtnWithInfo:dict];
                }
                @catch(NSException *exc)
                {
                    
                }
                @finally
                {
                    
                }
            }
        }
            break;
        case 110:
        {
            if ([self.delegate respondsToSelector:@selector(shareSubjectViewDidPressNoBrokeBtn)]) {
                [self.delegate shareSubjectViewDidPressNoBrokeBtn];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_scrollView scrollRectToVisible:textField.frame animated:YES];
    return YES;
}
#pragma mark - UITextviewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [_scrollView scrollRectToVisible:textView.frame animated:YES];
    return YES;
}

#pragma mark - BrokeTypeAlertViewDelegate
- (void)brokeTypeActionSheetView:(BrokeTypeActionSheetView *)alertView didSelectType:(NSDictionary *)dict{
    _productTypeConentLabel.text = dict[@"name"];
    _typeId = dict[@"id"];
}

#pragma mark - setter and getter
- (void)setBrokeLink:(NSString *)brokeLink{
    _brokeLink = brokeLink;
    _linkLabel.text = brokeLink;
}



@end
