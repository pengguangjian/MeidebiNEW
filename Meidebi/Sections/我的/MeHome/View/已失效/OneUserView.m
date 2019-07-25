//
//  OneUserView.m
//  Meidebi
//
//  Created by fishmi on 2017/6/19.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "OneUserView.h"
#import "OneUserHeadView.h"
#import "OneUserBottomView.h"
#import "MDB_UserDefault.h"
#import "PushSetingViewControoler.h"
#import "AboutMDBViewController.h"
#import "BindingUserInfoViewController.h"
#import "VKLoginViewController.h"
#import "MyTrackViewController.h"
#import "MDB_UserDefault.h"
#import <UMAnalytics/MobClick.h>
@interface OneUserView ()<UITableViewDelegate,UITableViewDataSource,OneUserHeadViewDelegate,UIAlertViewDelegate>
@property (nonatomic ,weak) UITableView *tableV;
@property (nonatomic ,strong) NSArray *tableArray;
@property (nonatomic ,weak) UILabel *label;
@property (nonatomic ,weak) UIView *remindV;



@end

static NSString *const cellID = @"OneUserCell";
@implementation OneUserView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _tableArray = [self getTableRows].mutableCopy;
        [self setUpSubView];
    }
    return self;
}


- (void)setUpSubView{
    
    UITableView *tableV = [[UITableView alloc] init];
    tableV.bounces = NO;
    [self addSubview:tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    tableV.delegate = self;
    tableV.dataSource = self;
    [tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableV = tableV;
    
    OneUserHeadView *headV = [[OneUserHeadView alloc] init];
    headV.frame = CGRectMake(0, 0, kMainScreenW, _headV.height);
    headV.delegate = self;
    tableV.tableHeaderView = headV;
    _headV = headV;
    
    
    UIButton *btmyjiangli = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 30)];
    [btmyjiangli setBackgroundColor:RadMenuColor];
    [btmyjiangli setTitle:@"我的奖励" forState:UIControlStateNormal];
    [btmyjiangli setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btmyjiangli.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btmyjiangli.layer setMasksToBounds:YES];
    [btmyjiangli.layer setCornerRadius:3];
    [btmyjiangli setTop:55];
    [btmyjiangli setRight:kMainScreenW+3];
    [btmyjiangli addTarget:self action:@selector(jiangliAction) forControlEvents:UIControlEventTouchUpInside];
    [_headV addSubview:btmyjiangli];
    

    OneUserBottomView *bottomV = [[OneUserBottomView alloc] init];
    bottomV.frame = CGRectMake(0, 0, kMainScreenW, 67 *kScale);
    tableV.tableFooterView = bottomV;

    [self updateTableHeaderView];
}

- (void)updateTableHeaderView{
    [self layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat height = [_headV systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        CGRect frame = _headV.frame;
        frame.size.height = height;
        _headV.frame =frame;
        _tableV.tableHeaderView = _headV;
    });
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableArray.count == 6) {
//        if (indexPath.row == 5) {
//            UITableViewCell *cell = [[UITableViewCell alloc] init];
//            cell.textLabel.text = _tableArray[indexPath.row];
//            cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//            cell.textLabel.font = [UIFont systemFontOfSize:14];
//            UISwitch *cellSwitch = [[UISwitch alloc] init];
//            cellSwitch.on=[[MDB_UserDefault defaultInstance]getPicMode_switch];
//            [cellSwitch addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
//            cellSwitch.tag=401;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            [cell addSubview:cellSwitch];
//            [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(cell);
//                make.right.equalTo(cell).offset(-18);
//                make.size.mas_equalTo(CGSizeMake(43 *kScale, 26 *kScale));
//
//            }];
//
//            UIView *lineV = [[UIView alloc] init];
//            [cell addSubview:lineV];
//            lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
//            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(cell);
//                make.height.offset(1);
//            }];
//            return cell;
//        }else
        if(indexPath.row == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = _tableArray[indexPath.row];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            UIView *remindV = [[UIView alloc] init];
            [cell addSubview:remindV];
            [remindV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell).offset(-10);
                make.left.equalTo(cell).offset(135);
                make.size.mas_equalTo(CGSizeMake(8, 8));
            }];
            remindV.backgroundColor = [UIColor redColor];
            remindV.layer.cornerRadius = 4;
            remindV.clipsToBounds = YES;
            _remindV = remindV;
            
            UIView *backgV = [[UIView alloc] init];
            [cell addSubview:backgV];
            [backgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell);
                make.right.equalTo(cell).offset(-20);
                make.size.mas_equalTo(CGSizeMake(60, 20));
            }];
            backgV.backgroundColor = [UIColor orangeColor];
            backgV.layer.cornerRadius = 10;
            backgV.clipsToBounds = YES;
            
            UILabel *label = [[UILabel alloc] init];
            [backgV addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(backgV);
            }];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"300铜币";
            _label = label;
            
            UIView *lineV = [[UIView alloc] init];
            [cell addSubview:lineV];
            lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(cell);
                make.height.offset(1);
            }];
            return cell;
            
            
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.textLabel.text = _tableArray[indexPath.row];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            UIView *lineV = [[UIView alloc] init];
            [cell addSubview:lineV];
            lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(cell);
                make.height.offset(1);
            }];
            return cell;
        }
    }else if (_tableArray.count == 5){
//        if (indexPath.row == 4) {
//            UITableViewCell *cell = [[UITableViewCell alloc] init];
//            cell.textLabel.text = _tableArray[indexPath.row];
//            cell.textLabel.font = [UIFont systemFontOfSize:14];
//            cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//            UISwitch *cellSwitch = [[UISwitch alloc] init];
//            cellSwitch.on=[[MDB_UserDefault defaultInstance]getPicMode_switch];
//            [cellSwitch addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
//            cellSwitch.tag=401;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            [cell addSubview:cellSwitch];
//            [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(cell);
//                make.right.equalTo(cell).offset(-18);
//                make.size.mas_equalTo(CGSizeMake(43 *kScale, 26 *kScale));
//
//            }];
//
//            UIView *lineV = [[UIView alloc] init];
//            [cell addSubview:lineV];
//            lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
//            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(cell);
//                make.height.offset(1);
//            }];
//            return cell;
//        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.textLabel.text = _tableArray[indexPath.row];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *lineV = [[UIView alloc] init];
            [cell addSubview:lineV];
            lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(cell);
                make.height.offset(1);
            }];
            return cell;
//        }
    }else{
//        if (indexPath.row == 2) {
//            UITableViewCell *cell = [[UITableViewCell alloc] init];
//            cell.textLabel.text = _tableArray[indexPath.row];
//            cell.textLabel.font = [UIFont systemFontOfSize:14];
//            cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//            UISwitch *cellSwitch = [[UISwitch alloc] init];
//            cellSwitch.on=[[MDB_UserDefault defaultInstance]getPicMode_switch];
//            [cellSwitch addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
//            cellSwitch.tag=401;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            [cell addSubview:cellSwitch];
//            [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(cell);
//                make.right.equalTo(cell).offset(-18);
//                make.size.mas_equalTo(CGSizeMake(43 *kScale, 26 *kScale));
//
//            }];
//
//            UIView *lineV = [[UIView alloc] init];
//            [cell addSubview:lineV];
//            lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
//            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(cell);
//                make.height.offset(1);
//            }];
//            return cell;
//        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.textLabel.text = _tableArray[indexPath.row];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *lineV = [[UIView alloc] init];
            [cell addSubview:lineV];
            lineV.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
            [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(cell);
                make.height.offset(1);
            }];
            return cell;
//        }
    }

   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66*kScale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self tableCellHandleWithCellText:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
}

- (void)tableCellHandleWithCellText:(NSString *)text{
    if (![_tableArray containsObject:text]) return;
    if ([@"我的足迹" isEqualToString:text]) {
        MyTrackViewController *vc = [[MyTrackViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(pushToPushSetingViewControoler:)]) {
            [self.delegate pushToPushSetingViewControoler:vc];
        }
    }else if ([@"邀请好友" isEqualToString:text]) {
        if (![MDB_UserDefault getIsLogin]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请登录后再试"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"登录",@"取消", nil];
            [alertView setTag:110];
            [alertView show];
            return;
        }
        if ([self.delegate respondsToSelector:@selector(oneUserViewDidSelectInviteFriendCell)]) {
            [self.delegate oneUserViewDidSelectInviteFriendCell];
        }
       
    }else if ([@"我关注的" isEqualToString:text]) {
        if ([self.delegate respondsToSelector:@selector(jiangjiatongzhiAction)]) {
            [self.delegate jiangjiatongzhiAction];
        }
    }else if ([@"推送设置" isEqualToString:text]) {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        if (types==UIUserNotificationTypeNone) {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                          message:@"请到设置->通知中心->没得比开启推送服务!"
                                                         delegate:nil
                                                cancelButtonTitle:@"好"
                                                otherButtonTitles:nil];
            [alert show];
            return;
        }
        [MDB_UserDefault setPushKeywordsDate:[NSDate date]];
        UIStoryboard *Oneselfboard = [UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
        PushSetingViewControoler *signVc=[Oneselfboard instantiateViewControllerWithIdentifier:@"com.mdb.SignVC"];
        if ([self.delegate respondsToSelector:@selector(pushToPushSetingViewControoler:)]) {
            [self.delegate pushToPushSetingViewControoler:signVc];
        }

    }else if ([@"意见反馈" isEqualToString:text]) {
        if ([self.delegate respondsToSelector:@selector(clickTofeedbackKit)]) {
            [self.delegate clickTofeedbackKit];
        }
    }else if ([@"关于没得比" isEqualToString:text]) {
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [MobClick event:@"wode_guanyu"];
            AboutMDBViewController *vc = [[AboutMDBViewController alloc] init];
            [self.delegate clickToViewController:vc];
        }
    }else if ([@"绑定手机享好礼" isEqualToString:text]) {
        if ([_label.text isEqualToString:@"300铜币"]) {
            if (![MDB_UserDefault getIsLogin]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请登录后再试"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"登录",@"取消", nil];
                [alertView setTag:120];
                [alertView show];
                return;
                
            }else{
                [MDB_UserDefault setIsUserInfoLogin:YES];
                BindingUserInfoViewController *bindingUserInfoVc = [[BindingUserInfoViewController alloc] init];
                if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
                    [self.delegate clickToViewController:bindingUserInfoVc];
                }
            }
            
        }

    }

}

-(void)PicMode_switched:(UISwitch *)sender{
    if (sender.tag==401) {
        BOOL boos=sender.isOn;
        [[MDB_UserDefault defaultInstance] setPicMode_swithc:boos];
    }
}

- (void)showGuideView{
    if ([self.delegate respondsToSelector:@selector(subjectViewShowGuideElementRects:)]) {
        if (![MDB_UserDefault showAppPersonalInfoGuide]) {
            CGRect frame = _headV.fucV.frame;
            frame.size.width = kMainScreenW/4.f;
            frame.origin.x = frame.size.width*2;
            if ([MDB_UserDefault getIsLogin]) {
                frame.origin.y += kTopHeight+20;
            }else{
                frame.origin.y += kTopHeight;
            }
            [self.delegate subjectViewShowGuideElementRects:@[[NSValue valueWithCGRect:frame]]];
        }
    }
}

#pragma mark - 我的奖励
-(void)jiangliAction
{
    
    [self.delegate subjectViewJiangLiAction];
}

#pragma mark - OneUserHeadViewDelegate

- (void)functionSelectbyButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(functionSelectbyButton:)]) {
        [self.delegate functionSelectbyButton:btn];
    }
}

-(void)clickToViewController:(UIViewController *)Vc{
    if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
        [self.delegate clickToViewController:Vc];
    }
}


- (void)headerViewShowGuideElementRects:(NSArray *)rects{
    if ([self.delegate respondsToSelector:@selector(subjectViewShowFansWithFollowGuideElementRects:)]) {
        [self.delegate subjectViewShowFansWithFollowGuideElementRects:rects];
    }
}


- (void)setUpheadViewData{
    [self.headV setUpheadViewData];
    [self updateTableHeaderView];

}

- (void)setUpImageV:(UIImage *)image{
    [_headV setUpImageV:image];
}

- (void)layoutViewWithlogout{
    _tableArray = [self getTableRows];
    [_tableV reloadData];
    [self setUpheadViewData];
}

- (void)setNeedPhone:(NSInteger)needPhone{
    _needPhone = needPhone;
    if (needPhone != 1) {
        _label.text = @"已绑定";
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[self getTableRows]];
        [arr removeObjectAtIndex:0];
        _tableArray = arr.mutableCopy;
        [_tableV reloadData];
    }else{
        _remindV.hidden = NO;
        _label.text = @"300铜币";
        _tableArray = [self getTableRows];
         [_tableV reloadData];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        VKLoginViewController *vkVc = [[VKLoginViewController alloc] init];
        if ([self.delegate respondsToSelector:@selector(clickToViewController:)]) {
            [self.delegate clickToViewController:vkVc];
        }
    }
}

- (NSArray *)getTableRows{
    NSArray *array;
    if ([MDB_UserDefault getIsLogin]) {
        //,@"我的足迹"
        array = @[@"绑定手机享好礼",@"邀请好友",@"我关注的",@"我的足迹",@"意见反馈",@"关于没得比"];//@"推送设置",@"非wifi不显示图片",
    }else{
        array = @[@"邀请好友",@"意见反馈",@"关于没得比"];//@"推送设置",@"非wifi不显示图片",
    }
    return array;
}
@end
