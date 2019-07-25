//
//  BrokeInfoSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/27.
//  Copyright © 2016年 meidebi. All rights reserved.
//

@interface NJBrokeInfoScrollView : UIScrollView

@end

@implementation NJBrokeInfoScrollView

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

#import "BrokeInfoSubjectView.h"
#import "BrokeTypeActionSheetView.h"
#import "MDB_UserDefault.h"
#import "BrokeShareDataController.h"
#import "UITextView+Placeholder.h"
#import "PelsonalHandleButton.h"
#import "XHDatePickerView.h"
#import "NSDate+XHExtension.h"
@interface BrokeInfoSubjectView()
<
BrokeTypeActionSheetViewDelegate,
UITextFieldDelegate
>
@property (nonatomic, strong) UILabel *linkLabel;
@property (nonatomic, strong) UITextField *productNameTextField;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UITextField *productPriceTextField;
@property (nonatomic, strong) UILabel *productTypeConentLabel;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) BrokeInfoViewModel *viewModel;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) NSArray *activityTypes;
@property (nonatomic, strong) UITextField *intensityTextField;
@property (nonatomic, strong) UIButton *activityStarTimeBtn;
@property (nonatomic, strong) UIButton *activityEndTimeBtn;
@property (nonatomic, strong) NSString *activityTypeStr;
@property (nonatomic, strong) NSArray *activityTypeItems;
@property (nonatomic, assign) BrokeType aType;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) UILabel *productPricePromptLabel;

@property (nonatomic, strong) UILabel *zheherenmingbiLabel;

@property (nonatomic, strong) UIView *viewprice;

@end

@implementation BrokeInfoSubjectView
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (instancetype)initWithType:(BrokeType)type{
    _aType = type;
    return [self initWithFrame:CGRectZero];
}

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
    [brokeBtn setBackgroundImage:[UIImage imageNamed:@"broke_bg"] forState:UIControlStateNormal];
    [brokeBtn setBackgroundImage:[UIImage imageNamed:@"broke_bg"] forState:UIControlStateNormal | UIControlStateHighlighted];
    [brokeBtn setBackgroundImage:[UIImage imageNamed:@"broke_bg"] forState:UIControlStateHighlighted];
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

    
    NJBrokeInfoScrollView *scrollView = [NJBrokeInfoScrollView new];
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(brokeBtn.mas_top);
    }];
    
    UIView *contairView = [UIView new];
    [scrollView addSubview:contairView];
    [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    _contairView = contairView;
    
    UIView *linkContairView = [UIView new];
    [contairView addSubview:linkContairView];
    [linkContairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contairView.mas_top).offset(17);
        make.left.equalTo(contairView.mas_left).offset(17);
        make.right.equalTo(contairView.mas_right).offset(-17);
    }];
    linkContairView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    linkContairView.layer.masksToBounds = YES;
    linkContairView.layer.cornerRadius = 4.f;
    
    _linkLabel = [UILabel new];
    [linkContairView addSubview:_linkLabel];
    [_linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(linkContairView.mas_left).offset(15);
        make.right.equalTo(linkContairView.mas_right).offset(-15);
        make.top.equalTo(linkContairView.mas_top).offset(12);
    }];
    _linkLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _linkLabel.font = [UIFont systemFontOfSize:12.f];
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
    _productImageView.layer.cornerRadius = 4.f;
    _productImageView.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    
    UIButton *choicePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contairView addSubview:choicePhotoBtn];
    [choicePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_productImageView.mas_right).offset(-8);
        make.bottom.equalTo(_productImageView.mas_bottom).offset(-8);
        make.size.mas_equalTo(CGSizeMake(61, 23));
    }];
    choicePhotoBtn.backgroundColor = [UIColor colorWithHexString:@"#838383"];
    choicePhotoBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [choicePhotoBtn setTitle:@"更换图片" forState:UIControlStateNormal];
    [choicePhotoBtn addTarget:self action:@selector(respondsToChoicePhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *headlineLabel = [UILabel new];
    [contairView addSubview:headlineLabel];
    [headlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productImageView.mas_left);
        make.top.equalTo(_productImageView.mas_bottom).offset(16);
    }];
    headlineLabel.text = @"标   题：";
    headlineLabel.font = [UIFont systemFontOfSize:12.f];
    headlineLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    _productNameTextField = [UITextField new];
    [contairView addSubview:_productNameTextField];
    [_productNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_productImageView);
        make.top.equalTo(headlineLabel.mas_bottom).offset(13);
        make.height.offset(35);
    }];
    _productNameTextField.font = [UIFont systemFontOfSize:12];
    _productNameTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,10,26)];
    leftView.backgroundColor = [UIColor clearColor];
    _productNameTextField.leftView = leftView;
    _productNameTextField.leftViewMode = UITextFieldViewModeAlways;
    _productNameTextField.layer.masksToBounds = YES;
    _productNameTextField.layer.borderWidth = 1;
    _productNameTextField.layer.cornerRadius = 4.f;
    _productNameTextField.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;

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
        make.height.offset(85);
    }];
    remarkContairView.layer.masksToBounds = YES;
    remarkContairView.layer.borderWidth = 1;
    remarkContairView.layer.cornerRadius = 4.f;
    remarkContairView.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    
    _descriptionTextView = [UITextView new];
    [remarkContairView addSubview:_descriptionTextView];
    [_descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(remarkContairView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    _descriptionTextView.textColor = _productNameTextField.textColor;
    _descriptionTextView.font = _productNameTextField.font;
    _descriptionTextView.placeholder = @"请详细描述如何低价购买商品，写得好将会设为推荐，赚取丰厚铜币换礼品！";
    
    
    UILabel *productTypeLabel = [UILabel new];
    [contairView addSubview:productTypeLabel];
    [productTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productNameTextField.mas_left);
        make.top.equalTo(remarkContairView.mas_bottom).offset(12);
    }];
    productTypeLabel.text = @"商品分类：";
    productTypeLabel.font = headlineLabel.font;
    productTypeLabel.textColor = headlineLabel.textColor;
    
    
    UIControl *productTypeControl = [UIControl new];
    [contairView addSubview:productTypeControl];
    [productTypeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_productImageView);
        make.top.equalTo(productTypeLabel.mas_bottom).offset(12);
        make.height.offset(35);
    }];
    productTypeControl.layer.masksToBounds = YES;
    productTypeControl.layer.borderWidth = 1;
    productTypeControl.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    productTypeControl.layer.cornerRadius = 4.f;
    productTypeControl.clipsToBounds = YES;
    [productTypeControl addTarget:self action:@selector(respondsToTypeBtnSelect) forControlEvents:UIControlEventTouchUpInside];
    
    _productTypeConentLabel = [UILabel new];
    [productTypeControl addSubview:_productTypeConentLabel];
    [_productTypeConentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(productTypeControl).insets(UIEdgeInsetsMake(10, 10, 10, 50));
    }];
    _productTypeConentLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _productTypeConentLabel.font = [UIFont systemFontOfSize:12];
    _productTypeConentLabel.text = @"请选择商品分类";
    
    UIButton *selectTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [productTypeControl addSubview:selectTypeBtn];
    [selectTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(productTypeControl);
        make.width.offset(41);
    }];
    selectTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [selectTypeBtn setImage:[UIImage imageNamed:@"selectProductType"] forState:UIControlStateNormal];
    [selectTypeBtn addTarget:self
                      action:@selector(respondsToTypeBtnSelect)
            forControlEvents:UIControlEventTouchUpInside];
    
    if (_aType == BrokeTypeActivity) {
        [self configurActivityInfoWithRelationView:productTypeControl];
    }else{
        
        _viewprice = [[UIView alloc] init];
        [contairView addSubview:_viewprice];
        [_viewprice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(productTypeControl.mas_left);
            make.top.equalTo(productTypeControl.mas_bottom).offset(16);
            make.right.equalTo(contairView.mas_right).offset(-17);
            make.height.offset(35);
        }];
        [_viewprice.layer setMasksToBounds:YES];
        [_viewprice.layer setCornerRadius:4];
        _viewprice.layer.borderWidth = 1;
        _viewprice.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
        
        _productPricePromptLabel = [UILabel new];
        [_viewprice addSubview:_productPricePromptLabel];
        [_productPricePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(0);
            make.height.equalTo(_viewprice.mas_height);
        }];
        _productPricePromptLabel.text = @"商品价格：";
        _productPricePromptLabel.font = headlineLabel.font;
        _productPricePromptLabel.textColor = headlineLabel.textColor;
        
        _productPriceTextField = [UITextField new];
        [_viewprice addSubview:_productPriceTextField];
        [_productPriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_productPricePromptLabel.mas_right).offset(14);
            make.right.equalTo(_productImageView.mas_right);
            make.centerY.equalTo(_productPricePromptLabel.mas_centerY);
            make.height.equalTo(_viewprice.mas_height);
        }];
        _productPriceTextField.textColor = [UIColor colorWithHexString:@"#FD7A0F"];
        _productPriceTextField.font = [UIFont systemFontOfSize:12.f];
        _productPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_productPriceTextField setPlaceholder:@"价格"];
        [_productPriceTextField setDelegate:self];
        [_productPriceTextField setTag:1001];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChageValue) name:UITextFieldTextDidChangeNotification object:nil];
//        UIView *lineView = [UIView new];
//        [contairView addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(_productImageView);
//            make.top.equalTo(_productPriceTextField.mas_bottom).offset(5);
//            make.height.offset(1);
//        }];
//        lineView.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
        
        _zheherenmingbiLabel = [UILabel new];
        [contairView addSubview:_zheherenmingbiLabel];
        [_zheherenmingbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewprice.mas_left);
            make.right.equalTo(_viewprice.mas_right);
            make.top.equalTo(_viewprice.mas_bottom);
            make.height.offset(1);
        }];
        _zheherenmingbiLabel.textColor = RadMenuColor;
        _zheherenmingbiLabel.font = [UIFont systemFontOfSize:12.f];
        [_zheherenmingbiLabel setHidden:YES];
        
        [contairView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_zheherenmingbiLabel.mas_bottom).offset(20);
        }];
    }
    
}

- (void)configurActivityInfoWithRelationView:(UIView *)relationView{
    UILabel *activityTypeLabel = [UILabel new];
    [_contairView addSubview:activityTypeLabel];
    [activityTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productNameTextField.mas_left);
        make.top.equalTo(relationView.mas_bottom).offset(16);
    }];
    activityTypeLabel.text = @"促销类型：";
    activityTypeLabel.font = [UIFont systemFontOfSize:12.f];
    activityTypeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    NSMutableArray *arr = [NSMutableArray array];
    PelsonalHandleButton *lastBtn = nil;
    for (NSInteger i = 0; i < self.activityTypes.count; i++) {
        PelsonalHandleButton *brokeTypeBtn = [PelsonalHandleButton buttonWithType:UIButtonTypeCustom];
        [_contairView addSubview:brokeTypeBtn];
        brokeTypeBtn.tag = 222222+i;
        brokeTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [brokeTypeBtn setTitle:self.activityTypes[i] forState:UIControlStateNormal];
        [brokeTypeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [brokeTypeBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [brokeTypeBtn setTitleColor:[UIColor colorWithHexString:@"#F46304"] forState:UIControlStateSelected];
        [brokeTypeBtn setImage:[UIImage imageNamed:@"brok_type_normal"] forState:UIControlStateNormal];
        [brokeTypeBtn setImage:[UIImage imageNamed:@"brok_type_normal"] forState:UIControlStateNormal | UIControlStateHighlighted];
        [brokeTypeBtn setImage:[UIImage imageNamed:@"brok_type_select"] forState:UIControlStateSelected];
        [brokeTypeBtn addTarget:self action:@selector(responsToActivityTypeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [brokeTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastBtn) {
                make.left.equalTo(lastBtn.mas_right).offset(25*kScale);
            }else{
                make.left.equalTo(_contairView.mas_left).offset(17);
            }
            make.top.equalTo(activityTypeLabel.mas_bottom).offset(10);
            make.height.offset(35);
        }];
        if (i == 0) {
            _activityTypeStr = @"1";
            brokeTypeBtn.selected = YES;
        }
        lastBtn = brokeTypeBtn;
        [arr addObject:brokeTypeBtn];
    }
    _activityTypeItems = arr.mutableCopy;
    UILabel *intensityPromptLabel = [UILabel new];
    [_contairView addSubview:intensityPromptLabel];
    [intensityPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(activityTypeLabel.mas_left);
        make.top.equalTo(lastBtn.mas_bottom).offset(12);
    }];
    intensityPromptLabel.text = @"促销力度：";
    intensityPromptLabel.font = activityTypeLabel.font;
    intensityPromptLabel.textColor = activityTypeLabel.textColor;
    
    _intensityTextField = [UITextField new];
    [_contairView addSubview:_intensityTextField];
    [_intensityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(activityTypeLabel.mas_left);
        make.right.equalTo(_productImageView.mas_right);
        make.top.equalTo(intensityPromptLabel.mas_bottom).offset(10);
        make.height.offset(35);
    }];
    _intensityTextField.backgroundColor = [UIColor whiteColor];
    _intensityTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    _intensityTextField.font = [UIFont systemFontOfSize:12.f];
    _intensityTextField.layer.masksToBounds = YES;
    _intensityTextField.layer.cornerRadius = 4.f;
    _intensityTextField.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    _intensityTextField.layer.borderWidth = 1;
    _intensityTextField.placeholder = @"比如：下单6折/直降300/1元秒杀";
    _intensityTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    _intensityTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *activityTimePromptLabel = [UILabel new];
    [_contairView addSubview:activityTimePromptLabel];
    [activityTimePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(activityTypeLabel.mas_left);
        make.top.equalTo(_intensityTextField.mas_bottom).offset(12);
    }];
    activityTimePromptLabel.text = @"活动时间：";
    activityTimePromptLabel.font = activityTypeLabel.font;
    activityTimePromptLabel.textColor = activityTypeLabel.textColor;
    
    _activityStarTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contairView addSubview:_activityStarTimeBtn];
    [_activityStarTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(activityTimePromptLabel.mas_left);
        make.top.equalTo(activityTimePromptLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(126, 35));
    }];
    _activityStarTimeBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _activityStarTimeBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _activityStarTimeBtn.layer.masksToBounds = YES;
    _activityStarTimeBtn.layer.cornerRadius = 4.f;
    _activityStarTimeBtn.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    _activityStarTimeBtn.layer.borderWidth = 1;
    [_activityStarTimeBtn setTitle:@"开始时间" forState:UIControlStateNormal];
    [_activityStarTimeBtn setTitle:@"开始时间" forState:UIControlStateHighlighted];
    [_activityStarTimeBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_activityStarTimeBtn addTarget:self action:@selector(responsToActivityTimeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *timeSpanPromptLabel = [UILabel new];
    [_contairView addSubview:timeSpanPromptLabel];
    [timeSpanPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_activityStarTimeBtn.mas_right).offset(12*kScale);
        make.centerY.equalTo(_activityStarTimeBtn.mas_centerY);
    }];
    timeSpanPromptLabel.text = @"至";
    timeSpanPromptLabel.font = _intensityTextField.font;
    timeSpanPromptLabel.textColor = _intensityTextField.textColor;
    
    _activityEndTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contairView addSubview:_activityEndTimeBtn];
    [_activityEndTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeSpanPromptLabel.mas_right).offset(12*kScale);
        make.top.equalTo(activityTimePromptLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(126, 35));
    }];
    _activityEndTimeBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _activityEndTimeBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _activityEndTimeBtn.layer.masksToBounds = YES;
    _activityEndTimeBtn.layer.cornerRadius = 4.f;
    _activityEndTimeBtn.layer.borderColor = [UIColor colorWithHexString:@"#E4E4E4"].CGColor;
    _activityEndTimeBtn.layer.borderWidth = 1;
    [_activityEndTimeBtn setTitle:@"结束时间" forState:UIControlStateNormal];
    [_activityEndTimeBtn setTitle:@"结束时间" forState:UIControlStateHighlighted];
    [_activityEndTimeBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_activityEndTimeBtn addTarget:self action:@selector(responsToActivityTimeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];

    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_activityEndTimeBtn.mas_bottom).offset(20);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (void)responsToActivityTypeBtnEvent:(UIButton *)sender{
    for (PelsonalHandleButton *btn in self.activityTypeItems) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    switch (sender.tag) {
        case 222222:
            _activityTypeStr = @"1";
            break;
        case 222223:
            _activityTypeStr = @"2";
            break;
        case 222224:
            _activityTypeStr = @"4";
            break;
        default:
            break;
    }
}
- (void)responsToActivityTimeBtnEvent:(UIButton *)sender{
    [self endEditing:YES];
    
    NSDate *currentDate = [NSDate date];
    if (sender == _activityStarTimeBtn) {
        if (_startDate) {
            currentDate = _startDate;
        }
    }else if (sender == _activityEndTimeBtn){
        if (_endDate) {
            currentDate = _endDate;
        }
    }
    XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCurrentDate:currentDate CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
        if (!_startDate && !startDate) {
            startDate = currentDate;
        }else{
            if (sender == _activityEndTimeBtn && !startDate){
                startDate = _startDate;
            }
        }
        if (!endDate) {
            endDate = _endDate;
        }
        NSString *startStr = [NSString nullToString:[startDate stringWithFormat:@"yyyy/MM/dd HH:mm"]];
        NSString *endStr = [NSString nullToString:[endDate stringWithFormat:@"yyyy/MM/dd HH:mm"]];
        if (startDate && endDate) {
            if ([startStr isEqualToString:endStr]) {
                [MDB_UserDefault showNotifyHUDwithtext:@"开始时间和结束时间不能相同" inView:self];
                return ;
            }
            if (startDate.timeIntervalSince1970 > endDate.timeIntervalSince1970) {
                [MDB_UserDefault showNotifyHUDwithtext:@"结束时间必须大于开始时间" inView:self];
                return ;
            }
        }
        if (![@"" isEqualToString:startStr]) {
            _startDate = startDate;
            [_activityStarTimeBtn setTitle:startStr forState:UIControlStateNormal];
            [_activityStarTimeBtn setTitle:startStr forState:UIControlStateHighlighted];
        }
        if (![@"" isEqualToString:endStr]) {
            _endDate = endDate;
            [_activityEndTimeBtn setTitle:endStr forState:UIControlStateNormal];
            [_activityEndTimeBtn setTitle:endStr forState:UIControlStateHighlighted];

        }
    }];
    datepicker.datePickerStyle = DateStyleShowYearMonthDayHourMinute;
    if (sender == _activityStarTimeBtn) {
        datepicker.dateType = DateTypeStartDate;
    }else if (sender == _activityEndTimeBtn){
        datepicker.dateType = DateTypeEndDate;
    }
    datepicker.minLimitDate = [NSDate date];
    [datepicker show];
}

- (void)respondsToTypeBtnSelect{
    
    BrokeShareDataController *dataController = [[BrokeShareDataController alloc] init];
    [dataController requestGetCateDataWithInView:self callback:^(NSError *error, BOOL state, NSString *describle) {
        if (dataController.resultMessage) {
            [MDB_UserDefault showNotifyHUDwithtext:dataController.resultMessage inView:self];
        }else{
            BrokeTypeActionSheetView *actionSheetView = [[BrokeTypeActionSheetView alloc] init];
            actionSheetView.types = dataController.requestCateResults;
            actionSheetView.delegate = self;
            [actionSheetView showActionSheet];
        }
    }];
}

- (void)respondsToChoicePhotoBtn:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(brokeInfoSubjectViewDidPressChoicePhotoBtnWithDidComplete:)]) {
        [self.delegate brokeInfoSubjectViewDidPressChoicePhotoBtnWithDidComplete:^(UIImage *image) {
            if (image) {
                _productImageView.image = image;
            }
        }];
    }
}

- (void)respondsToBtnEvent:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 100:
        {
            if ([_productNameTextField.text isEqualToString:@""]) {
                [MDB_UserDefault showNotifyHUDwithtext:@"请输入标题" inView:self];
                return;
            }
            if ([_descriptionTextView.text isEqualToString:@""]) {
                [MDB_UserDefault showNotifyHUDwithtext:@"请填写您推荐的理由" inView:self];
                return;
            }
            if ([[NSString nullToString:_typeId] isEqualToString:@""]) {
                [MDB_UserDefault showNotifyHUDwithtext:@"请选择您爆料的商品类型" inView:self];
                return;
            }
            if ([_productPriceTextField.text isEqualToString:@""]) {
                [MDB_UserDefault showNotifyHUDwithtext:@"请输入您爆料的商品价格" inView:self];
                return;
            }
            if ([_viewModel.linkImgeLink isEqualToString:@""]) {
                [MDB_UserDefault showNotifyHUDwithtext:@"请选择一张合适的爆料图片" inView:self];
                return;
            }
            if (_aType == BrokeTypeActivity) {
                if ([_intensityTextField.text isEqualToString:@""]) {
                    [MDB_UserDefault showNotifyHUDwithtext:@"请输入活动促销力度" inView:self];
                    return;
                }
                if (!_startDate || !_endDate) {
                    [MDB_UserDefault showNotifyHUDwithtext:@"请选择活动时间" inView:self];
                    return;
                }
                if ([_activityTypeStr isEqualToString:@""]) {
                    [MDB_UserDefault showNotifyHUDwithtext:@"请选择活动促销类型" inView:self];
                    return;
                }
            }
           
            
            if ([self.delegate respondsToSelector:@selector(brokeInfoSubjectView:didPressBrokeBtnWithInfo:)]) {
                NSDictionary *dict = @{
                                       @"share_type":@"dp",
                                       @"url":[NSString nullToString:_viewModel.linkurl],
                                       @"image":_viewModel.linkImgeLink,
                                       @"title":[NSString nullToString:_productNameTextField.text],
                                       @"category":[NSString nullToString:_typeId],
                                       @"proprice":[NSString nullToString:_productPriceTextField.text],
                                       @"description":[NSString nullToString:_descriptionTextView.text],
                                       @"token":[NSString nullToString:_viewModel.token],
                                       @"session":[NSString nullToString:_viewModel.session]
                                       };
                if (_aType == BrokeTypeActivity) {
                    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                    [mutableDict setObject:@"ac" forKey:@"share_type"];
                    [mutableDict setObject:_activityTypeStr forKey:@"type"];
                    [mutableDict setObject:_intensityTextField.text forKey:@"prodescription"];
                    [mutableDict setObject:[NSString nullToString:[_startDate stringWithFormat:@"yyyy/MM/dd HH:mm:ss"]] forKey:@"starttime"];
                    [mutableDict setObject:[NSString nullToString:[_endDate stringWithFormat:@"yyyy/MM/dd HH:mm:ss"]] forKey:@"endtime"];
                    dict = mutableDict.mutableCopy;
                }
                [self.delegate brokeInfoSubjectView:self didPressBrokeBtnWithInfo:dict];
            }
        }
            break;
        case 110:
        {
            if ([self.delegate respondsToSelector:@selector(brokeInfoSubjectViewDidPressNoBrokeBtn)]) {
                [self.delegate brokeInfoSubjectViewDidPressNoBrokeBtn];
            }
        }
            break;

        default:
            break;
    }
}

- (void)bindDataWithViewModel:(BrokeInfoViewModel *)viewModel{
    _viewModel = viewModel;
   [[MDB_UserDefault defaultInstance] setViewWithImage:_productImageView url:viewModel.linkImgeLink options:SDWebImageHighPriority];
    _productNameTextField.text = viewModel.title;
    _productPriceTextField.text = viewModel.proprice;
    _linkLabel.text = viewModel.linkurl;
    if(_viewModel.coinsign.length>0)
    {
//        _productPricePromptLabel.text = @"商品价格：";
        [_productPricePromptLabel setAttributedText:[self arrstring:[NSString stringWithFormat:@"商品价格(%@)：",viewModel.coinsign] andstart:4 andend:viewModel.coinsign.length+2 andcolor:RadMenuColor andfont:_productPricePromptLabel.font]];
        
        if(![_viewModel.coinsign isEqualToString:@"¥"])
        {
            [_zheherenmingbiLabel setText:@"折合人民币：￥0"];
            [_zheherenmingbiLabel setHidden:NO];
            [_zheherenmingbiLabel mas_updateConstraints:^(MASConstraintMaker *make) {
               
                make.height.offset(25);
            }];
            [self textFieldChageValue];
        }
        
    }
    
    
}

///设置一行显示不同字体 颜色
-(NSMutableAttributedString *)arrstring:(NSString *)str andstart:(NSInteger)istart andend:(NSInteger)length andcolor:(UIColor *)color andfont:(UIFont *)font
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
    @try {
        [noteStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(istart, length)];
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(istart, length)];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    return noteStr;
}

#pragma mark - BrokeTypeAlertViewDelegate
- (void)brokeTypeActionSheetView:(BrokeTypeActionSheetView *)alertView didSelectType:(NSDictionary *)dict{
    _productTypeConentLabel.text = dict[@"name"];
    _typeId = dict[@"id"];
}

#pragma mark - setter and getter
- (NSArray *)activityTypes{
    if (!_activityTypes) {
        _activityTypes = @[@"购买直降",@"满额优惠",@"混合专场和其他"];
    }
    return _activityTypes;
}

#pragma mark - textFieldChageValue
-(void)textFieldChageValue
{
    float fchangeprice = _productPriceTextField.text.floatValue*_viewModel.exchange.floatValue;
    
    [_zheherenmingbiLabel setText:[NSString stringWithFormat:@"折合人民币：￥%.2lf",fchangeprice]];
    
}


@end
