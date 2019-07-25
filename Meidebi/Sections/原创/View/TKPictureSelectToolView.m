//
//  TKPictureSelectToolView.m
//  TaokeSecretary
//
//  Created by mdb-losaic on 2018/1/17.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKPictureSelectToolView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <TZImagePickerController/UIView+Layout.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZGifPhotoPreviewController.h>

#import "TKECamOrPhotosView.h"
#import "PGGCameraViewController.h"

#import "MDB_UserDefault.h"

@interface TKPictureHandleCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *gifLable;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;
//- (UIView *)snapshotView;
@end

@implementation TKPictureHandleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.f;
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        
        _addImageView = [[UIImageView alloc] init];
        _addImageView.image = [UIImage imageNamed:@"topic_picture_add"];
        _addImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_addImageView];
        self.clipsToBounds = YES;
        _addImageView.hidden = YES;

        
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.hidden = YES;
        [self addSubview:_videoImageView];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
        _deleteBtn.frame = CGRectMake(self.tz_width - 36, 0, 36, 36);
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
        _deleteBtn.alpha = 0.6;
        [self addSubview:_deleteBtn];
        
        _gifLable = [[UILabel alloc] init];
        _gifLable.text = @"";
        _gifLable.textColor = [UIColor whiteColor];
        _gifLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _gifLable.textAlignment = NSTextAlignmentCenter;
        _gifLable.font = [UIFont systemFontOfSize:10];
        _gifLable.frame = CGRectMake(self.tz_width - 25, self.tz_height - 14, 25, 14);
        [self addSubview:_gifLable];
        [_gifLable setHidden:YES];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    CGFloat width = self.tz_width / 3.0;
    _videoImageView.frame = CGRectMake(width, width, width, width);
    _addImageView.frame = CGRectMake(width, width, width, width);
}

- (void)setAsset:(id)asset {
    _asset = asset;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        _videoImageView.hidden = phAsset.mediaType != PHAssetMediaTypeVideo;
        _gifLable.hidden = ![[phAsset valueForKey:@"filename"] containsString:@"GIF"];
        _gifLable.hidden = NO;
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        _videoImageView.hidden = ![[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        _gifLable.hidden = YES;
    }
    else
    {
        _gifLable.hidden = YES;
    }
}

- (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}
@end

static NSInteger const maxPictureNumber = 10;
@interface TKPictureSelectToolView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate,
UINavigationControllerDelegate,
TKECamOrPhotosViewDelegate,
PGGCameraViewControllerDelegate
>
{
    CGFloat _itemWH;
    CGFloat _margin;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation TKPictureSelectToolView
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectedPhotos = [NSMutableArray array];
        _selectedAssets = [NSMutableArray array];
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _itemWH = (self.tz_width - 2 * _margin - 4) / 3 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
}

- (void)setupSubviews{
    if (_collectionView) return;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _layout = layout;
    _margin = 4;
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[TKPictureHandleCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)showPicturePickerView{
    [self pushImagePickerController];
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TKPictureHandleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.addImageView.hidden = YES;
    cell.hidden = NO;
    if (indexPath.row == _selectedPhotos.count) {
        if (_selectedPhotos.count >= maxPictureNumber) {
            cell.hidden = YES;
        }
        if(_selectedPhotos.count == 1)
        {
            if([_selectedPhotos[0] isKindOfClass:[NSURL class]])
            {
                cell.hidden = YES;
            }
            
        }
        cell.imageView.image = nil;
        cell.addImageView.hidden = NO;
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
        [cell.videoImageView setHidden:YES];
        
    } else {
        
        if([_selectedPhotos[indexPath.row] isKindOfClass:[UIImage class]])
        {
            cell.imageView.image = _selectedPhotos[indexPath.row];
            //            cell.asset = _selectedAssets[indexPath.row];
            [cell.videoImageView setHidden:YES];
            cell.deleteBtn.hidden = NO;
        }
        else if([_selectedPhotos[indexPath.row] isKindOfClass:[NSString class]])
        {
            [[MDB_UserDefault defaultInstance] setViewWithImage:cell.imageView url:_selectedPhotos[indexPath.row]];
            [cell.videoImageView setHidden:YES];
            cell.deleteBtn.hidden = NO;
        }
        else if ([_selectedPhotos[indexPath.row] isKindOfClass:[NSURL class]])
        {
            
            cell.imageView.image = [[MDB_UserDefault defaultInstance] getVideoPreViewImage: [NSURL URLWithString:[MDB_UserDefault getCompleteWebsite:_selectedPhotos[indexPath.row]]]];
            [cell.videoImageView setHidden:NO];
             cell.deleteBtn.hidden = NO;
        }
        
        
        
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        [self pushImagePickerController];
    } else { // preview photos or video / 预览照片或者视频
//        id asset = _selectedAssets[indexPath.row];
//        BOOL isVideo = NO;
//        if ([asset isKindOfClass:[PHAsset class]]) {
//            PHAsset *phAsset = asset;
//            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
//        } else if ([asset isKindOfClass:[ALAsset class]]) {
//            ALAsset *alAsset = asset;
//            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
//        }
//        else if ([asset isKindOfClass:[NSString class]])
//        {
//
//            return;
//        }
//
//        if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
//            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
//            vc.model = model;
//            if ([self.delegate respondsToSelector:@selector(pictureSelectBeginSkipToTargetVc:)]) {
//                [self.delegate pictureSelectBeginSkipToTargetVc:vc];
//            }
//        } else { // preview photos / 预览照片
//            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
//            imagePickerVc.maxImagesCount = maxPictureNumber;
//            imagePickerVc.allowPickingOriginalPhoto = NO;
//            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
//            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//                _selectedAssets = [NSMutableArray arrayWithArray:assets];
//                //                _isSelectOriginalPhoto = isSelectOriginalPhoto;
//                [_collectionView reloadData];
//                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//            }];
//            if ([self.delegate respondsToSelector:@selector(pictureSelectBeginSkipToTargetVc:)]) {
//                [self.delegate pictureSelectBeginSkipToTargetVc:imagePickerVc];
//            }
//        }
    }
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    [self.delegate selectTKPictureAction];
    
    
    if(_selectedPhotos.count>0)
    {
        [self selectItem:1];
    }
    else
    {
        ///展示不同的选项
        TKECamOrPhotosView *tview = [[TKECamOrPhotosView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT)];
        [tview setDelegate:self];
        [self.window addSubview:tview];
    }
    
    
//    [self selectItem:1];
}

#pragma mark - TKECamOrPhotosViewDelegate
 - (void)selectItem:(NSInteger)item
{
    
    
    if(item == 0)
    {///相机
        AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            NSURL * url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
            
            if ( [[UIApplication sharedApplication] canOpenURL: url] ) {
                
                NSURL*url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                [[UIApplication sharedApplication] openURL:url];
                
            }
            return;
        }
        
        ////
        PGGCameraViewController *pvc = [[PGGCameraViewController alloc] init];
        [pvc setDelegate:self];
        [self.viewController presentViewController:pvc animated:YES completion:nil];
        
        
        
    }
    else if (item == 1)
    {///相册
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            NSURL * url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
            
            if ( [[UIApplication sharedApplication] canOpenURL: url] ) {
                
                NSURL*url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                [[UIApplication sharedApplication] openURL:url];
                
            }
            return;
        }
        
        NSInteger inowcount = maxPictureNumber -_selectedPhotos.count;
        if (inowcount <= 0) {
            return;
        }
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:inowcount columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
        imagePickerVc.isSelectOriginalPhoto = NO;
//        NSMutableArray *arrtemp = [NSMutableArray new];
//        for(id value in _selectedAssets)
//        {
//            if([value isKindOfClass:[NSString class]])
//            {
//
//            }
//            else
//            {
//                [arrtemp addObject:value];
//            }
//        }
//        imagePickerVc.selectedAssets = arrtemp; // 目前已经选中的图片数组
        imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
        // 2. 在这里设置imagePickerVc的外观
        if (iOS7Later) {
            imagePickerVc.navigationBar.barTintColor = RadMenuColor;
        }
        imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
        imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
        imagePickerVc.navigationBar.translucent = NO;
        
        // 3. 设置是否可以选择视频/图片/原图
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        
        // 4. 照片排列按修改时间升序
        imagePickerVc.sortAscendingByModificationDate = NO;
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
//        if(_selectedPhotos==nil)
//        {
//            _selectedAssets = [NSMutableArray new];
//        }
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            
            [_selectedPhotos addObjectsFromArray:photos];
//            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
            if ([self.delegate respondsToSelector:@selector(picturePickerDidSelectPhotos:)]) {
                [self.delegate picturePickerDidSelectPhotos:_selectedPhotos.mutableCopy];
            }
        }];
        if ([self.delegate respondsToSelector:@selector(pictureSelectBeginSkipToTargetVc:)]) {
            [self.delegate pictureSelectBeginSkipToTargetVc:imagePickerVc];
        }
    }
    
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    
    if([_selectedPhotos[sender.tag] isKindOfClass:[NSURL class]])
    {
        NSURL *url = _selectedPhotos[sender.tag];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL isremove = [fileManager removeItemAtPath:[url path] error:Nil];
        if(isremove)
        {
            NSLog(@"删除成功");
        }
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    
//    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
    if ([self.delegate respondsToSelector:@selector(picturePickerDidSelectPhotos:)]) {
        [self.delegate picturePickerDidSelectPhotos:_selectedPhotos.mutableCopy];
    }
}

-(void)setcaogaoImage:(NSArray *)arrvalue
{
    if(_selectedPhotos == nil)
    {
        _selectedPhotos = [NSMutableArray new];
    }
//    if(_selectedAssets == nil)
//    {
//        _selectedAssets = [NSMutableArray new];
//    }
//    [_selectedAssets addObjectsFromArray:arrvalue];
    
    [_selectedPhotos addObjectsFromArray:arrvalue];
    [_collectionView reloadData];
    
}

#pragma mark - 自定义相机返回数据
- (void)cameraMovieBack:(NSURL *)movieurl;
{
    [_selectedPhotos addObject:movieurl];
    [_collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(picturePickerDidSelectPhotos:)]) {
        [self.delegate picturePickerDidSelectPhotos:_selectedPhotos.mutableCopy];
    }
    
}
- (void)cameraPhotoBack:(UIImage *)image
{
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(picturePickerDidSelectPhotos:)]) {
        [self.delegate picturePickerDidSelectPhotos:_selectedPhotos.mutableCopy];
    }
}



@end
