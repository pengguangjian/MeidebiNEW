//
//  BargainActivityDetailSubjectView.m
//  Meidebi
//
//  Created by leecool on 2017/10/16.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BargainActivityDetailSubjectView.h"
#import "MDBwebVIew.h"
#import "MDB_UserDefault.h"

static NSInteger const kBtnParticipationTag = 100000;
static NSInteger const kBtnRankTag = 100001;
static NSInteger const kBtnShareTag = 100002;
static NSInteger const kBtnBargainTag = 100003;
static NSInteger const kBtnHelpRecordTag = 100004;
static NSInteger const kBtnBuyTag = 100005;
static NSInteger const kBtnUpdateAddressTag = 100006;

@interface BargainActivityDetailSubjectView ()
<
MDBwebDelegate
>
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *itemParticipantNumberLabel;
@property (nonatomic, strong) UILabel *itemInventoryNumberLabel;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UILabel *priceDescribeLabel;
@property (nonatomic, strong) MDBwebVIew *itemDescribeWebView;
@property (nonatomic, strong) UIButton *participationBtn;
@property (nonatomic, strong) UIButton *rank1Btn;
@property (nonatomic, strong) UIView *recordHandleView;
@property (nonatomic, strong) UIView *addressContanierView;
@property (nonatomic, strong) UIView *handleView;
@property (nonatomic, strong) NSDictionary *bargainInfoDict;
@end

@implementation BargainActivityDetailSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _handleView = [UIView new];
    [self addSubview:_handleView];
    [_handleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(85);
    }];
    _handleView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    
    UIScrollView *mainScrollView = [UIScrollView new];
    [self addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(_handleView.mas_top);
    }];
    
    _containerView = [UIView new];
    [mainScrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(mainScrollView);
    }];
    
    _iconImageView = [UIImageView new];
    [_containerView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top).offset(14);
        make.left.equalTo(_containerView.mas_left).offset(23);
        make.right.equalTo(_containerView.mas_right).offset(-23);
        make.height.equalTo(_iconImageView.mas_width);
    }];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *purchaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iconImageView addSubview:purchaseBtn];
    [purchaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_iconImageView.mas_right).offset(-5);
        make.bottom.equalTo(_iconImageView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    purchaseBtn.contentMode = UIViewContentModeScaleAspectFit;
    purchaseBtn.tag = kBtnBuyTag;
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"bargain_activity_buy"] forState:UIControlStateNormal];
    [purchaseBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLabel = [UILabel new];
    [_containerView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_iconImageView);
        make.top.equalTo(_iconImageView.mas_bottom).offset(20);
    }];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.font = [UIFont systemFontOfSize:16.f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _itemParticipantNumberLabel = [UILabel new];
    [_containerView addSubview:_itemParticipantNumberLabel];
    [_itemParticipantNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(20);
        make.left.equalTo(_iconImageView.mas_left);
    }];
    _itemParticipantNumberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _itemParticipantNumberLabel.font = [UIFont systemFontOfSize:12.f];
    
    _itemInventoryNumberLabel = [UILabel new];
    [_containerView addSubview:_itemInventoryNumberLabel];
    [_itemInventoryNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemParticipantNumberLabel.mas_top);
        make.right.equalTo(_iconImageView.mas_right);
    }];
    _itemInventoryNumberLabel.textAlignment = NSTextAlignmentRight;
    _itemInventoryNumberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _itemInventoryNumberLabel.font = [UIFont systemFontOfSize:12.f];
    
    UIView *lineView = [UIView new];
    [_containerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.top.equalTo(_itemInventoryNumberLabel.mas_bottom).offset(24);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
    UIView *countdownContainerView = [UIView new];
    [_containerView addSubview:countdownContainerView];
    [countdownContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(16);
        make.left.right.equalTo(_iconImageView);
        make.height.offset(40);
    }];
    countdownContainerView.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    countdownContainerView.layer.masksToBounds = YES;
    countdownContainerView.layer.cornerRadius = 4.f;
    
    _countdownLabel = [UILabel new];
    [countdownContainerView addSubview:_countdownLabel];
    [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(countdownContainerView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    _countdownLabel.textAlignment = NSTextAlignmentCenter;
    _countdownLabel.textColor = [UIColor colorWithHexString:@"#F35D00"];
    _countdownLabel.font = [UIFont systemFontOfSize:14.f];

    _priceDescribeLabel = [UILabel new];
    [_containerView addSubview:_priceDescribeLabel];
    [_priceDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_iconImageView);
        make.top.equalTo(countdownContainerView.mas_bottom).offset(20);
    }];
    _priceDescribeLabel.numberOfLines = 0;
    _priceDescribeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _priceDescribeLabel.font = [UIFont systemFontOfSize:12.f];
    _priceDescribeLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *line1View = [UIView new];
    [_containerView addSubview:line1View];
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.top.equalTo(_priceDescribeLabel.mas_bottom).offset(24);
        make.height.offset(1);
    }];
    line1View.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
    _itemDescribeWebView = [MDBwebVIew new];
    [_containerView addSubview:_itemDescribeWebView];
    [_itemDescribeWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1View.mas_bottom).offset(19);
        make.left.equalTo(_containerView.mas_left).offset(5);
        make.right.equalTo(_containerView.mas_right).offset(-5);
        make.height.offset(300);
    }];
    _itemDescribeWebView.delegate = self;
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_itemDescribeWebView.mas_bottom);
    }];
    
    [self setupBottomHandleView];
}

- (void)setupBottomHandleView{
    
    _recordHandleView = [UIView new];
    [_handleView addSubview:_recordHandleView];
    [_recordHandleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_handleView.mas_top).offset(20);
        make.left.right.equalTo(_handleView);
        make.height.offset(1);
    }];
    _recordHandleView.hidden = YES;
    
    UIButton *helpRcordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordHandleView addSubview:helpRcordBtn];
    [helpRcordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_recordHandleView.mas_left).offset(23);
        make.top.bottom.equalTo(_recordHandleView);
    }];
    helpRcordBtn.tag = kBtnHelpRecordTag;
    [helpRcordBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [helpRcordBtn setTitle:@"查看好友帮助记录" forState:UIControlStateNormal];
    [helpRcordBtn setTitleColor:[UIColor colorWithHexString:@"#F35D00"] forState:UIControlStateNormal];
    helpRcordBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    helpRcordBtn.layer.borderWidth = 1.f;
    helpRcordBtn.layer.borderColor = [UIColor colorWithHexString:@"#F35D00"].CGColor;
    
    UIButton *rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordHandleView addSubview:rankBtn];
    [rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_recordHandleView.mas_right).offset(-23);
        make.left.equalTo(helpRcordBtn.mas_right).offset(25);
        make.top.bottom.equalTo(_recordHandleView);
        make.width.equalTo(helpRcordBtn.mas_width);
    }];
    rankBtn.tag = kBtnRankTag;
    [rankBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [rankBtn setTitle:@"排行榜" forState:UIControlStateNormal];
    [rankBtn setTitleColor:[UIColor colorWithHexString:@"#F35D00"] forState:UIControlStateNormal];
    rankBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    rankBtn.layer.borderWidth = 1.f;
    rankBtn.layer.borderColor = [UIColor colorWithHexString:@"#F35D00"].CGColor;
    
    
    UIButton *participationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handleView addSubview:participationBtn];
    [participationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_handleView.mas_left).offset(23);
        make.top.equalTo(_recordHandleView.mas_bottom);
        make.height.offset(45);
    }];
    participationBtn.tag = kBtnParticipationTag;
    [participationBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [participationBtn setTitle:@"我要参与" forState:UIControlStateNormal];
    [participationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    participationBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [participationBtn setBackgroundColor:[UIColor colorWithHexString:@"#F35D00"]];
    participationBtn.layer.masksToBounds = YES;
    participationBtn.layer.cornerRadius = 4.f;
    _participationBtn = participationBtn;
    
    UIButton *rank1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handleView addSubview:rank1Btn];
    [rank1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_handleView.mas_right).offset(-23);
        make.left.equalTo(participationBtn.mas_right).offset(25);
        make.top.equalTo(_recordHandleView.mas_bottom);
        make.width.equalTo(participationBtn.mas_width);
        make.height.offset(45);
    }];
    rank1Btn.tag = kBtnRankTag;
    [rank1Btn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [rank1Btn setTitle:@"排行榜" forState:UIControlStateNormal];
    [rank1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rank1Btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [rank1Btn setBackgroundColor:[UIColor colorWithHexString:@"#F35D00"]];
    rank1Btn.layer.masksToBounds = YES;
    rank1Btn.layer.cornerRadius = 4.f;
    _rank1Btn = rank1Btn;
    
    [self setupAddressView];
    
}

- (void)setupAddressView{
    UIView *addressContanierView = [UIView new];
    [_handleView addSubview:addressContanierView];
    _addressContanierView = addressContanierView;
    [addressContanierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_recordHandleView.mas_bottom);
        make.left.right.bottom.equalTo(_handleView);
    }];
    _addressContanierView.hidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressContanierView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressContanierView.mas_top).offset(16);
        make.left.equalTo(addressContanierView.mas_left).offset(23);
        make.right.equalTo(addressContanierView.mas_right).offset(-23);
        make.height.offset(45);
    }];
    button.tag = kBtnUpdateAddressTag;
    [button addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"已获得免费资格，请尽快联系客服" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [button setBackgroundColor:[UIColor colorWithHexString:@"#F35D00"]];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4.f;
    button.userInteractionEnabled = NO;
    
    UILabel *titleLabel = [UILabel new];
    [addressContanierView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(button);
        make.top.equalTo(button.mas_bottom).offset(20);
    }];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.font = [UIFont systemFontOfSize:12.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"请于活动结束24小时内联系客服，逾期作废";
    
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    switch (sender.tag) {
        case kBtnParticipationTag:
            if ([self.delegate respondsToSelector:@selector(bargainActivityDetailSubjectViewDidClickParticipationBtn:)]) {
                [self.delegate bargainActivityDetailSubjectViewDidClickParticipationBtn:[NSString nullToString:_bargainInfoDict[@"id"]]];
            }
            break;
        case kBtnRankTag:
            if ([self.delegate respondsToSelector:@selector(bargainActivityDetailSubjectViewDidClickRankBtn:)]) {
                [self.delegate bargainActivityDetailSubjectViewDidClickRankBtn:[NSString nullToString:_bargainInfoDict[@"id"]]];
            }
            break;
        case kBtnHelpRecordTag:
            if ([self.delegate respondsToSelector:@selector(bargainActivityDetailSubjectViewDidClickRecordBtn:)]) {
                [self.delegate bargainActivityDetailSubjectViewDidClickRecordBtn:[NSString nullToString:_bargainInfoDict[@"id"]]];
            }
            break;
        case kBtnBuyTag:
            if ([self.delegate respondsToSelector:@selector(bargainActivityDetailSubjectViewDidClickBuyBtn:)]) {
                [self.delegate bargainActivityDetailSubjectViewDidClickBuyBtn:[NSString nullToString:_bargainInfoDict[@"share_id"]]];
            }
            
            break;
        case kBtnShareTag:
            if ([self.delegate respondsToSelector:@selector(bargainActivityDetailSubjectViewDidClickShareBtn:)]) {
                [self.delegate bargainActivityDetailSubjectViewDidClickShareBtn:[NSString nullToString:_bargainInfoDict[@"id"]]];
            }
            break;
        case kBtnBargainTag:
            if ([self.delegate respondsToSelector:@selector(bargainActivityDetailSubjectViewDidClickBargainBtn:)]) {
                [self.delegate bargainActivityDetailSubjectViewDidClickBargainBtn:[NSString nullToString:_bargainInfoDict[@"id"]]];
            }
            break;
        case kBtnUpdateAddressTag:
            if ([self.delegate respondsToSelector:@selector(bargainActivityDetailSubjectViewDidClickUpdateAddressBtn)]) {
                [self.delegate bargainActivityDetailSubjectViewDidClickUpdateAddressBtn];
            }
            break;
            
        default:
            break;
    }
}

- (void)bindDataWithModel:(NSDictionary *)dict{
    if (dict) {
        self.hidden = NO;
    }else{
        return;
    }
    _bargainInfoDict = dict;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:dict[@"cover"]] options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        _activityImage = image;
    }];
    _titleLabel.text = [NSString nullToString:dict[@"title"]];
    _itemParticipantNumberLabel.text = [NSString stringWithFormat:@"参与人数：%@",[NSString nullToString:dict[@"participant"] preset:@"0"]];
    _itemInventoryNumberLabel.text = [NSString stringWithFormat:@"剩余数量：%@",[NSString nullToString:dict[@"number"] preset:@"0"]];
    _countdownLabel.text = [NSString stringWithFormat:@"结束时间：%@",[MDB_UserDefault strTimefromDatas:[NSDate dateWithTimeIntervalSince1970:[[NSString nullToString:dict[@"endtime"]] integerValue]] dataFormat:@"yyyy-MM-dd HH:mm"]];
    NSString *bargainNumbers = [NSString nullToString:dict[@"required"] preset:@"0"];
    NSString *describe = [NSString stringWithFormat:@"当前¥%@元，砍至¥0.00元，需砍价",[NSString nullToString:dict[@"price"] preset:@"0"]];
    NSString *unitStr = @"次";
    NSString *sumStr = [NSString stringWithFormat:@"%@%@%@",describe,bargainNumbers,unitStr];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:sumStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#333333"]
                          range:NSMakeRange(0, describe.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#E4000E"]
                          range:NSMakeRange(describe.length, bargainNumbers.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#333333"]
                          range:NSMakeRange(bargainNumbers.length, unitStr.length)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12]
                          range:NSMakeRange(0, sumStr.length)];
    _priceDescribeLabel.attributedText = attributedStr.mutableCopy;
    _itemDescribeWebView.webDescription = [NSString nullToString:dict[@"description"]];
    _addressContanierView.hidden = YES;
    _participationBtn.hidden = YES;
    _rank1Btn.hidden = YES;
    [_handleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(85);
    }];
    
    // 获得免费机会
    if ([@"1" isEqualToString:[NSString nullToString:dict[@"is_winning"]]]) {
        [_recordHandleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(40);
        }];
        [_handleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(170);
        }];
        _recordHandleView.hidden = NO;
        _addressContanierView.hidden = NO;
    }else{
        // 已抢完 || 已过期
        if ([NSString nullToString:dict[@"number"] preset:@"0"].integerValue <= 0 ||
            [[NSString nullToString:dict[@"status"]] intValue] == 0) {
            [_recordHandleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(40);
            }];
            _recordHandleView.hidden = NO;
            return;
        }
        // 参与了活动
        if ([@"1" isEqualToString:[NSString nullToString:dict[@"is_part"]]]) {
            _recordHandleView.hidden = YES;
            _participationBtn.hidden = NO;
            _rank1Btn.hidden = NO;
            
            [_recordHandleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(40);
            }];
            [_participationBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_recordHandleView.mas_bottom).offset(20);
            }];
            [_rank1Btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_recordHandleView.mas_bottom).offset(20);
            }];
            [_handleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(150);
            }];
            _recordHandleView.hidden = NO;
            // 已经自砍
            if ([@"1" isEqualToString:[NSString nullToString:dict[@"is_self"]]]) {
                [_participationBtn setBackgroundColor:[UIColor colorWithHexString:@"#C0C0C0"]];
                [_participationBtn setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
                _participationBtn.userInteractionEnabled = NO;
            }
            [_participationBtn setTitle:@"自砍一刀" forState:UIControlStateNormal];
            [_rank1Btn setTitle:@"找朋友帮忙砍" forState:UIControlStateNormal];
            _participationBtn.tag = kBtnBargainTag;
            _rank1Btn.tag = kBtnShareTag;
        }else{
            _recordHandleView.hidden = YES;
            _participationBtn.hidden = NO;
            _rank1Btn.hidden = NO;
        }
        
    }

}

#pragma mark - MDBwebDelegate
- (void)webViewDidFinishLoad:(float)h webview:(MDBwebVIew *)webView{
    [_itemDescribeWebView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(h);
    }];
}
- (void)webViewDidPreseeUrlWithLink:(NSString *)link webview:(MDBwebVIew *)webView{
    if ([self.delegate respondsToSelector:@selector(bargainActivityDetailSubjectViewDidClickWebUrl:)]) {
        [self.delegate bargainActivityDetailSubjectViewDidClickWebUrl:link];
    }
}
@end
