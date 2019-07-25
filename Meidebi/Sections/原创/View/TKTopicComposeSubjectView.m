//
//  TKTopicComposeSubjectView.m
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/17.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKTopicComposeSubjectView.h"
#import "MDB_UserDefault.h"
#import <ZYCornerRadius/UIImageView+CornerRadius.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UITextView+Placeholder.h"
#import "TKPictureSelectToolView.h"


static NSString * const kTopicItemName = @"name";
static NSString * const kTopicItemIcon = @"image";
static NSString * const kTopicItemType = @"type";


@interface TKTopicMainScrollView : UIScrollView
@end
@implementation TKTopicMainScrollView
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

@interface TKTopicComposeSubjectView ()
<
UITextViewDelegate,
TKPictureSelectToolViewDelegate
>
@property (nonatomic, assign) TKTopicType type;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *typeView;

@property (nonatomic, strong) TKPictureSelectToolView *pictureSelectToolView;

@property (nonatomic, strong) UILabel *lbtopicTypeLabel;
@property (nonatomic, strong) UITextField *fieldtitle;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSArray *topicClassifys;

@property (nonatomic, strong) UIButton *btnowSelectType;
@property (nonatomic, strong) NSMutableArray *arrbtType;
@end

@implementation TKTopicComposeSubjectView

- (instancetype)initWithTopicType:(TKTopicType)type{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _type = type;
        [self configurUI];
    }
    return self;
}

- (void)configurUI{
    TKTopicMainScrollView *scrollView = [TKTopicMainScrollView new];
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-80*kScale);
        
    }];
    scrollView.showsVerticalScrollIndicator = NO;
    [scrollView setScrollEnabled:YES];
    
    
    UIButton *btpush = [[UIButton alloc] initWithFrame:CGRectMake(0, BOUNDS_HEIGHT-80*kScale+10-kStatusBarHeight-kNavBarHeight, BOUNDS_WIDTH/2.0*0.7, 40*kScale)];
    [btpush setRight:BOUNDS_WIDTH/2.0-7];
    [btpush setBackgroundColor:RadMenuColor];
    [btpush setTitle:@"发布" forState:UIControlStateNormal];
    [btpush setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btpush.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btpush.layer setMasksToBounds:YES];
    [btpush.layer setCornerRadius:4];
    [btpush setTag:1];
    [btpush addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btpush];
//    [btpush mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(scrollView.mas_bottom).offset(10);
//        make.height.offset(40*kScale);
//        make.width.offset(BOUNDS_WIDTH/2.0*0.7);
//        make.right.mas_equalTo(scrollView.mas_centerY).offset(-7);
//
//
//    }];
    



    UIButton *btsave = [[UIButton alloc] initWithFrame:CGRectMake(btpush.right+14, btpush.top, btpush.width, btpush.height)];
    [self addSubview:btsave];
//    [btsave mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(btpush.mas_top);
//        make.height.offset(40*kScale);
//        make.left.equalTo(self.mas_centerY).offset(7);
//        make.width.equalTo(btpush.mas_width);
//
//    }];
    [btsave setTitle:@"保存草稿" forState:UIControlStateNormal];
    [btsave setTitleColor:RGB(180, 180, 180) forState:UIControlStateNormal];
    [btsave.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btsave.layer setMasksToBounds:YES];
    [btsave.layer setCornerRadius:4];
    [btsave.layer setBorderColor:RGB(220, 220, 220).CGColor];
    [btsave.layer setBorderWidth:1];
    [btsave setTag:2];
    [btsave addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
    
    ////标题 内容
    _containerView = [UIView new];
    [scrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
//    UIImageView *avatarImageView = [[UIImageView alloc] initWithRoundingRectImageView];
//    [_containerView addSubview:avatarImageView];
//    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_containerView.mas_left).offset(11);
//        make.top.equalTo(_containerView.mas_top).offset(18);
//        make.size.mas_equalTo(CGSizeMake(31, 31));
//    }];
//    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString:[MDB_UserDefault defaultInstance].userphoto]]];
//
//    UILabel *nickeNameLabel = [UILabel new];
//    [_containerView addSubview:nickeNameLabel];
//    [nickeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(avatarImageView.mas_right).offset(8);
//        make.centerY.equalTo(avatarImageView.mas_centerY);
//    }];
//    nickeNameLabel.textColor = [UIColor colorWithHexString:@"#000000"];
//    nickeNameLabel.font = [UIFont systemFontOfSize:11.f];
//    nickeNameLabel.text = [MDB_UserDefault defaultInstance].nickName;
//
//    UILabel *topicTypeLabel = [UILabel new];
//    [_containerView addSubview:topicTypeLabel];
//    [topicTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(avatarImageView.mas_left);
//        make.top.equalTo(avatarImageView.mas_bottom).offset(19);
//    }];
//    topicTypeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
//    topicTypeLabel.font = [UIFont systemFontOfSize:12.f];
//    topicTypeLabel.text = [self backTypeString:_type];
//
//    _lbtopicTypeLabel = topicTypeLabel;
    
    ///类型
    
    _typeView = [UIView new];
    [_containerView addSubview:_typeView];
    [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_containerView);
        make.width.equalTo(scrollView);
    }];
    [_typeView setBackgroundColor:RGB(243, 243, 243)];
    
    [self topicClassifys];
    _arrbtType = [NSMutableArray new];
    NSInteger iline = _topicClassifys.count/4;
    if(_topicClassifys.count%4!=0)
    {
        iline+=1;
    }
    UIButton *bttempitem;
    for(int i = 0 ; i<iline;i++)
    {
        for(int j = 0 ; j <4; j++)
        {
            if(j+i*4>=_topicClassifys.count)break;
            
            UIButton *bttype = [[UIButton alloc] init];
            [_typeView addSubview:bttype];
            [bttype mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(30);
                make.width.offset(BOUNDS_WIDTH*0.25);
                make.left.offset(BOUNDS_WIDTH*0.25*j);
                make.top.offset(20+40*i);
                
            }];
            [bttype setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
            [bttype setTitle:[_topicClassifys[j+i*4] objectForKey:kTopicItemName] forState:UIControlStateNormal];
            [bttype setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
            [bttype.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [bttype setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [bttype setTag:j+i*4];
            [bttype addTarget:self action:@selector(typeSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            bttempitem = bttype;
            [_arrbtType addObject:bttype];
        }
    }
    [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bttempitem.mas_bottom).offset(20);
    }];
    
    
    ///////
    
    UITextField *titleTextField = [UITextField new];
    [_containerView addSubview:titleTextField];
    [titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeView.mas_bottom).offset(11);
        make.left.offset(11);
        make.right.equalTo(_containerView.mas_right).offset(-11);
        make.height.offset(50);
    }];
    titleTextField.placeholder = @"帖子标题....";
    titleTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    titleTextField.contentVerticalAlignment =UIControlContentHorizontalAlignmentCenter;
    titleTextField.font = [UIFont systemFontOfSize:14.f];
    titleTextField.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    titleTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 50)];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    titleTextField.leftView = leftView;
    [titleTextField addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
//    [titleTextField becomeFirstResponder];
    _fieldtitle = titleTextField;
    
    UIView *lineView = [UIView new];
    [_containerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(titleTextField);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    
    UITextView *textView = [UITextView new];
    [_containerView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(titleTextField.mas_left);
        make.right.equalTo(_containerView.mas_right).offset(-11);
        make.height.offset(150);
    }];
    textView.placeholder = @"这里是正文....不少于5个字。文字图片越多，内容越丰富，更有机会被设置为精华哦！";
    textView.textColor = [UIColor colorWithHexString:@"#999999"];
    textView.font = [UIFont systemFontOfSize:14.f];
    textView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 4);
    textView.delegate = self;
    _textView = textView;
    
    UIImageView *flagImageView = [UIImageView new];
    [_containerView addSubview:flagImageView];
    [flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleTextField.mas_left);
        make.top.equalTo(textView.mas_bottom).offset(22);
        make.size.mas_equalTo(CGSizeMake(20, 18));
    }];
    flagImageView.contentMode = UIViewContentModeScaleAspectFit;
    flagImageView.image = [UIImage imageNamed:@"poste_topic_picture_flag"];
    
    UILabel *pictureSelectTitleLabel = [UILabel new];
    [_containerView addSubview:pictureSelectTitleLabel];
    [pictureSelectTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flagImageView.mas_right).offset(7);
        make.centerY.equalTo(flagImageView.mas_centerY);
    }];
    pictureSelectTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    pictureSelectTitleLabel.font = [UIFont systemFontOfSize:12.f];
    NSString *titleStr = @"上传图片";
    NSString *pictureRestrictStr = @"（最多10张）";
    NSString *totalStr = [titleStr stringByAppendingString:pictureRestrictStr];
    NSMutableAttributedString *priceText = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [priceText addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:12]
                      range:NSMakeRange(0, totalStr.length)];
    [priceText addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithHexString:@"#666666"]
                      range:NSMakeRange(0, titleStr.length)];
    [priceText addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithHexString:@"#999999"]
                      range:NSMakeRange(titleStr.length, pictureRestrictStr.length)];
    pictureSelectTitleLabel.attributedText = priceText;
    
    TKPictureSelectToolView *pictureSelectToolView = [TKPictureSelectToolView new];
    [_containerView addSubview:pictureSelectToolView];
    [pictureSelectToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(flagImageView.mas_bottom).offset(25);
        make.left.equalTo(titleTextField.mas_left);
        make.right.equalTo(_containerView.mas_right).offset(-11);
        make.height.offset(kMainScreenW*0.43);
    }];
    pictureSelectToolView.backgroundColor = [UIColor whiteColor];
    pictureSelectToolView.delegate = self;
    _pictureSelectToolView = pictureSelectToolView;
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(pictureSelectToolView.mas_bottom).offset(30);
    }];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self registerKeyWord];
}

- (void)registerKeyWord{
    [self endEditing:YES];
}

- (void) textFieldDidChange:(UITextField*)sender {
    if ([self.delegate respondsToSelector:@selector(topicComposeDidWriteTitle:)]) {
        [self.delegate topicComposeDidWriteTitle:sender.text];
    }
}

#pragma mark - 类别选择
-(void)typeSelectAction:(UIButton *)sender
{
    if(_btnowSelectType != nil)
    {
        [_btnowSelectType setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
    }
    _btnowSelectType = sender;
    [_btnowSelectType setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
    
    _type = [[_topicClassifys[sender.tag]  objectForKey:kTopicItemType] integerValue];
    [self.delegate topicComposeTopicType:_type];
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(topicComposeDidWriteContent:)]) {
        [self.delegate topicComposeDidWriteContent:textView.text];
    }
}


#pragma mark - TKPictureSelectToolViewDelegate
- (void)pictureSelectBeginSkipToTargetVc:(UIViewController *)targetVc{
    if ([self.delegate respondsToSelector:@selector(topicComposeSubjectViewStarSelectImageWithTarget:)]) {
        [self.delegate topicComposeSubjectViewStarSelectImageWithTarget:targetVc];
    }
}

- (void)picturePickerDidSelectPhotos:(NSArray *)photos{
    if ([self.delegate respondsToSelector:@selector(topicComposeDidSelectPictures:)]) {
        [self.delegate topicComposeDidSelectPictures:photos];
    }
    [_pictureSelectToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        NSInteger images = photos.count < 10 ? photos.count + 1 : photos.count;
        if (images>3) {
            NSInteger row = (images/3) + (images%3 > 0 ? 1:0);
            make.height.offset(row*((kMainScreenW - 2 * 4 - 4) / 3 - 4));
        }else{
            make.height.offset(kMainScreenW * 0.43);
        }
    }];
}
- (void)selectTKPictureAction
{
    [self registerKeyWord];
}

-(NSString *)backTypeString:(NSInteger)type
{
    NSString *typeStr = @"";
    switch (type) {
        case TKTopicTypeEnable:
            typeStr = @"#生活经验#";
            break;
        case TKTopicTypeLooks:
            typeStr = @"#服饰鞋包#";
            break;
        case TKTopicTypeBeauty:
            typeStr = @"#美妆护肤#";
            break;
        case TKTopicType3C:
            typeStr = @"#数码家电#";
            break;
        case TKTopicTypeDeliciousfood:
            typeStr = @"美食旅游#";
            break;
        case TKTopicTypeEvaluation:
            typeStr = @"#评测试用#";
            break;
        case TKTopicTypeOther:
            typeStr = @"#其他#";
            break;
        case TKTopicTypeShaiDan:
            typeStr = @"#晒单广场#";
            break;
        case TKTopicTypeSpitslot:
            typeStr = @"#匿名吐槽#";
            break;
        case TKTopicTypeDaily:
            typeStr = @"#日常话题#";
            break;
        case TKTopicTypeShoppingList:
            typeStr = @"#必买清单#";
            break;
        default:
             typeStr = @"#未知#";
            break;
    }
    
    return typeStr;
    
}

///草稿数据
-(void)caogaoValue:(NSDictionary *)dicvalue
{
    _type = [[dicvalue objectForKey:@"type"] integerValue];
    
    for(int i = 0 ; i < _topicClassifys.count; i++)
    {
        NSInteger itemptype = [[_topicClassifys[i] objectForKey:kTopicItemType] integerValue];
        if(_type == itemptype)
        {
            if(_btnowSelectType != nil)
            {
                [_btnowSelectType setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
            }
            _btnowSelectType = _arrbtType[i];
            [_btnowSelectType setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
        }
        
        
    }
    
    
    _lbtopicTypeLabel.text = [self backTypeString:_type];
    _fieldtitle.text = [NSString nullToString:[dicvalue objectForKey:@"title"]];
    _textView.text = [NSString nullToString:[dicvalue objectForKey:@"content"]];
    
    if([[dicvalue objectForKey:@"video_type"] intValue] >0)
    {///视频
        NSMutableArray *arrpics = [NSMutableArray new];
        if([[dicvalue objectForKey:@"video"] isKindOfClass:[NSArray class]])
        {
            NSArray *arrvideo = [dicvalue objectForKey:@"video"];
            for(NSDictionary *dic in arrvideo)
            {
                NSString *strvodiourl = [NSString nullToString:[dic objectForKey:@"video_url"]];
                [arrpics addObject:[NSURL URLWithString:strvodiourl]];
            }
            
        }
        
        [_pictureSelectToolView setcaogaoImage:arrpics];
        [_pictureSelectToolView mas_updateConstraints:^(MASConstraintMaker *make) {
            NSInteger images = arrpics.count < 10 ? arrpics.count + 1 : arrpics.count;
            if (images>3) {
                NSInteger row = (images/3) + (images%3 > 0 ? 1:0);
                make.height.offset(row*((kMainScreenW - 2 * 4 - 4) / 3 - 4));
            }else{
                make.height.offset(kMainScreenW * 0.43);
            }
        }];
    }
    else
    {
        if([[dicvalue objectForKey:@"pics"] isKindOfClass:[NSArray class]])
        {
            NSArray *arrpics = [dicvalue objectForKey:@"pics"];
            NSMutableArray *arrtemp = [[NSMutableArray alloc] initWithArray:arrpics];
            if(arrtemp.count == 1)
            {
                if([[NSString nullToString:arrtemp[0]] isEqualToString:@"0"])
                {
                    [arrtemp removeObjectAtIndex:0];
                }
            }
            
            [_pictureSelectToolView setcaogaoImage:arrtemp];
            [_pictureSelectToolView mas_updateConstraints:^(MASConstraintMaker *make) {
                NSInteger images = arrtemp.count < 10 ? arrtemp.count + 1 : arrtemp.count;
                if (images>3) {
                    NSInteger row = (images/3) + (images%3 > 0 ? 1:0);
                    make.height.offset(row*((kMainScreenW - 2 * 4 - 4) / 3 - 4));
                }else{
                    make.height.offset(kMainScreenW * 0.43);
                }
            }];
        }
    }
    
    
}

-(void)bottomAction:(UIButton *)sender
{
    [self.delegate topicComposeBottomActionTag:sender.tag];
    
}




- (NSArray *)topicClassifys{
    if (!_topicClassifys) {
        _topicClassifys = @[
                            @{kTopicItemName:@"生活经验",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_enable"],
                              kTopicItemType:@(TKTopicTypeEnable)
                              },
                            @{kTopicItemName:@"服饰鞋包",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_looks"],
                              kTopicItemType:@(TKTopicTypeLooks)
                              },
                            @{kTopicItemName:@"美妆护肤",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_meizhuanghufu"],
                              kTopicItemType:@(TKTopicTypeBeauty)
                              },
                            @{kTopicItemName:@"数码家电",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_3Cshuma"],
                              kTopicItemType:@(TKTopicType3C)
                              },
                            @{kTopicItemName:@"美食旅游",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_meishilvyou"],
                              kTopicItemType:@(TKTopicTypeDeliciousfood)
                              },
                            @{kTopicItemName:@"评测试用",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_evaluation"],
                              kTopicItemType:@(TKTopicTypeEvaluation)
                              },
                            @{kTopicItemName:@"匿名吐槽",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_spitslot"],
                              kTopicItemType:@(TKTopicTypeSpitslot)
                              },
//                            @{kTopicItemName:@"日常话题",
//                              kTopicItemIcon:[UIImage imageNamed:@"topic_daily"],
//                              kTopicItemType:@(TKTopicTypeDaily)
//                              },
                            @{kTopicItemName:@"其他",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_other"],
                              kTopicItemType:@(TKTopicTypeOther)
                              }];
    }
    return _topicClassifys;
}

@end
