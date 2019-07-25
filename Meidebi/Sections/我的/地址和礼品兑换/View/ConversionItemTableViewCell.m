//
//  ConversionItemTableViewCell.m
//  
//
//  Created by mdb-admin on 2017/6/22.
//
//

#import "ConversionItemTableViewCell.h"
#import "MDB_UserDefault.h"
@interface ConversionItemTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *cionLabel;
@property (nonatomic, strong) UILabel *itemTypeLabel;
@property (nonatomic, strong) UILabel *conversionLevelLabel;
@property (nonatomic, strong) UILabel *conversionTimeLabel;

///贡献值兑换按钮
@property (nonatomic, strong) UIButton *btgongxianzhi;
///铜币兑换按钮
@property (nonatomic, strong) UIButton *conversionBtn;

@end

@implementation ConversionItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _cionLabel = [UILabel new];
    [self.contentView addSubview:_cionLabel];
    [_cionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_bottom).offset(15);
        make.left.equalTo(_iconImageView);
        make.width.offset(BOUNDS_WIDTH-200);
    }];
    [_cionLabel setNumberOfLines:2];
    _cionLabel.textAlignment = NSTextAlignmentLeft;
    _cionLabel.font = [UIFont systemFontOfSize:13.f];
    _cionLabel.textColor = [UIColor colorWithHexString:@"#F2463A"];
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top).offset(10);
        make.left.equalTo(_iconImageView.mas_right).offset(18);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
    }];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    _itemTypeLabel = [UILabel new];
    [self.contentView addSubview:_itemTypeLabel];
    [_itemTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        make.left.right.equalTo(_nameLabel);
    }];
    _itemTypeLabel.font = [UIFont systemFontOfSize:14.f];
    _itemTypeLabel.textColor = [UIColor colorWithHexString:@"#999999"];

    _conversionLevelLabel = [UILabel new];
    [self.contentView addSubview:_conversionLevelLabel];
    [_conversionLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemTypeLabel.mas_bottom).offset(10);
        make.left.right.equalTo(_nameLabel);
    }];
    _conversionLevelLabel.font = [UIFont systemFontOfSize:14.f];
    _conversionLevelLabel.textColor = [UIColor colorWithHexString:@"#999999"];

    _conversionTimeLabel = [UILabel new];
    [self.contentView addSubview:_conversionTimeLabel];
    [_conversionTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_conversionLevelLabel.mas_bottom).offset(10);
        make.left.right.equalTo(_nameLabel);
    }];
    _conversionTimeLabel.font = [UIFont systemFontOfSize:14.f];
    _conversionTimeLabel.textColor = [UIColor colorWithHexString:@"#999999"];

    _conversionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_conversionBtn];
    [_conversionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    _conversionBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_conversionBtn setTitleColor:[UIColor colorWithHexString:@"#F35D00"] forState:UIControlStateNormal
     ];
    [_conversionBtn setTitle:@"铜币兑换" forState:UIControlStateNormal];
    _conversionBtn.layer.masksToBounds = YES;
    _conversionBtn.layer.cornerRadius = 4.f;
    _conversionBtn.layer.borderWidth = 1.f;
    _conversionBtn.layer.borderColor = [UIColor colorWithHexString:@"#F35D00"].CGColor;
    [_conversionBtn setTag:0];
    [_conversionBtn addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btgongxianzhi = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_btgongxianzhi];
    [_btgongxianzhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_conversionBtn.mas_left).offset(-5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    _btgongxianzhi.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [_btgongxianzhi setTitleColor:[UIColor colorWithHexString:@"#F35D00"] forState:UIControlStateNormal
     ];
    [_btgongxianzhi setTitle:@"贡献值兑换" forState:UIControlStateNormal];
    _btgongxianzhi.layer.masksToBounds = YES;
    _btgongxianzhi.layer.cornerRadius = 4.f;
    _btgongxianzhi.layer.borderWidth = 1.f;
    _btgongxianzhi.layer.borderColor = [UIColor colorWithHexString:@"#F35D00"].CGColor;
    [_btgongxianzhi setTag:1];
    [_btgongxianzhi addTarget:self action:@selector(respondsToBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_btgongxianzhi setHidden:YES];
}

- (void)respondsToBtnEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(tableViewCellDidClickConversionBtn:type:)]) {
        [self.delegate tableViewCellDidClickConversionBtn:self type:sender.tag];
    }
}

- (void)bindDataWithModel:(NSDictionary *)dict{
    if (!dict) return;
    [[MDB_UserDefault defaultInstance] setViewWithImage:_iconImageView url:[NSString nullToString:dict[@"pic"]]];
    _nameLabel.text = [NSString nullToString:dict[@"title"]];
    _cionLabel.text = [NSString stringWithFormat:@"%@铜币",[NSString nullToString:dict[@"copper"]]];
    [_conversionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];
    
    if([[dict objectForKey:@"changetype"] intValue] == 1)
    {
        [_conversionBtn setHidden:NO];
        [_btgongxianzhi setHidden:YES];
    }
    else if([[dict objectForKey:@"changetype"] intValue] == 2)
    {
        _cionLabel.text = [NSString stringWithFormat:@"%@贡献值",[NSString nullToString:dict[@"contribution"]]];
        [_btgongxianzhi setHidden:NO];
        [_conversionBtn setHidden:YES];
        [_conversionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(70);
        }];
    }
    else if([[dict objectForKey:@"changetype"] intValue] == 3)
    {
        _cionLabel.text = [NSString stringWithFormat:@"%@铜币  或  %@贡献值",[NSString nullToString:dict[@"copper"]],[NSString nullToString:dict[@"contribution"]]];
        
        [_conversionBtn setHidden:NO];
        [_btgongxianzhi setHidden:NO];
    }
    else
    {
        [_conversionBtn setHidden:NO];
        [_btgongxianzhi setHidden:YES];
    }
    
    _itemTypeLabel.text = [NSString stringWithFormat:@"奖品类型：%@",[NSString nullToString:dict[@"gifttype"]]];
    _conversionLevelLabel.text = [NSString stringWithFormat:@"兑换等级：Lv%@",[NSString nullToString:dict[@"buylevel"]]];
    _conversionTimeLabel.text = [NSString stringWithFormat:@"截止时间：%@",[NSString nullToString:dict[@"getend"]]];

}
@end
