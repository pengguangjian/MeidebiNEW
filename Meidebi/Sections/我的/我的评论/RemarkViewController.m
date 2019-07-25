//
//  RemarkViewController.m
//  Meidebi
//  我的评论
//  Created by mdb-admin on 16/6/20.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "RemarkViewController.h"
#import "NJScrollTableView.h"
#import "RemarkTableViewController.h"
#import "ProductInfoViewController.h"
#import "OriginalDetailViewController.h"
#import "ADHandleViewController.h"
#import "RemarkHomeInputTabBarView.h"
#import <FCUUID/FCUUID.h>
#import "RemarkDataController.h"
#import "MDB_UserDefault.h"
#import "CommentRewardsViewController.h"
#import "ActivityDetailViewController.h"
#import "VolumeContentViewController.h"
@interface RemarkViewController ()
<
ScrollTabViewDataSource,
RemarkTableViewDelegate,
RemarkHomeInputTabBarViewDelegate
>

@property (nonatomic, strong) NSMutableArray *remarkTables;
@property (nonatomic, strong) NJScrollTableView *remarkScrollTableView;
@property (nonatomic, strong) RemarkHomeInputTabBarView *inputTabBarView;
@property (nonatomic, strong) PersonalRemark *aRemark;
@property (nonatomic, strong) RemarkDataController *datacontroller;

@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的评论";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupLeftButton];
    [self setupSubviews];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardchange:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidenChange:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupLeftButton{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)setupSubviews{
    
    RemarkTableViewController *artGNTable = [[RemarkTableViewController alloc] init];
    artGNTable.title = @"别人回复我";
    artGNTable.remarkType = RemarkMenuTypeReply;
    artGNTable.delegate = self;
    [self.remarkTables addObject:artGNTable];

    
    RemarkTableViewController *artTable = [[RemarkTableViewController alloc] init];
    artTable.title = @"我的评论";
    artTable.remarkType = RemarkMenuTypeComment;
    artTable.delegate = self;
    [self.remarkTables addObject:artTable];
  
    NJScrollTableView *_scrollTableView = [[NJScrollTableView alloc] initWithFrame:CGRectMake(0, kTopHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-kTopHeight)];
    _scrollTableView.backgroundColor = [UIColor whiteColor];
    _scrollTableView.selectedLineWidth = kScreenW/1.5;
    [self.view addSubview:_scrollTableView];
    _scrollTableView.dataSource = self;
    [_scrollTableView buildUI];
    [_scrollTableView selectTabWithIndex:0 animate:NO];
}

-(void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardchange:(NSNotification *)notification{
    self.inputTabBarView.hidden = NO;
    NSDictionary    *info=[notification userInfo];
    NSValue         *avalue=[info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect=[self.view convertRect:[avalue CGRectValue] fromView:nil];
    float keyboardHeight=keyboardRect.size.height;//键盘高度
    self.inputTabBarView.bottom = self.view.frame.size.height-keyboardHeight;
    self.inputTabBarView.left = 0;
}

-(void)keyboardHidenChange:(NSNotification *)notification{
    self.inputTabBarView.bottom = self.view.frame.size.height;
    self.inputTabBarView.hidden = YES;
}

#pragma mark - ScorllTableViewDelegate
- (NSUInteger)numberOfPagers:(NJScrollTableView *)view{
    return self.remarkTables.count;
}

- (UITableViewController *)scrollTableViewOfPagers:(NJScrollTableView *)view
                                     indexOfPagers:(NSUInteger)index{
    return self.remarkTables[index];
}

- (void)whenSelectOnPager:(NSUInteger)number{
    [self.inputTabBarView textViewDismissFirstResponder];
}


#pragma mark - RemarkTableViewDelegate
- (void)remarkTableViewVc:(RemarkTableViewController *)remarkTableViewVc
didSelectRowWithProductId:(NSString *)productId
               remarkType:(NSString *)type{
    [self.inputTabBarView textViewDismissFirstResponder];
    if ([[NSString nullToString:type] isEqualToString:@"1"]) {
        
        ProductInfoViewController *productInfoVc = [[ProductInfoViewController alloc] init];
        productInfoVc.productId = [NSString nullToString:productId];
        [self.navigationController pushViewController:productInfoVc animated:YES];
        
    }else if ([[NSString nullToString:type] isEqualToString:@"2"]){
        OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:productId];
//        ShareContViewController *ShareContVc = [[ShareContViewController alloc] init];
//        ShareContVc.shareid = [productId integerValue];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([[NSString nullToString:type] isEqualToString:@"3"]){
        
        VolumeContentViewController *voluVc = [[VolumeContentViewController alloc] init];
        voluVc.juancleid = productId.integerValue;
        voluVc.type = waresTypeCoupon;
        [self.navigationController pushViewController:voluVc animated:YES];
        
    }else if ([[NSString nullToString:type] isEqualToString:@"4"]){

        CommentRewardsViewController *commentRewardVc = [[CommentRewardsViewController alloc] init];
        commentRewardVc.activityId = productId;
        [self.navigationController pushViewController:commentRewardVc animated:YES];
        
    }else if ([[NSString nullToString:type] isEqualToString:@"5"]){
        
        ActivityDetailViewController *activityVc = [[ActivityDetailViewController alloc] init];
        activityVc.activityId = productId;
        [self.navigationController pushViewController:activityVc animated:YES];
        
    }
    else if ([[NSString nullToString:type] isEqualToString:@"8"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tabbarselectother" object:@"2"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
    
    
}

- (void)photoGroupView:(YYPhotoGroupView *)photoGroupView didClickImageView:(UIView *)fromeView{
    [photoGroupView presentFromImageView:fromeView
                toContainer:self.navigationController.view
                   animated:YES
                 completion:nil];
}

- (void)remarkTableViewVc:(RemarkTableViewController *)remarkTableViewVc didClickUrl:(NSString *)urlStr{
    ADHandleViewController *vc = [[ADHandleViewController alloc] initWithAdLink:urlStr];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)remarkTableViewVc:(RemarkTableViewController *)remarkTableViewVc didClickReply:(PersonalRemark *)replyRemark{
    _aRemark = replyRemark;
    [self.view addSubview:self.inputTabBarView];
     self.inputTabBarView.placeholderStr = [NSString stringWithFormat:@"回复：@%@",[NSString nullToString:_aRemark.ousername]];
    [self.inputTabBarView textViewBecomeFirstResponder];
}

- (void)remarkTableViewVcScrollViewDidDragging{
    [self.inputTabBarView textViewDismissFirstResponder];
}

#pragma mark - RemarkHomeInputTabBarViewDelegate
- (void)textViewShouldReturn:(NSString *)text{
    NSString * toBeString = text;
    MDB_UserDefault *userdefaul=[MDB_UserDefault defaultInstance];
    NSMutableDictionary *dics;
    dics =[@{@"userid":[NSString nullToString:userdefaul.usertoken],
             @"type":[NSString stringWithFormat:@"%@",[NSString nullToString:_aRemark.fromtype]],
             @"fromid":[NSString stringWithFormat:@"%@",[NSString nullToString:_aRemark.fromid]],
             @"touserid":[NSString stringWithFormat:@"%@",[NSString nullToString:_aRemark.ouserid]],
             @"content":toBeString} mutableCopy];
    [dics setValue:[FCUUID uuidForDevice] forKey:@"uniquetoken"];
    [self.datacontroller requestCommentReplySubjectData:dics
                                                 InView:self.view
                                               callback:^(NSError *error, BOOL state, NSString *describle) {
                                                   [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
    }];
    
    [self.inputTabBarView textViewDismissFirstResponder];
}

#pragma mark - setters and getters
- (NSMutableArray *)remarkTables{
    if (!_remarkTables) {
        _remarkTables = [NSMutableArray array];
    }
    return _remarkTables;
}

- (RemarkHomeInputTabBarView *)inputTabBarView{
    if (!_inputTabBarView) {
        _inputTabBarView = [RemarkHomeInputTabBarView new];
        _inputTabBarView.bottom = self.view.frame.size.height;
        _inputTabBarView.left = 0;
        _inputTabBarView.delegate = self;
    }
    return _inputTabBarView;
}

- (RemarkDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[RemarkDataController alloc] init];
    }
    return _datacontroller;
}
@end
