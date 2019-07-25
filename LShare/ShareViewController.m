//
//  ShareViewController.m
//  LShare
//
//  Created by mdb-admin on 16/8/2.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareSubjectView.h"
#import "ShareDataController.h"
#import "MDB_ShareExstensionUserDefault.h"
#import "BrokeAlertView.h"
@interface ShareViewController ()
<
ShareSubjectViewDelegate
>
@property (nonatomic, strong) ShareDataController *datacontroller;
@property (nonatomic, strong) ShareSubjectView *subjectView;
@end

@implementation ShareViewController

- (void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight([UIScreen mainScreen].bounds))];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    _subjectView = [ShareSubjectView new];
    [self.view addSubview:_subjectView];
    [_subjectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _subjectView.delegate = self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //获取网页地址
    NSExtensionItem *imageItem = [self.extensionContext.inputItems firstObject];
    for (NSItemProvider *provider in [imageItem attachments]) {
        if([provider hasItemConformingToTypeIdentifier:(NSString*)kUTTypeURL])
        {
            [provider loadItemForTypeIdentifier:(NSString*)kUTTypeURL options:nil completionHandler:^(NSURL* imageUrl, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _subjectView.brokeLink = imageUrl.absoluteString;
                    [self reloadBrokInfoDataWithLink:imageUrl.absoluteString];
                });
            }];
            break;
        }
    }
    
}

- (void)reloadBrokInfoDataWithLink:(NSString *)link{
    
    [self.datacontroller requestGetShareInfoDataWithLink:link InView:_subjectView callback:^(NSError *error) {
        if (self.datacontroller.resultMessage) {
            if ([[NSString stringWithFormat:@"%@",self.datacontroller.requestBrokeInfoResults[@"resubmit"]] isEqualToString:@"1"]) {
                BrokeAlertView *alertView = [[BrokeAlertView alloc] init];
                [self.view addSubview:alertView];
                [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view);
                }];
            }else{
                [MDB_ShareExstensionUserDefault showNotifyHUDwithtext:self.datacontroller.resultMessage inView:_subjectView];
            }
        }else{
            [self renderSubjectView];
        }
    }];
}

- (void)renderSubjectView {
    BrokeInfoViewModel *viewModel = [BrokeInfoViewModel viewModelWithSubjects:self.datacontroller.requestBrokeInfoResults];
    [_subjectView bindDataWithViewModel:viewModel];
}


#pragma mark - ShareSubjectViewDelegate
- (void)shareSubjectView:(ShareSubjectView *)subView didPressBrokeBtnWithInfo:(NSDictionary *)dict{
    [self.datacontroller requestSubmitBrokeWithInfo:dict InView:subView callback:^(NSError *error) {
        if (self.datacontroller.resultMessage) {
            [MDB_ShareExstensionUserDefault showNotifyHUDwithtext:self.datacontroller.resultMessage inView:subView];
        }else{
            [MDB_ShareExstensionUserDefault showNotifyHUDwithtext:@"爆料成功" inView:subView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self shareSubjectViewDidPressNoBrokeBtn];
            });
        }
    }];
}

- (void)shareSubjectViewDidPressNoBrokeBtn{
    [self cancel];
}

#pragma mark - setter and getter
- (ShareDataController *)datacontroller{
    if (!_datacontroller) {
        _datacontroller = [[ShareDataController alloc] init];
    }
    return _datacontroller;
}

@end
