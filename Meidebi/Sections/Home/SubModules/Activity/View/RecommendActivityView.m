//
//  RecommendActivityView.m
//  Meidebi
//
//  Created by fishmi on 2017/5/17.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "RecommendActivityView.h"
#import "RecommendDetailView.h"
#import "GoodsCollectionViewCell.h"
#import "RecommendActivityViewCollectionHeadView.h"
#import "RecommendActivityHeadViewModel.h"
#import "RecommendListViewModel.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
@interface RecommendActivityView ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
RecommendActivityHeadViewDelegate,
UIAlertViewDelegate
>
@property (nonatomic, strong) RecommendDetailView *detailV;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIImageView *imageShow;
@property (nonatomic, strong) NSArray *headDataArray;
@property (nonatomic, strong) NSArray *listDataArray;
@property (nonatomic, strong) RecommendActivityViewCollectionHeadView *headV;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIButton *joinBtn;

@end

@implementation RecommendActivityView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubView];
        self.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    }
    return self;
}

- (void)setSubView{
    UIView *bottomV = [[UIView alloc] init];
    [self addSubview:bottomV];
    bottomV.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@60);
    }];
    self.bottomV = bottomV;
    _bottomV.hidden = YES;
    [self setbottomView];
    [self createRecommendSubViews];
    [_collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(bottomV.mas_top);
    }];
}

- (void)createRecommendSubViews{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 0;
    CGFloat width = kMainScreenW *0.5;
    flowLayout.itemSize = CGSizeMake(width, width);
    flowLayout.headerReferenceSize = CGSizeMake(kMainScreenW, kMainScreenW);
    _flowLayout = flowLayout;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[GoodsCollectionViewCell class]
       forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[RecommendActivityViewCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:collectionView];
    _collectionV = collectionView;
//    [self collectionViewAddRefersh];
}

- (void)collectionViewAddRefersh{
    _collectionV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerRefreshDateSource];
    }];
    
}

- (void)footerRefreshDateSource{
    if ([self.delegate respondsToSelector:@selector(dataRefreshByMJRefresh)]) {
        [self.delegate dataRefreshByMJRefresh];
        [self.collectionV.mj_footer endRefreshing];
    }
}

- (void)webViewDidPreseeUrlWithLink:(NSString *)link{
    if ([self.delegate respondsToSelector:@selector(detailSubjectViewDidCickWebViewUrlLink:)]) {
        [self.delegate detailSubjectViewDidCickWebViewUrlLink:link];
    }
}

- (void)setbottomView{
    
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.layer.cornerRadius = 7;
    joinBtn.clipsToBounds = YES;
    [joinBtn setBackgroundColor:[UIColor colorWithHexString:@"#838383"]];
    [joinBtn setTitle:@"我要参与" forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(enterInto:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomV addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_bottomV);
        make.size.mas_equalTo(CGSizeMake(211, 46));
    }];
    _joinBtn = joinBtn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _listDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = _listDataArray[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = _listDataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(subjectViewClickRecommendGoodsView:)]) {
        [self.delegate subjectViewClickRecommendGoodsView:cell.model.commodityid];
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    RecommendActivityViewCollectionHeadView *headReusableView = [[RecommendActivityViewCollectionHeadView alloc] init];;
    if (kind == UICollectionElementKindSectionHeader) {
        headReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell" forIndexPath:indexPath];
        headReusableView.delegate = self;
        _headV = headReusableView;
    }
    return headReusableView;
    
}

- (void)dataRefreshByLatestBtnClick{
    if ([self.delegate respondsToSelector:@selector(dataRefreshByLatestBtnClick)]) {
        [self.delegate dataRefreshByLatestBtnClick];
    }
}

- (void)dataRefreshByHotBtnClick{
    if ([self.delegate respondsToSelector:@selector(dataRefreshByHotBtnClick)]) {
        [self.delegate dataRefreshByHotBtnClick];
    }
}

- (void)enterInto:(UIButton *)sender{
    if (![MDB_UserDefault defaultInstance].usertoken){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }

    if ([_headV.model.userissigned isEqualToString:@"1"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"当前活动只能参加一次哦！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
        [alertView show];
        return ;

    }else{
        if ([self.delegate respondsToSelector:@selector(subjectViewClickJoinInActivity)]) {
            [self.delegate subjectViewClickJoinInActivity];
        }
    }

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 111) {
        if (buttonIndex == 0) {
            VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
            theViewController.LoginViewDidConfi = ^(){
                if ([self.delegate respondsToSelector:@selector(dataRefreshGetBackFromVKLoginViewControllerl)]) {
                    [self.delegate dataRefreshGetBackFromVKLoginViewControllerl];
                }
            };
            if ([self.delegate respondsToSelector:@selector(clickToVKLoginViewController:)]) {
                [self.delegate clickToVKLoginViewController:theViewController];
            }
        }
    }else{
        if (buttonIndex == 1) {
            [self browseAlbum];
        }else if(buttonIndex == 2){
            [self takePhotoAction];
        }
    }

}


#pragma mark - 访问相册
- (void)browseAlbum {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    if ([self.delegate respondsToSelector:@selector(subjectViewClickEnterImagePicker:)]) {
        [self.delegate subjectViewClickEnterImagePicker:imagePicker];
    }
}

#pragma mark - 拍照并保存
- (void)takePhotoAction {
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) { //若不可用，弹出警告框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无可用摄像头" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    /**
     *      UIImagePickerControllerSourceTypePhotoLibrary  ->所有资源文件夹
     UIImagePickerControllerSourceTypeCamera        ->摄像头
     UIImagePickerControllerSourceTypeSavedPhotosAlbum ->内置相册
     */
    imagePicker.delegate = self;    //设置代理，遵循√协议
    
    if ([self.delegate respondsToSelector:@selector(subjectViewClickEnterImagePicker:)]) {
        [self.delegate subjectViewClickEnterImagePicker:imagePicker];
    }
//    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - 协议方法的实现
//协议方法，选择完毕以后，呈现在imageShow里面
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%@",info);  //UIImagePickerControllerMediaType,UIImagePickerControllerOriginalImage,UIImagePickerControllerReferenceURL
    NSString *mediaType = info[@"UIImagePickerControllerMediaType"];
    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.imageShow.image = image;
        
        //通过判断picker的sourceType，如果是拍照则保存到相册去
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    //  else  当然可能是视频，这里不作讨论~方法是类似的~
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}

- (void)bindRecommendHeadViewData:(NSDictionary *)models{
    NSMutableArray *dicArray = [NSMutableArray array];
    for (NSDictionary *dic in models) {
        if ([[NSString nullToString:dic] isEqual:@"activity"]) {
            
            NSDictionary *dicActivity =[models objectForKey:@"activity"];
            [RecommendActivityHeadViewModel recommendActivityReplaced];
            RecommendActivityHeadViewModel *dicModel = [RecommendActivityHeadViewModel mj_objectWithKeyValues:dicActivity];
            [dicArray addObject:dicModel];
            
        }
    }
        
    _headDataArray = dicArray;
    _headV.model = _headDataArray[0];
    
    if (![_headV.model.timeout isEqualToString:@"0"]) {
        [_joinBtn setBackgroundColor:[UIColor colorWithHexString:@"#838383"]];
        _joinBtn.userInteractionEnabled = NO;
    }else{
        NSInteger currentTime = (NSInteger)[[NSDate date] timeIntervalSince1970];
        NSInteger endTime = [NSString nullToString:_headV.model.endtime].integerValue;
        NSInteger starTime = [NSString nullToString:_headV.model.starttime].integerValue;
        if (currentTime < starTime) {
            [_joinBtn setBackgroundColor:[UIColor colorWithHexString:@"#838383"]];
            _joinBtn.userInteractionEnabled = NO;
            
        }else if (currentTime<=endTime && currentTime >= starTime) {
            [_joinBtn setBackgroundColor:[UIColor colorWithHexString:@"#f35e00"]];
            _joinBtn.userInteractionEnabled = YES;
            
        }
    }
    
//    if ([_headV.model.timeout isEqualToString:@"0"]) {
//       [_joinBtn setBackgroundColor:[UIColor colorWithHexString:@"#f35e00"]];
//        _joinBtn.userInteractionEnabled = YES;
//    }else{
//       [_joinBtn setBackgroundColor:[UIColor colorWithHexString:@"#838383"]];
//        _joinBtn.userInteractionEnabled = NO;
//    }
    __weak __typeof__(self) weakself = self;
    _headV.callback = ^(CGFloat height) {
        weakself.flowLayout.headerReferenceSize = CGSizeMake(kMainScreenW, height);
    };
    _bottomV.hidden = NO;
}

- (void)bindRecommendListData:(NSDictionary *)models{
    _listDataArray = [NSArray array];
    NSMutableArray *dicArray = [NSMutableArray array];
    for (NSDictionary *dic in models) {
        [RecommendListViewModel recommendReplaceKey];
        RecommendListViewModel *dicModel = [RecommendListViewModel mj_objectWithKeyValues:dic];
        [dicArray addObject:dicModel];
    }
    _listDataArray = dicArray;
    if (_listDataArray.count > 0) {
        [_headV showHidenSideView];
        [_collectionV reloadData];
    }
}

#pragma mark - setters and getters
- (UIImage *)activityImage{
    return _headV.subImageV.image;
}




@end
