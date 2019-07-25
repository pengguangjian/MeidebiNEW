//
//  SocialBoundSubjectView.m
//  Meidebi
//
//  Created by mdb-admin on 2017/6/28.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "SocialBoundSubjectView.h"
#import "SocialBoundTableViewCell.h"
#import <ShareSDK/ShareSDK.h>
static NSString * const kTableViewCellIdentifier = @"cell";
@interface SocialBoundSubjectView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *socialPlatforms;
@end

@implementation SocialBoundSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    _tableView = [UITableView new];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[SocialBoundTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
}

- (void)bindDataWithModel:(NSDictionary *)model{
    if (!model) return;
    self.socialPlatforms = @[@{kSocialPlatmentName:@"微博账号",
                           kSocialPlatmentImage:[UIImage imageNamed:@"sharesinawb"],
                           kSocialPlatmentType:@(SocialPlatformTypeSina),
                           kSocialPlatmentStatus:[NSString nullToString:model[@"sinaData"][@"status"]]},
                         @{kSocialPlatmentName:@"QQ 账号",
                           kSocialPlatmentImage:[UIImage imageNamed:@"shareQQ"],
                           kSocialPlatmentType:@(SocialPlatformTypeQQ),
                           kSocialPlatmentStatus:[NSString nullToString:model[@"qqData"][@"status"]]}];
    [self.tableView reloadData];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.socialPlatforms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SocialBoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    [cell bindDataWithModel:self.socialPlatforms[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL status = [self.socialPlatforms[indexPath.row][kSocialPlatmentStatus] boolValue];
    if (status) {
        if ([self.delegate respondsToSelector:@selector(socialBoundSubjectViewDidSelectCellWithCancelPlatformAuthorized:complete:)]) {
            [self.delegate socialBoundSubjectViewDidSelectCellWithCancelPlatformAuthorized:[self.socialPlatforms[indexPath.row][kSocialPlatmentType] integerValue] complete:^{
                self.socialPlatforms = nil;
                [_tableView reloadData];
            }];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(socialBoundSubjectViewDidSelectCellWithPlatform:complete:)]) {
            [self.delegate socialBoundSubjectViewDidSelectCellWithPlatform:[self.socialPlatforms[indexPath.row][kSocialPlatmentType] integerValue] complete:^{
                self.socialPlatforms = nil;
                [_tableView reloadData];
            }];
        }
    }
   
}
@end
