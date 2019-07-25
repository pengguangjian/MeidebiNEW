//
//  VolumeContentSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2016/9/29.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "VolumeContentSubjectView.h"
#import "MDB_UserDefault.h"
#import "MDBwebVIew.h"

@interface VolumeContentSubjectView ()
<
MDBwebDelegate
>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *limitLabel;
@property (nonatomic, strong) UILabel *versatilityLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *exchangeLabel;
@property (nonatomic, strong) UILabel *exchangeEndDateLabel;
@property (nonatomic, strong) UILabel *useBeginDateLabel;
@property (nonatomic, strong) UILabel *useEndDateLabel;
@property (nonatomic, strong) MDBwebVIew *webView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineTwoView;
@end

@implementation VolumeContentSubjectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    if(_scrollView)return;
    
    _scrollView = [UIScrollView new];
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _contairView = [UIView new];
    [_scrollView addSubview:_contairView];
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    _iconImageView = [UIImageView new];
    [_contairView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contairView.mas_top).offset(15);
        make.left.right.equalTo(_contairView);
        make.height.offset(120);
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *lineView = [UIView new];
    [_contairView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(20);
        make.left.right.equalTo(_contairView);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    
    _describeLabel = [UILabel new];
    [_contairView addSubview:_describeLabel];
    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contairView.mas_left).offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.right.equalTo(_contairView.mas_right).offset(-15);
    }];
    _describeLabel.numberOfLines = 0;
    _describeLabel.font = [UIFont systemFontOfSize:14.f];
    _describeLabel.textColor = [UIColor grayColor];
    
    
    _limitLabel = [UILabel new];
    [_contairView  addSubview:_limitLabel];
    [_limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_describeLabel);
        make.top.equalTo(_describeLabel.mas_bottom).offset(10);
    }];
    _limitLabel.textColor = RadMenuColor;
    _limitLabel.font = [UIFont systemFontOfSize:15.f];
    

    _versatilityLabel = [UILabel new];
    [_contairView addSubview:_versatilityLabel];
    [_versatilityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_describeLabel.mas_left);
        make.top.equalTo(_limitLabel.mas_bottom).offset(10);
    }];
    _versatilityLabel.font = [UIFont systemFontOfSize:14];
    _versatilityLabel.textColor = [UIColor grayColor];
    
    
    _levelLabel = [UILabel new];
    [_contairView addSubview:_levelLabel];
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_describeLabel.mas_left);
        make.top.equalTo(_versatilityLabel.mas_bottom).offset(10);

    }];
    _levelLabel.font = _versatilityLabel.font;
    _levelLabel.textColor = _versatilityLabel.textColor;

    
    _exchangeLabel = [UILabel new];
    [_contairView addSubview:_exchangeLabel];
    [_exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_describeLabel.mas_left);
        make.top.equalTo(_levelLabel.mas_bottom).offset(10);
    }];
    _exchangeLabel.font = _levelLabel.font;
    _exchangeLabel.textColor = _levelLabel.textColor;

    
    _exchangeEndDateLabel = [UILabel new];
    [_contairView addSubview:_exchangeEndDateLabel];
    [_exchangeEndDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_describeLabel.mas_left);
        make.top.equalTo(_exchangeLabel.mas_bottom).offset(10);
    }];
    
    _useBeginDateLabel = [UILabel new];
    [_contairView addSubview:_useBeginDateLabel];
    [_useBeginDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_describeLabel.mas_left);
        make.top.equalTo(_exchangeEndDateLabel.mas_bottom).offset(10);
    }];
 
    
    _useEndDateLabel = [UILabel new];
    [_contairView addSubview:_useEndDateLabel];
    [_useEndDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_describeLabel.mas_left);
        make.top.equalTo(_useBeginDateLabel.mas_bottom).offset(10);
    }];

    
    UIView *lineTwoView = [UIView new];
    [_contairView addSubview:lineTwoView];
    [lineTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_useEndDateLabel.mas_bottom).offset(20);
        make.left.right.equalTo(_contairView);
        make.height.offset(1);
    }];
    lineTwoView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    _lineTwoView = lineTwoView;
    
    _webView = [[MDBwebVIew alloc] init];
    [_contairView addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwoView.mas_bottom).offset(10);
        make.left.equalTo(_contairView.mas_left).offset(10);
        make.right.equalTo(_contairView.mas_right).offset(-10);
        make.height.offset(300);
    }];
    _webView.delegate = self;
    
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_webView.mas_bottom).offset(20);
    }];
}

- (void)bindDataWithModel:(NSDictionary *)model{
    
    if (![model[@"title"] isKindOfClass:[NSNull class]]) {
        _describeLabel.text=[NSString stringWithFormat:@"%@",model[@"title"]];
    }
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model[@"imgUrl"]];
    _versatilityLabel.text=[NSString stringWithFormat:@"是否全场通用：%@",[model[@"allgoods"] isEqualToString:@"0"]?@"是":@"否"];
//    if (![model[@"copper"] isKindOfClass:[NSNull class]]) {
//        _limitLabel.text=[NSString stringWithFormat:@"%@铜币兑换",model[@"copper"]];
//    }
    
    NSString *strcopper = [NSString stringWithFormat:@"%@",[model objectForKey:@"copper"]];
    NSString *strcontribution = [NSString stringWithFormat:@"%@",[model objectForKey:@"contribution"]];
    NSString *strchangetype = [NSString stringWithFormat:@"%@",[model objectForKey:@"changetype"]];
    
    if([strchangetype isEqualToString:@"1"])
    {
        _limitLabel.text=[NSString stringWithFormat:@"%@铜币兑换",strcopper];
    }
    else if([strchangetype isEqualToString:@"2"])
    {
        _limitLabel.text=[NSString stringWithFormat:@"%@贡献值兑换",strcontribution];
    }
    else if([strchangetype isEqualToString:@"3"])
    {
        _limitLabel.text=[NSString stringWithFormat:@"%@铜币 或 %@贡献值兑换",strcopper,strcontribution];
    }
    
    
    if (![model[@"buylevel"] isKindOfClass:[NSNull class]]) {
        _levelLabel.text=[NSString stringWithFormat:@"兑换等级：Lv.%@",model[@"buylevel"]];
    }
    _exchangeLabel.text=[NSString stringWithFormat:@"是否允许新用户兑换：%@",[model[@"buylevel"]isEqualToString:@"0"]?@"否":@"是"];
    _exchangeEndDateLabel.attributedText=[self setAttributeStr:@"兑换截止时间：" contentStr:[MDB_UserDefault strTimefromData:[model[@"getend"] integerValue] dataFormat:nil]];
    _useBeginDateLabel.attributedText=[self setAttributeStr:@"使用开始时间：" contentStr:[MDB_UserDefault strTimefromData:[model[@"usestart"] integerValue] dataFormat:nil]];
    _useEndDateLabel.attributedText=[self setAttributeStr:@"使用结束时间：" contentStr:[MDB_UserDefault strTimefromData:[model[@"useend"] integerValue] dataFormat:nil]];
    _webView.htmlStr = model[@"description"];
}

- (void)bindMaterialDataWithModel:(NSDictionary *)model{
    if (![model[@"title"] isKindOfClass:[NSNull class]]) {
        _describeLabel.text=[NSString stringWithFormat:@"%@",model[@"title"]];
    }
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:model[@"image"]];
//    if (![model[@"copper"] isKindOfClass:[NSNull class]]) {
//        _limitLabel.text=[NSString stringWithFormat:@"%@铜币兑换",model[@"copper"]];
//    }
    NSString *strcopper = [NSString stringWithFormat:@"%@",[model objectForKey:@"copper"]];
    NSString *strcontribution = [NSString stringWithFormat:@"%@",[model objectForKey:@"contribution"]];
    NSString *strchangetype = [NSString stringWithFormat:@"%@",[model objectForKey:@"changetype"]];
    
    if([strchangetype isEqualToString:@"1"])
    {
        _limitLabel.text=[NSString stringWithFormat:@"%@铜币兑换",strcopper];
    }
    else if([strchangetype isEqualToString:@"2"])
    {
        _limitLabel.text=[NSString stringWithFormat:@"%@贡献值兑换",strcontribution];
    }
    else if([strchangetype isEqualToString:@"3"])
    {
        _limitLabel.text=[NSString stringWithFormat:@"%@铜币 或 %@贡献值兑换",strcopper,strcontribution];
    }
    
    
    if (![model[@"minlevel"] isKindOfClass:[NSNull class]]) {
        _levelLabel.text=[NSString stringWithFormat:@"兑换等级：Lv.%@",model[@"minlevel"]];
        [_levelLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_describeLabel.mas_left);
            make.top.equalTo(_limitLabel.mas_bottom).offset(10);
        }];
    }
    _webView.htmlStr = model[@"description"];
    _exchangeEndDateLabel.attributedText=[self setAttributeStr:@"兑换截止时间：" contentStr:[MDB_UserDefault strTimefromData:[model[@"endtime"] integerValue] dataFormat:nil]];
    [_exchangeEndDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_describeLabel.mas_left);
        make.top.equalTo(_levelLabel.mas_bottom).offset(10);
    }];
    if ([[NSString nullToString:model[@"iscard"]] isEqualToString:@"1"]) {
        _useBeginDateLabel.attributedText=[self setAttributeStr:@"使用开始时间：" contentStr:[MDB_UserDefault strTimefromData:[model[@"usestarttime"] integerValue] dataFormat:nil]];
        _useEndDateLabel.attributedText=[self setAttributeStr:@"使用结束时间：" contentStr:[MDB_UserDefault strTimefromData:[model[@"useendtime"] integerValue] dataFormat:nil]];
    }else{
        [_lineTwoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_exchangeEndDateLabel.mas_bottom).offset(10);
            make.left.right.equalTo(_contairView);
            make.height.offset(1);
        }];
    }

}

- (NSAttributedString *)setAttributeStr:(NSString *)fixationStr
                             contentStr:(NSString *)contentStr{
    if (!fixationStr || !contentStr) return nil;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[fixationStr stringByAppendingString:contentStr]];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:14.f]
                         range:NSMakeRange(0, fixationStr.length)];
    [attributeStr addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:12.f]
                         range:NSMakeRange(fixationStr.length, contentStr.length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor grayColor]
                         range:NSMakeRange(0, contentStr.length+fixationStr.length)];
    return attributeStr.mutableCopy;
}

#pragma mark - MDBwebDelegate
- (void)webViewDidFinishLoad:(float)h webview:(MDBwebVIew *)webView{
    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(h);
    }];
}

- (void)webViewDidPreseeUrlWithLink:(NSString *)link webview:(MDBwebVIew *)webView{
    [self.delegate volumeSubjectView:self didSelectWebLink:link];
}
@end
