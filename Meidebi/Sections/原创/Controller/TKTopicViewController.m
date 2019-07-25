//
//  TKTopicViewController.m
//  TaokeSecretary
//  原创分类列表
//  Created by mdb-losaic on 2018/1/11.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKTopicViewController.h"
#import "TKTopicSubjectView.h"
#import "OriginalDatacontroller.h"
#import "OriginalDetailViewController.h"
#import "TKTopicComposeViewController.h"
#import "PersonalInfoIndexViewController.h"
#import "VKLoginViewController.h"
#import "MDB_UserDefault.h"
#import "GMDCircleLoader.h"
@interface TKTopicViewController ()
<
TKTopicSubjectViewDelegate
>
@property (nonatomic, assign) TKTopicType topicType;
@property (nonatomic, strong) TKTopicSubjectView *subjectView;
@property (nonatomic, strong) OriginalDatacontroller *dataController;
@property (nonatomic, assign) TopicSortStyle sortType;
@property (nonatomic, assign) BOOL isPushComposeVc;
@end

@implementation TKTopicViewController
- (instancetype)initWithTopicType:(TKTopicType)type{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _topicType = type;
        _sortType = TopicSortStyleTime;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurUI];
    [self obtainTopicDataWithSortType:_sortType];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isPushComposeVc) {
        [self obtainTopicDataWithSortType:_sortType];
        _isPushComposeVc = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configurUI{
    switch (_topicType) {
        case TKTopicTypeEnable:
            self.title = @"生活经验";
            break;
        case TKTopicTypeLooks:
            self.title = @"服饰鞋包";
            break;
        case TKTopicTypeBeauty:
            self.title = @"美妆护肤";
            break;
        case TKTopicType3C:
            self.title = @"数码家电";
            break;
        case TKTopicTypeDeliciousfood:
            self.title = @"美食旅游";
            break;
        case TKTopicTypeEvaluation:
            self.title = @"评测试用";
            break;
        case TKTopicTypeOther:
            self.title = @"其他";
            break;
        case TKTopicTypeSpitslot:
            self.title = @"匿名吐槽";
            break;
        case TKTopicTypeDaily:
            self.title = @"日常话题";
            break;
        case TKTopicTypeShaiDan:
            self.title = @"晒单广场";
            break;
        case TKTopicTypeShoppingList:
            self.title = @"必买清单";
            break;
        default:
            break;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    _subjectView = [[TKTopicSubjectView alloc] initWithTopicType:_topicType];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
    _subjectView.delegate = self;
    
}

- (void)obtainTopicDataWithSortType:(TopicSortStyle)style{
    if (style == TopicSortStyleUnknown) return;
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    [self.dataController requestTopicListWithType:_topicType
                                        sortStyle:style
                                         callback:^(NSError *error, BOOL state, NSString *describle) {
                                             [GMDCircleLoader hideFromView:self.view animated:YES];
                                             [self renderSubview];
                                             if (!state){
                                                 [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                                             }
    }];
}

- (void)renderSubview{
    NSMutableArray *topics = [NSMutableArray array];
    for (NSDictionary *dict in self.dataController.results) {
        TKTopicListViewModel *model = [TKTopicListViewModel viewModelWithSubject:dict];
        if (model) {
            [topics addObject:model];
        }
    }
    [_subjectView bindDataWithModel:topics.mutableCopy];
    _subjectView.posteCount = self.dataController.postingsCount;
    _subjectView.commentCount = self.dataController.commentCount;
}

#pragma mark - TKTopicSubjectViewDelegate
- (void)topicSubjectDidSelectItem:(NSString *)itemID{
    OriginalDetailViewController *vc = [[OriginalDetailViewController alloc] initWithOriginalID:itemID];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)topicSubjectDidChangSort:(TopicSortStyle)style{
    _sortType = style;
    [self obtainTopicDataWithSortType:style];
}
- (void)lastPage{
    [self.dataController requestLastPageTopicDataCallback:^(NSError *error, BOOL state, NSString *describle) {
        [self renderSubview];
    }];
}
- (void)nextPage{
    [self.dataController requestNextPageTopicDataCallback:^(NSError *error, BOOL state, NSString *describle) {
        [self renderSubview];
    }];
}
- (void)topicSubjectDidClickPosteTopicButton{
    if ([MDB_UserDefault getIsLogin]) {
        TKTopicComposeViewController *vc = [[TKTopicComposeViewController alloc] initWithTopicType:_topicType];
        [self.navigationController pushViewController:vc animated:YES];
        _isPushComposeVc = YES;
    }else{
        VKLoginViewController *vc = [[VKLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)photoGroupView:(YYPhotoGroupView *)photoGroupView didClickImageView:(UIView *)fromeView{
    [photoGroupView presentFromImageView:fromeView
                             toContainer:self.navigationController.view
                                animated:YES
                              completion:nil];
}

- (void)topicSubjectViewDidCickAvaterViewWithUserid:(NSString *)userid{
    if (userid.length <= 0 || TKTopicTypeSpitslot == _topicType) return;
    PersonalInfoIndexViewController *personalInfoVc = [[PersonalInfoIndexViewController alloc] initWithUserID:userid];
    [self.navigationController pushViewController:personalInfoVc animated:YES];
}

#pragma mark - setters and getters
- (OriginalDatacontroller *)dataController{
    if (!_dataController) {
        _dataController = [[OriginalDatacontroller alloc] init];
    }
    return _dataController;
}

@end
