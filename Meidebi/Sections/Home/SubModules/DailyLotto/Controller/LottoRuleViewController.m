//
//  LottoRuleViewController.m
//  Meidebi
//
//  Created by mdb-admin on 2017/9/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "LottoRuleViewController.h"

@interface LottoRuleViewController ()

@end

@implementation LottoRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抽奖规则";
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubviews{
    UITextView *textView = [UITextView new];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 20, 10, 20));
    }];
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.editable = NO;
    
    NSString *title = @"\n\n积分抽奖规则：\n\n\n";
    NSString *rule =  @"1. 进入抽奖页面，每次抽奖所需铜币根据页面提示扣除；\n\n\n2. 会员每日可免费抽奖一次，再次抽奖10铜币/次；\n\n\n3. 每人每日可抽奖20次；\n\n\n4. 抽奖商品，不接受退换货，亦不可折现，奖品图片仅供参考，请以实物为准；\n\n\n5. 对于任何通过不正当手段参与者，没得比有权取消其抽奖资格；\n\n\n6、中奖优惠券将在24小时内直接发放到您的账户中； \n\n\n7、实物奖品中奖请在48小时内联系客服，并在个人中心-个人资料页面填写收货地址，逾期作废哦；\n\n\n8、本活动与苹果公司无关。";
    NSString *content = [title stringByAppendingString:rule];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:14.f]
                          range:NSMakeRange(0, content.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#333333"]
                          range:NSMakeRange(0, title.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#666666"]
                          range:NSMakeRange(title.length, rule.length)];
    textView.attributedText = attributedStr.mutableCopy;
}

@end
