//
//  BrokeHelpViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2017/12/1.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "BrokeHelpViewController.h"

@interface BrokeHelpViewController ()

@end

@implementation BrokeHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    [self configurUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurUI{
    UILabel *helpeContentLabel = [UILabel new];
    [self.view addSubview:helpeContentLabel];
    [helpeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset((35+kTopHeight)*kScale);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    helpeContentLabel.numberOfLines = 0;
    
    NSString *problemTitleOneStr = @"如何获取商品链接？";
    NSString *problemTitleTwoStr = @"如何爆料？";
    NSString *problemTitleThreeStr = @"如何提升爆料通过率？";
    NSString *problemTitleFourStr = @"什么是提交的电商地址无效？";
    NSString *problemContentOneStr = @"\n1：在第三方购物app中点击分享复制链接 \n2：在浏览器中复制地址栏\n\n";
    NSString *problemContentTwoStr = @"\n1：复制链接获取商品/活动信息 \n2：添加和编辑商品信息，填写推荐理由等发布即可，通过审核后，在前台才可查看\n\n";
    NSString *problemContentThreeStr = @"\n1、详细的商品介绍、促销信息、价格的好坏是爆料的首要条件 \n2、真实的使用体验、同类分析、请原创推荐理由，受小编和比友的膜拜 \n3、考虑到购物体验、商品品质、物流配送、售后保修等多维度的因素，进来精选电商平台\n\n";
    NSString *problemContentFourStr = @"\n1、错误的链接地址 \n2、爆料的商品所在商城目前不可以爆料 \n3、当您遇到电商地址无效时，请联系没得比增加商城";
    NSString *sumStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",problemTitleOneStr,problemContentOneStr,problemTitleTwoStr,problemContentTwoStr,problemTitleThreeStr,problemContentThreeStr,problemTitleFourStr,problemContentFourStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];//调整行间距
    [paragraphStyle setParagraphSpacingBefore:5];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:sumStr];
    
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:12]
                          range:NSMakeRange(0, problemTitleOneStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#555555"]
                          range:NSMakeRange(0, problemTitleOneStr.length)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12]
                          range:NSMakeRange(problemTitleOneStr.length, problemContentOneStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#666666"]
                          range:NSMakeRange(problemTitleOneStr.length, problemContentOneStr.length)];
    
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:12]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length, problemTitleTwoStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#555555"]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length, problemTitleTwoStr.length)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length+problemTitleTwoStr.length, problemContentTwoStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#666666"]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length+problemTitleTwoStr.length, problemContentTwoStr.length)];

    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:12]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length+problemTitleTwoStr.length+problemContentTwoStr.length, problemTitleThreeStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#555555"]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length+problemTitleTwoStr.length+problemContentTwoStr.length, problemTitleThreeStr.length)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length+problemTitleTwoStr.length+problemContentTwoStr.length+problemTitleThreeStr.length, problemContentThreeStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#666666"]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length+problemTitleTwoStr.length+problemContentTwoStr.length+problemTitleThreeStr.length, problemContentThreeStr.length)];

    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:12]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length+problemTitleTwoStr.length+problemContentTwoStr.length+problemTitleThreeStr.length+problemContentThreeStr.length, problemTitleFourStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#555555"]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length+problemTitleTwoStr.length+problemContentTwoStr.length+problemTitleThreeStr.length+problemContentThreeStr.length, problemTitleFourStr.length)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length+problemTitleTwoStr.length+problemContentTwoStr.length+problemTitleThreeStr.length+problemContentThreeStr.length+problemTitleFourStr.length, problemContentFourStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor colorWithHexString:@"#666666"]
                          range:NSMakeRange(problemContentOneStr.length+problemTitleOneStr.length+problemTitleTwoStr.length+problemContentTwoStr.length+problemTitleThreeStr.length+problemContentThreeStr.length+problemTitleFourStr.length, problemContentFourStr.length)];

    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, sumStr.length)];
    helpeContentLabel.attributedText = attributedStr;

    
}

@end
