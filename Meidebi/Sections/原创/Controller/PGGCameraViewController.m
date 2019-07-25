//
//  PGGCameraViewController.m
//  Meidebi
//  自定义相机
//  Created by mdb-losaic on 2018/5/23.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PGGCameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import <AVKit/AVKit.h>

#import "PGGCameraLineView.h"

#import "GMDCircleLoader.h"

@interface PGGCameraViewController ()<AVCaptureFileOutputRecordingDelegate>
{
    AVPlayer * player;
    
    PGGCameraLineView *lineview;
    
    NSTimer *timerRecode;
    
    int itimercount;
    
    UIImage *imagenow;
    NSURL *movienow;
    
    NSTimer *timerduijiao;
}
@property(nonatomic,retain)AVPlayerItem * playItem;

@property (nonatomic , retain) AVPlayerViewController *avc;

/*
 *  AVCaptureSession:它从物理设备得到数据流（比如摄像头和麦克风），输出到一个或
 *  多个目的地，它可以通过
 *  会话预设值(session preset)，来控制捕捉数据的格式和质量
 */
@property (nonatomic, strong) AVCaptureSession *iSession;
//设备
@property (nonatomic, strong) AVCaptureDevice *iDevice;
//输入
@property (nonatomic, strong) AVCaptureDeviceInput *iInput;

//照片输出
@property (nonatomic, strong) AVCaptureStillImageOutput *iOutput;
//视频输出
@property (nonatomic, strong) AVCaptureMovieFileOutput *iMovieOutput;
//预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *iPreviewLayer;

@property (nonatomic, assign) BOOL isluzhi;
@property (nonatomic, strong) UIButton *btAction;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PGGCameraViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.iSession) {
        [self.iSession startRunning];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:nil];
    [timerduijiao timeInterval];
    timerduijiao = nil;
    if (self.iSession) {
        [self.iSession stopRunning];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.iSession = [[AVCaptureSession alloc]init];
    
    if ([self.iSession canSetSessionPreset:AVCaptureSessionPreset1920x1080])
    {

        [self.iSession setSessionPreset:AVCaptureSessionPreset1920x1080];

    }
    else if ([self.iSession canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        
        [self.iSession setSessionPreset:AVCaptureSessionPreset1280x720];
        
    }
    else if ([self.iSession canSetSessionPreset:AVCaptureSessionPreset640x480])
    {
        
        [self.iSession setSessionPreset:AVCaptureSessionPreset640x480];
        
    }
    else if ([self.iSession canSetSessionPreset:AVCaptureSessionPreset352x288])
    {
        
        [self.iSession setSessionPreset:AVCaptureSessionPreset352x288];
        
    }
    else
    {
        [self.iSession setSessionPreset:AVCaptureSessionPresetLow];
        
    }
    
    NSArray *deviceArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in deviceArray) {
        if (device.position == AVCaptureDevicePositionBack) {
            self.iDevice = device;
        }
    }
    
    //添加摄像头设备
    //对设备进行设置时需上锁，设置完再打开锁
    [self.iDevice lockForConfiguration:nil];
    AVCapturePhotoSettings *setphoto = [[AVCapturePhotoSettings alloc] init];
    [setphoto setFlashMode:AVCaptureFlashModeAuto];
    
    if ([self.iDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
        [self.iDevice setFlashMode:AVCaptureFlashModeAuto];
    }
    if ([self.iDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [self.iDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([self.iDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
        [self.iDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
    }
    
    [self.iDevice unlockForConfiguration];
    
    //添加音频设备
    AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    self.iInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.iDevice error:nil];
    
    
    self.iOutput = [[AVCaptureStillImageOutput alloc]init];
    NSMutableDictionary *setDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    
//    [setDic setObject: [NSNumber numberWithInt:5] forKey:AVVideoMaxKeyFrameIntervalKey];
//
//    [setDic setObject:AVVideoProfileLevelH264Main30 forKey:AVVideoProfileLevelKey];
    self.iOutput.outputSettings = setDic;
    
    
    
    
    self.iMovieOutput = [[AVCaptureMovieFileOutput alloc]init];
    
    
    //设置视频防抖
    AVCaptureConnection *connection = [self.iMovieOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([connection isVideoStabilizationSupported]) {
        connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
    }
    
    NSMutableDictionary *compressionProperties = [[NSMutableDictionary alloc]init];


    [compressionProperties setObject: [NSNumber numberWithInt:3] forKey:AVVideoMaxKeyFrameIntervalKey];

    [compressionProperties setObject:AVVideoProfileLevelH264Main30 forKey:AVVideoProfileLevelKey];

    @try {
        if(IOS_VERSION_10_OR_ABOVE)
        {
            [self.iMovieOutput setOutputSettings:compressionProperties forConnection:connection];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    
//    AVCaptureConnection *connect =
    [self.iMovieOutput connectionWithMediaType:AVMediaTypeVideo];
//    if (connection ==  nil) {
//        return;
//    }
    if ([self.iSession canAddInput:self.iInput]) {
        [self.iSession addInput:self.iInput];
    }
    
    
    ////iOutput  iMovieOutput
    if ([self.iSession canAddOutput:self.iMovieOutput]) {
        [self.iSession addOutput:self.iMovieOutput];
        
    }
    
    
    if ([self.iSession canAddOutput:self.iOutput]) {
        [self.iSession addOutput:self.iOutput];
    }
    
    
    if ([self.iSession canAddInput:audioInput]) {
        [self.iSession addInput:audioInput];
    }
    
    self.iPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.iSession];
    [self.iPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.iPreviewLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.iPreviewLayer atIndex:0];
    
    [self.iSession startRunning];
    
    
    
    
    UIView *viewline=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 72*kScale, 72*kScale)];
    [viewline setBackgroundColor:[UIColor clearColor]];
    [viewline.layer setMasksToBounds:YES];
    [viewline.layer setCornerRadius:viewline.height/2.0];
    [viewline.layer setBorderColor:RGB(221,221,221).CGColor];
    [viewline.layer setBorderWidth:12*kScale];
    [viewline setCenter:CGPointMake(BOUNDS_WIDTH/2.0, BOUNDS_HEIGHT-100)];
    [self.view addSubview:viewline];
    
    lineview = [[PGGCameraLineView alloc] initWithFrame:CGRectMake(viewline.left, viewline.top, viewline.width, viewline.height)];
    [lineview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:lineview];
    
    _btAction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60*kScale, 60*kScale)];
    [_btAction setBackgroundColor:[UIColor whiteColor]];
    [_btAction addTarget:self action:@selector(bttapdownAction) forControlEvents:UIControlEventTouchDown];
    [_btAction addTarget:self action:@selector(bttapupAction) forControlEvents:UIControlEventTouchUpInside];
    [_btAction setCenter:CGPointMake(BOUNDS_WIDTH/2.0, BOUNDS_HEIGHT-100)];
    [_btAction.layer setMasksToBounds:YES];
    [_btAction.layer setCornerRadius:_btAction.height/2.0];
    [self.view addSubview:_btAction];
    
    UIButton *btback = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [btback setCenter:CGPointMake(60, _btAction.center.y)];
    [btback addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btback];
    UIImageView *imgvback = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [imgvback setImage:[UIImage imageNamed:@"pggphoto_action"]];
    [imgvback setContentMode:UIViewContentModeScaleAspectFit];
    [imgvback setCenter:CGPointMake(btback.width/2.0, btback.height/2.0)];
    [btback addSubview:imgvback];
    
    UILabel *lbtemp = [[UILabel alloc] initWithFrame:CGRectMake(0, _btAction.top-70, BOUNDS_WIDTH, 20)];
    [lbtemp setText:@"轻触拍照，长按摄像"];
    [lbtemp setTextColor:RGB(248,248,249)];
    [lbtemp setTextAlignment:NSTextAlignmentCenter];
    [lbtemp setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:lbtemp];
 
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.iDevice];
    timerduijiao = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(subjectAreaDidChange) userInfo:nil repeats:YES];
}

- (void)subjectAreaDidChange

{

    //先进行判断是否支持控制对焦

    if (self.iDevice.isFocusPointOfInterestSupported &&[self.iDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {



        NSError *error =nil;

        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，

        // 自动白平衡
        if ([self.iDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            
            [self.iDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        
        [self.iDevice lockForConfiguration:&error];

        [self.iDevice setFocusMode:AVCaptureFocusModeAutoFocus];

//        [self.iDevice focusAtPoint:self.view.center];

        //操作完成后，记得进行unlock。

        [self.iDevice unlockForConfiguration];
        
    }

}

-(void)backAction
{
    if(self.navigationController != nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

///点下
-(void)bttapdownAction
{
    _isluzhi = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(luzhiAction) userInfo:nil repeats:NO];
    
    
}
///放开
-(void)bttapupAction
{
    if(timerRecode!= nil)
    {
        [timerRecode invalidate];
        timerRecode = nil;
    }
    [lineview drawProgress:0];
    [_btAction setUserInteractionEnabled:YES];
    
    [_timer invalidate];
    _timer = nil;
    if(_isluzhi)
    {///录制的视频
        if ([self.iMovieOutput isRecording]) {
            [self.iMovieOutput stopRecording];
        }
        
        
    }
    else
    {///拍照
        
        [self.iSession beginConfiguration];
        if ([self.iSession canAddOutput:self.iOutput]) {
            [self.iSession addOutput:self.iOutput];
        }
        
//        [self.iSession removeOutput:self.iMovieOutput];
        
        [self.iSession commitConfiguration];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(paizhaoyanshi) userInfo:nil repeats:NO];
        
        
    }
}

-(void)paizhaoyanshi
{
    
    AVCaptureConnection *connection = [self.iOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection ==  nil) {
        return;
    }
    
    [self.iOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (!imageDataSampleBuffer) {
            ///失败
            //                [[CustomeAlertView shareView] showCustomeAlertViewWithMessage:@"Default"];
        } else{
            //                [[CustomeAlertView shareView] showCustomeAlertViewWithMessage:@"Success"];
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            
            [self drawImageShow:image];
            imagenow = image;
            //                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
        }
    }];
}

-(void)luzhiAction
{
    _isluzhi = YES;
    [self.iSession beginConfiguration];
    
//    [self.iSession removeOutput:self.iOutput];
    
    if ([self.iSession canAddOutput:self.iMovieOutput]) {
        [self.iSession addOutput:self.iMovieOutput];
        
    }
    
//    [self.iSession removeOutput:self.iOutput];
    
    [self.iSession commitConfiguration];
    
//    //设置视频防抖
//    AVCaptureConnection *connection = [self.iMovieOutput connectionWithMediaType:AVMediaTypeVideo];
//    if ([connection isVideoStabilizationSupported]) {
//        connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
//    }
//
//    AVCaptureConnection *connect = [self.iMovieOutput connectionWithMediaType:AVMediaTypeVideo];
//    if (connect ==  nil) {
//        return;
//    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(luzhiyanshi) userInfo:nil repeats:NO];
    
    
}

-(void)luzhiyanshi
{
    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"]];
    if (![self.iMovieOutput isRecording]) {
        [self.iMovieOutput startRecordingToOutputFileURL:url recordingDelegate:self];
    }
    itimercount = 0;
    timerRecode = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(camerTimeAction) userInfo:nil repeats:YES];
}

-(void)camerTimeAction
{
    itimercount++;
    float fvalue = itimercount*100/60.0/1000;
    [lineview drawProgress:fvalue];
    if(fvalue>=1.0)
    {
        [timerRecode invalidate];
        timerRecode = nil;
        [_btAction setUserInteractionEnabled:NO];
        if ([self.iMovieOutput isRecording]) {
            [self.iMovieOutput stopRecording];
        }
    }
}


- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}//此方法可以获取视频文件的时长。


- (void)mov2mp4:(NSURL *)movUrl
{
    [GMDCircleLoader setOnView:self.view.window withTitle:nil animated:YES];
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    /**
     AVAssetExportPresetMedium0Quality 表示视频的转换质量，
     */
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];

        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        //转换完成保存的文件路径 [NSURL fileURLWithPath:movUrl];   [NSURL fileURLWithPath:resultPath];
        NSString * resultPath = [docDir stringByAppendingFormat:@"/%@.mp4",[formatter stringFromDate:date]];
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        //要转换的格式，这里使用 MP4
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        //转换的数据是否对网络使用优化
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        //异步处理开始转换
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             //转换状态监控
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                 {
                     //转换完成
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     movienow = exportSession.outputURL;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [GMDCircleLoader hideFromView:self.view.window animated:YES];
                         float fsize = [self getFileSize:[movienow path]];
                         NSLog(@"%lf",fsize);
                         [self drawVedioShowandurl:[movienow absoluteString]];
                     });
                 }
             }
             
         }];
        
    }
    
}


-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"q234");
    [self mov2mp4:outputFileURL];
    
//    //保存视频到相册
//    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
//    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:nil];
//    [[CustomeAlertView shareView] showCustomeAlertViewWithMessage:@"视频保存成功"];
}


#pragma mark - 录像后显示
-(void)drawVedioShowandurl:(NSString *)strurl
{
    UIView *viewback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT)];
    [self.view.window addSubview:viewback];
    self.avc = [[AVPlayerViewController alloc] init];
    [viewback addSubview:self.avc.view];
    [self.avc.view setFrame:CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT)];
    
    NSURL *urlplay = [NSURL URLWithString:strurl];
    
    //确定视频资源 一个视频用一个item
    self.playItem=[AVPlayerItem playerItemWithURL:urlplay];
    //确定视频视频框架
    player = [AVPlayer playerWithPlayerItem: self.playItem];
    
    self.avc.player=player;
    
    //隐藏系统自带的进度条播放界面
    self.avc.showsPlaybackControls = NO;
    
    player.externalPlaybackVideoGravity=AVLayerVideoGravityResizeAspectFill;
    
    [self.avc.player play];
    
    
    UIButton *btback = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [btback setCenter:CGPointMake(BOUNDS_WIDTH/4.0, self.view.bounds.size.height - 70)];
    [btback addTarget:self action:@selector(dismisAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewback addSubview:btback];
    
    UIButton *btok = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [btok setCenter:CGPointMake(BOUNDS_WIDTH/4.0*3.0, btback.center.y)];
    [btok addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewback addSubview:btok];
    [btback setImage:[UIImage imageNamed:@"pggphoto_back"] forState:UIControlStateNormal];
    [btok setImage:[UIImage imageNamed:@"pggphoto_ok"] forState:UIControlStateNormal];
}


#pragma mark - 拍照后图片显示
-(void)drawImageShow:(UIImage *)image
{
    UIImageView *imgvc = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT)];
    [imgvc setImage:image];
    [imgvc setUserInteractionEnabled:YES];
    [self.view.window addSubview:imgvc];
    
    UIButton *btback = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [btback setBackgroundColor:[UIColor grayColor]];
    [btback setCenter:CGPointMake(BOUNDS_WIDTH/4.0, imgvc.height - 70)];
    [btback addTarget:self action:@selector(dismisAction:) forControlEvents:UIControlEventTouchUpInside];
    [imgvc addSubview:btback];
    
    UIButton *btok = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [btok setBackgroundColor:[UIColor grayColor]];
    [btok setCenter:CGPointMake(BOUNDS_WIDTH/4.0*3.0, btback.center.y)];
    [btok addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    [imgvc addSubview:btok];
    
    [btback setImage:[UIImage imageNamed:@"pggphoto_back"] forState:UIControlStateNormal];
    [btok setImage:[UIImage imageNamed:@"pggphoto_ok"] forState:UIControlStateNormal];
}

-(void)okAction:(UIButton *)sender
{
    ///还需要将数据回传
    if(_isluzhi)
    {
        [self.delegate cameraMovieBack:movienow];
        [self.avc.player pause];
    }
    else
    {
        [self.delegate cameraPhotoBack:imagenow];
    }
    [sender.superview removeFromSuperview];
    
    [self backAction];
}

-(void)dismisAction:(UIButton *)sender
{
    [sender.superview removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
