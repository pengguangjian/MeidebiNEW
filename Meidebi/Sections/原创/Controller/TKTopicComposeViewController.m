//
//  TKTopicComposeViewController.m
//  TaokeSecretary
//  编辑原创
//  Created by mdb-losaic on 2018/1/17.
//  Copyright © 2018年 leecool. All rights reserved.
//

#import "TKTopicComposeViewController.h"
#import "TKTopicComposeSubjectView.h"
#import "OriginalDatacontroller.h"
#import "TKQiniuHelper.h"
#import "GMDCircleLoader.h"
#import "MDB_UserDefault.h"
@interface TKTopicComposeViewController ()
<
TKTopicComposeSubjectViewDelegate
>
{
    
    NSTimer *timer;
    
    NSString *strcaogaoids;
    
    BOOL isvaluechange;
    
    NSString *strcaogaopicurl;
    
    BOOL iscaobaopicchange;
    
    
    BOOL issavecaogao;
    
    ///视频地址
    NSString *strvodiourl;
    ///视频第一帧图片
    NSString *strimageVodio;
}
@property (nonatomic, assign) TKTopicType topicType;
@property (nonatomic, strong) TKTopicComposeSubjectView *subjectView;
@property (nonatomic, strong) NSMutableArray *topicPics;
@property (nonatomic, strong) NSString *topicContentStr;
@property (nonatomic, strong) NSString *topicTitleStr;
@property (nonatomic, strong) GMDCircleLoader *loadDataView;
@property (nonatomic, strong) OriginalDatacontroller *dataController;
@property (nonatomic, strong) UIButton* btnright;
@property (nonatomic, strong) NSString *imagesStr;
@property (nonatomic, assign) BOOL isPictureChange;
@end

@implementation TKTopicComposeViewController
- (instancetype)initWithTopicType:(TKTopicType)type{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _topicType = type;
    }
    return self;
}

-(void)dealloc
{
    [timer timeInterval];
    timer = nil;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    strcaogaopicurl = @"";
    timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(saveCaoGao) userInfo:nil repeats:YES];
    strcaogaoids = _strcaogaoid;
    if(strcaogaoids == nil)
    {
        strcaogaoids = @"";
    }
    [self configurUI];
    
    if(strcaogaoids.length>0)
    {
        [self getcaogaoData];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer timeInterval];
    [self saveCaoGao];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigation];
    self.title = @"发布帖子";
    _subjectView = [[TKTopicComposeSubjectView alloc] initWithTopicType:_topicType];
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

-(void)setNavigation{
//    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnright.frame = CGRectMake(0,0,50,30);
//    btnright.backgroundColor = RadMenuColor;
//    [btnright setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnright setTitle:@"发布" forState:UIControlStateNormal];
//    [btnright.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
//    [btnright.layer setMasksToBounds:YES];
//    [btnright.layer setCornerRadius:3.f];
//    [btnright addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventTouchUpInside];
//    _btnright = btnright;
//    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
}

-(void)doClickBackAction
{
    if(_topicContentStr.length<1 && _topicTitleStr.length<1 && _topicPics.count<1&&isvaluechange==NO)
    {
        
    }
    else
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"草稿已保存，可在“个人中心-原创中”查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmSubmit{
    [_subjectView registerKeyWord];
    if (_topicType != TKTopicTypeSpitslot) {
        if ([@"" isEqualToString:[NSString nullToString:_topicTitleStr]]) {
            [MDB_UserDefault showNotifyHUDwithtext:@"请输入帖子标题" inView:self.view];
            return;
        }
    }
    if ([@"" isEqualToString:[NSString nullToString:_topicContentStr]]) {
        [MDB_UserDefault showNotifyHUDwithtext:@"请输入帖子内容" inView:self.view];
        return;
    }
    if (_topicContentStr.length < 5) {
        [MDB_UserDefault showNotifyHUDwithtext:@"帖子内容不少于5个字!" inView:self.view];
        return;
    }
//    if ((_topicType == TKTopicTypeShaiDan ||
//         _topicType == TKTopicTypeLooks ||
//         _topicType == TKTopicTypeEvaluation) && _topicPics.count <= 0) {
    if(_topicType != TKTopicTypeSpitslot)
    {
        if (_topicPics.count <= 0) {
            [MDB_UserDefault showNotifyHUDwithtext:@"请选择你晒单的图片" inView:self.view];
            return;
        }
    }
    
    if(_topicType==TKTopicTypeUnknown)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"请选择帖子分类" inView:self.view];
        return;
    }
    
    
    _subjectView.userInteractionEnabled = NO;
    _btnright.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [GMDCircleLoader setOnView:self.view withTitle:nil animated:YES];
    _imagesStr = strcaogaopicurl;
    
    [timer invalidate];
    timer = nil;
    
    if (_topicPics.count>0) {
        
        if([_topicPics[0] isKindOfClass:[NSURL class]])
        {///视频
            if(strvodiourl && !_isPictureChange)
            {///图片和视频已存
                [self posteTopicWihthImages:strcaogaopicurl];
            }
            else
            {
                [self pushVedio];
            }
        }
        else
        {///图片
            if (_imagesStr && !_isPictureChange) {
                [self posteTopicWihthImages:_imagesStr];
            }else{
                
                [self pushImage];
            }
        }
        
        
    }else{
        ///无视频和图片
        [self posteTopicWihthImages:nil];
    }
    
}

///发布图片
-(void)pushImage
{
    ///判断是否有新加的图片
    BOOL isyouimage = NO;
    NSMutableArray *arrtempimages = [NSMutableArray new];
    for(id value in _topicPics)
    {
        if([value isKindOfClass:[UIImage class]])
        {
            isyouimage = YES;
            [arrtempimages addObject:value];
        }
    }
    
    ///是否有新加的图片
    if(isyouimage)
    {
        [self.dataController requestUploadImageToken:arrtempimages.count targetView:nil  callback:^(NSError *error, BOOL state, NSString *describle) {
            if (state) {
                
                NSMutableArray *arrtempimages1 = [NSMutableArray new];
                for(id value in _topicPics)
                {
                    if([value isKindOfClass:[NSString class]])
                    {
                        [arrtempimages1 addObject:value];
                    }
                }
                NSString *strimageurls1 = [NSString nullToString:[arrtempimages1 componentsJoinedByString:@","]];
                
                [self updateImageWithTokens:self.dataController.resultDict andimages:arrtempimages andstringurls:strimageurls1];
                
                
            }else{
                [GMDCircleLoader hideFromView:self.view animated:YES];
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                _subjectView.userInteractionEnabled = YES;
                _btnright.userInteractionEnabled = YES;
                self.navigationController.navigationBar.userInteractionEnabled = YES;
            }
        }];
    }
    else
    {
        [self posteTopicWihthImages:_imagesStr];
    }
}

///发布视频
-(void)pushVedio
{
    [self.dataController requestUploadMovieToken:@"mp4" targetView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
        NSLog(@"%@",self.dataController.resultDict);
        if (state) {
            NSData *datatemp = [NSData dataWithContentsOfURL:_topicPics[0]];
            NSArray *arrimage = [NSArray arrayWithObjects:datatemp, nil];
            [[TKQiniuHelper currentHelper] uploadDataWithTokens:self.dataController.resultDict images:arrimage callback:^(BOOL state, NSArray *urls , NSArray *picurls) {
                NSLog(@"%@",urls);
                if(state && urls.count>0 && picurls.count >0)
                {
                    NSString *strurls = urls[0];
                    NSString *strimagesurl = picurls[0];
                    strvodiourl = strurls;
                    strcaogaopicurl = strimagesurl;
                    
                    [self posteTopicWihthImages:strcaogaopicurl];
                    
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:@"发布失败" inView:self.view];
                }
                
            }];
            
        }
        else{
            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
        }
    }];
}

- (void)updateImageWithTokens:(NSDictionary *)token andimages:(NSMutableArray *)images andstringurls:(NSString *)strurls {
    [[TKQiniuHelper currentHelper] uploadImageToQNWithTokens:token
                                                      images:images
                                                    callback:^(BOOL state, NSArray *urls) {
                                                        if (state) {
                                                            
                                                            if(strurls.length>1)
                                                            {
                                                                NSString *strurlspush = [NSString stringWithFormat:@"%@,%@",strurls,[urls componentsJoinedByString:@","]];
                                                                [self posteTopicWihthImages:strurlspush];
                                                            }
                                                            else
                                                            {
                                                               [self posteTopicWihthImages:[urls componentsJoinedByString:@","]];
                                                            }
                                                            
                                                            
                                                        }else{
                                                            [GMDCircleLoader hideFromView:self.view animated:YES];
                                                            [MDB_UserDefault showNotifyHUDwithtext:@"图片上传失败！" inView:self.view];
                                                            _subjectView.userInteractionEnabled = YES;
                                                            _btnright.userInteractionEnabled = YES;
                                                        self.navigationController.navigationBar.userInteractionEnabled = YES;

                                                        }
    }];
}

- (void)posteTopicWihthImages:(NSString *)images{
    _isPictureChange = NO;
    _imagesStr = images;
    
    NSString *strvideo = @"0";
    if(_topicPics.count==1)
    {
        if([_topicPics[0] isKindOfClass:[NSURL class]])
        {
            strvideo = @"1";
        }
    }
    
    NSArray *arrimages = [images componentsSeparatedByString:@","];
    NSMutableArray *arrtemp = [NSMutableArray new];
    for(int i = 0 ; i <arrimages.count; i++)
    {
        
        arrtemp[i] = [NSString nullToString:[MDB_UserDefault getCompleteWebsite:arrimages[i]]];
        
    }
    images = [arrtemp componentsJoinedByString:@","];
    
    strvodiourl = [NSString nullToString:[MDB_UserDefault getCompleteWebsite:strvodiourl]];
    
    [self.dataController requestPosteTopicWithType:_topicType
                                             title:_topicTitleStr
                                           content:_topicContentStr
                                            images:images
                                          draft_id:strcaogaoids
                                          is_video:strvideo
                                          videourl:strvodiourl
                                          callback:^(NSError *error, BOOL state, NSString *describle){
                                              [GMDCircleLoader hideFromView:self.view animated:YES];
                                              [MDB_UserDefault showNotifyHUDwithtext:describle inView:_subjectView];
                                              if (state) {
                                                  
//                                                  [self removeCaogao];
                                                  
                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                      
                                                      [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"wodeyuanchuangRef"];
                                                      
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                      
                                                      
                                                  });
                                              }else{
                                                  _subjectView.userInteractionEnabled = YES;
                                                  _btnright.userInteractionEnabled = YES;
                                                  self.navigationController.navigationBar.userInteractionEnabled = YES;
                                              }
                                              
    }];
}


-(void)removeCaogao
{
    if(strcaogaoids.length<1)
    {
        return;
    }
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:strcaogaoids forKey:@"draft_id"];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    
    [_dataController requestRemoveCaoGaoValue:dicpush callback:^(NSError *error, BOOL state, NSString *describle) {
       
        
        
    }];
    
}

#pragma mark - TKTopicComposeSubjectViewDelegate
- (void)topicComposeTopicType:(TKTopicType)type
{
    _topicType = type;
}
- (void)topicComposeSubjectViewStarSelectImageWithTarget:(UIViewController *)vc{
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)topicComposeDidWriteContent:(NSString *)content{
    _topicContentStr = content;
    
    isvaluechange = YES;
}

- (void)topicComposeDidWriteTitle:(NSString *)title{
    _topicTitleStr = title;
    
    isvaluechange = YES;
    
}

- (void)topicComposeDidSelectPictures:(NSArray *)pictures{
    _isPictureChange = YES;
    _topicPics = (NSMutableArray *)pictures;
    isvaluechange = YES;
    iscaobaopicchange = YES;
    strcaogaopicurl = @"";
    
    
    
}

- (void)topicComposeBottomActionTag:(NSInteger)tag
{
    
    if(tag == 1)
    {///发布
        [self confirmSubmit];
    }
    else if (tag == 2)
    {///保存草稿
        issavecaogao = YES;
        [self saveCaoGao];
        
        
        
    }
    
}

///保存草稿
-(void)saveCaoGao
{
    if(_topicContentStr.length<1 && _topicTitleStr.length<1 && _topicPics.count<1)
    {
        return;
    }
    if(isvaluechange ==NO)
    {
        return;
    }
    
    if (!_dataController) {
        _dataController = [[OriginalDatacontroller alloc] init];
    }
    
    
    if(_topicContentStr.length<1)
    {
        _topicContentStr = @"";
    }
    if(_topicTitleStr.length<1)
    {
        _topicTitleStr = @"";
    }
    
    
    if(_topicPics.count<1)
    {
        NSMutableDictionary *dicpush = [NSMutableDictionary new];
        [dicpush setObject:strcaogaoids forKey:@"draft_id"];
        [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
        [dicpush setObject:_topicTitleStr forKey:@"title"];
        [dicpush setObject:_topicContentStr forKey:@"content"];
        [dicpush setObject:@"" forKey:@"images"];
        [dicpush setObject:[NSString stringWithFormat:@"%@",@(_topicType)] forKey:@"classify"];
        [dicpush setObject:@"0" forKey:@"video_type"];
        [dicpush setObject:@"" forKey:@"video"];
        [self pusCaogao:dicpush];
        
    }
    else
    {
        
        if(_topicPics.count == 1 && [_topicPics[0] isKindOfClass:[NSURL class]])
        {///视频
            [self movieUrlPush:_topicPics[0]];
        }
        else
        {
            if(iscaobaopicchange == YES)
            {
                iscaobaopicchange = NO;
                BOOL isyouimage = NO;
                NSMutableArray *arrtempimages = [NSMutableArray new];
                for(id value in _topicPics)
                {
                    if([value isKindOfClass:[UIImage class]])
                    {
                        isyouimage = YES;
                        [arrtempimages addObject:value];
                    }
                }
                
                if(isyouimage)
                {
                    UIView *viewtemp = nil;
                    if(issavecaogao)
                    {
                        viewtemp = self.view;
                    }
                    ///获取token
                    [self.dataController requestUploadImageToken:arrtempimages.count targetView:viewtemp callback:^(NSError *error, BOOL state, NSString *describle) {
                        if (state) {
                            [[TKQiniuHelper currentHelper] uploadImageToQNWithTokens:self.dataController.resultDict
                                                                              images:arrtempimages
                                                                            callback:^(BOOL state, NSArray *urls) {
                                                                                if (state) {
                                                                                    NSString *strimageurls = [NSString nullToString:[urls componentsJoinedByString:@","]];
                                                                                    
                                                                                    ////拼接strcaogaopicurl
                                                                                    NSMutableArray *arrtempimages1 = [NSMutableArray new];
                                                                                    for(id value in _topicPics)
                                                                                    {
                                                                                        if([value isKindOfClass:[NSString class]])
                                                                                        {
                                                                                            [arrtempimages1 addObject:value];
                                                                                        }
                                                                                    }
                                                                                    if(arrtempimages1.count>0)
                                                                                    {
                                                                                        NSString *strimageurls1 = [NSString nullToString:[arrtempimages1 componentsJoinedByString:@","]];
                                                                                        
                                                                                        strcaogaopicurl = [NSString stringWithFormat:@"%@,%@",strimageurls1,strimageurls];
                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        strcaogaopicurl = strimageurls;
                                                                                        
                                                                                    }
                                                                                    
                                                                                    ///将图片替换成url
                                                                                    @try
                                                                                    {
                                                                                        
                                                                                        for(int i = 0 ; i <arrtempimages.count;i++)
                                                                                        {
                                                                                            
                                                                                            for(int j = 0 ; j<_topicPics.count; j++)
                                                                                            {
                                                                                                id value = _topicPics[j];
                                                                                                if([value isEqual:arrtempimages[i]])
                                                                                                {
                                                                                                    
                                                                                                    _topicPics[j] = urls[i];
                                                                                                    
                                                                                                }
                                                                                            }
                                                                                            
                                                                                        }
                                                                                        
                                                                                    }
                                                                                    @catch(NSException *exc)
                                                                                    {
                                                                                        
                                                                                    }
                                                                                    @finally
                                                                                    {
                                                                                        
                                                                                    }
                                                                                    
                                                                                    
                                                                                    
                                                                                    NSMutableDictionary *dicpush = [NSMutableDictionary new];
                                                                                    [dicpush setObject:strcaogaoids forKey:@"draft_id"];
                                                                                    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
                                                                                    [dicpush setObject:_topicTitleStr forKey:@"title"];
                                                                                    [dicpush setObject:_topicContentStr forKey:@"content"];
                                                                                    [dicpush setObject:strcaogaopicurl forKey:@"images"];
                                                                                    [dicpush setObject:[NSString stringWithFormat:@"%@",@(_topicType)] forKey:@"classify"];
                                                                                    [dicpush setObject:@"0" forKey:@"video_type"];
                                                                                    [dicpush setObject:@"" forKey:@"video"];
                                                                                    [self pusCaogao:dicpush];
                                                                                }
                                                                                else
                                                                                {
                                                                                    iscaobaopicchange = YES;
                                                                                }
                                                                            }];
                            
                        }else{
                            [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
                        }
                    }];
                }
                else
                {
                    NSString *strimageurls = [NSString nullToString:[_topicPics componentsJoinedByString:@","]];
                    strcaogaopicurl = strimageurls;
                    
                    
                    NSMutableDictionary *dicpush = [NSMutableDictionary new];
                    [dicpush setObject:strcaogaoids forKey:@"draft_id"];
                    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
                    [dicpush setObject:_topicTitleStr forKey:@"title"];
                    [dicpush setObject:_topicContentStr forKey:@"content"];
                    [dicpush setObject:strcaogaopicurl forKey:@"images"];
                    [dicpush setObject:[NSString stringWithFormat:@"%@",@(_topicType)] forKey:@"classify"];
                    [dicpush setObject:@"0" forKey:@"video_type"];
                    [dicpush setObject:@"" forKey:@"video"];
                    [self pusCaogao:dicpush];
                    
                }
                
            }
            else
            {
                NSMutableDictionary *dicpush = [NSMutableDictionary new];
                [dicpush setObject:strcaogaoids forKey:@"draft_id"];
                [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
                [dicpush setObject:_topicTitleStr forKey:@"title"];
                [dicpush setObject:_topicContentStr forKey:@"content"];
                [dicpush setObject:strcaogaopicurl forKey:@"images"];
                [dicpush setObject:[NSString stringWithFormat:@"%@",@(_topicType)] forKey:@"classify"];
                [dicpush setObject:@"0" forKey:@"video_type"];
                [dicpush setObject:@"" forKey:@"video"];
                [self pusCaogao:dicpush];
                
            }
        }
        
    }
    
}

#pragma mark - 视频处理
-(void)movieUrlPush:(NSURL *)url {
    
    if(iscaobaopicchange)
    {
        iscaobaopicchange = NO;
        [self.dataController requestUploadMovieToken:@"mp4" targetView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
            NSLog(@"%@",self.dataController.resultDict);
            if (state) {
                NSData *datatemp = [NSData dataWithContentsOfURL:url];
                NSArray *arrimage = [NSArray arrayWithObjects:datatemp, nil];
                [[TKQiniuHelper currentHelper] uploadDataWithTokens:self.dataController.resultDict images:arrimage callback:^(BOOL state, NSArray *urls , NSArray *picurls) {
                    NSLog(@"%@",urls);
                    if(state && urls.count>0 && picurls.count > 0)
                    {
                        NSString *strurls = urls[0];
                        NSString *strimagesurl = picurls[0];
                        strvodiourl = strurls;
                        strcaogaopicurl = strimagesurl;
                        NSMutableDictionary *dicpush = [NSMutableDictionary new];
                        [dicpush setObject:strcaogaoids forKey:@"draft_id"];
                        [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
                        [dicpush setObject:_topicTitleStr forKey:@"title"];
                        [dicpush setObject:_topicContentStr forKey:@"content"];
                        [dicpush setObject:strimagesurl forKey:@"images"];
                        [dicpush setObject:[NSString stringWithFormat:@"%@",@(_topicType)] forKey:@"classify"];
                        [dicpush setObject:@"1" forKey:@"video_type"];
                        [dicpush setObject:strurls forKey:@"video"];
                        
                        [self pusCaogao:dicpush];
                    }
                    else
                    {
                        iscaobaopicchange = YES;
                    }
                    
                }];
                
            }
            else{
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
        }];
    }
    else
    {
        if(strvodiourl==nil)return;
        
        NSMutableDictionary *dicpush = [NSMutableDictionary new];
        [dicpush setObject:strcaogaoids forKey:@"draft_id"];
        [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
        [dicpush setObject:_topicTitleStr forKey:@"title"];
        [dicpush setObject:_topicContentStr forKey:@"content"];
        [dicpush setObject:strcaogaopicurl forKey:@"images"];
        [dicpush setObject:[NSString stringWithFormat:@"%@",@(_topicType)] forKey:@"classify"];
        [dicpush setObject:@"1" forKey:@"video_type"];
        [dicpush setObject:strvodiourl forKey:@"video"];
        [self pusCaogao:dicpush];
    }
}

-(void)pusCaogao:(NSMutableDictionary *)dicpush
{
    UIView *viewtemp = nil;
    if(issavecaogao)
    {
        viewtemp = self.view;
    }
    
    
    NSArray *arrimages = [[dicpush objectForKey:@"images"] componentsSeparatedByString:@","];
    NSMutableArray *arrtemp = [NSMutableArray new];
    for(int i = 0 ; i <arrimages.count; i++)
    {
        
        arrtemp[i] = [NSString nullToString:[MDB_UserDefault getCompleteWebsite:arrimages[i]]];
        
    }
    [dicpush setObject:[arrtemp componentsJoinedByString:@","] forKey:@"images"];
    if([[dicpush objectForKey:@"video_type"] intValue] > 0)
    {
        [dicpush setObject:[NSString nullToString:[MDB_UserDefault getCompleteWebsite:[dicpush objectForKey:@"video"]]] forKey:@"video"];
    }
    
    strvodiourl = [NSString nullToString:[MDB_UserDefault getCompleteWebsite:strvodiourl]];
    
    [_dataController requestPosteTopicWithValue:dicpush targetView:viewtemp  callback:^(NSError *error, BOOL state, NSString *describle) {
       if(state == YES)
       {
           isvaluechange = NO;
           
           if(strcaogaoids.length>0)
           {
               
           }
           else
           {
               NSDictionary *dic = _dataController.diccaogao;
               strcaogaoids = [NSString nullToString:[dic objectForKey:@"draft_id"]];
           }
           if(issavecaogao)
           {
               issavecaogao = NO;
               
               [MDB_UserDefault showNotifyHUDwithtext:@"草稿保存成功" inView:self.view];
               
           }
       }
        
    }];
}


#pragma mark - 获取草稿数据
-(void)getcaogaoData
{
    if (!_dataController) {
        _dataController = [[OriginalDatacontroller alloc] init];
    }
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:strcaogaoids forKey:@"draft_id"];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    
    [_dataController requestGetCaoGaoWithValue:dicpush targetView:self.view callback:^(NSError *error, BOOL state, NSString *describle) {
       
        if(state)
        {
            NSDictionary *dicvalue = _dataController.dicgetcaogao;
            
            [_subjectView caogaoValue:dicvalue];
            _topicType = [[dicvalue objectForKey:@"type"] integerValue];
            if([[dicvalue objectForKey:@"video_type"] intValue] > 0)
            {///视频
                if(_topicPics==nil)
                {
                    _topicPics = [NSMutableArray new];
                }
                if([[dicvalue objectForKey:@"video"] isKindOfClass:[NSArray class]])
                {
                    NSArray *arrvideo = [dicvalue objectForKey:@"video"];
                    for(NSDictionary *dic in arrvideo)
                    {
                        NSString *strtemp = [NSString nullToString:[dic objectForKey:@"video_url"]];
                        [_topicPics addObject:[NSURL URLWithString:strtemp]];
                    }
                    strvodiourl = [_topicPics componentsJoinedByString:@","];
                }
                
                
                
                if([[dicvalue objectForKey:@"pics"] isKindOfClass:[NSArray class]])
                {
                    NSArray *arrtemp = [dicvalue objectForKey:@"pics"];
                    NSMutableArray *arrtemp1 = [[NSMutableArray alloc] initWithArray:arrtemp];
                    if(arrtemp1.count == 1)
                    {
                        if([[NSString nullToString:arrtemp1[0]] isEqualToString:@"0"])
                        {
                            [arrtemp1 removeObjectAtIndex:0];
                        }
                    }
                    strcaogaopicurl = [arrtemp1 componentsJoinedByString:@","];
                }
                
                
            }
            else
            {
                if([[dicvalue objectForKey:@"pics"] isKindOfClass:[NSArray class]])
                {
                    NSArray *arrpics = [dicvalue objectForKey:@"pics"];
                    NSMutableArray *arrtemp = [[NSMutableArray alloc] initWithArray:arrpics];
                    if(arrtemp.count == 1)
                    {
                        if([[NSString nullToString:arrtemp[0]] isEqualToString:@"0"])
                        {
                            [arrtemp removeObjectAtIndex:0];
                        }
                    }
                    
                    strcaogaopicurl = [NSString nullToString:[arrtemp componentsJoinedByString:@","]];
                    if(_topicPics==nil)
                    {
                        _topicPics = [NSMutableArray new];
                    }
                    [_topicPics addObjectsFromArray:arrtemp];
                }
            }
            
            
            
            _topicType = [[dicvalue objectForKey:@"type"] integerValue];
            _topicTitleStr = [NSString nullToString:[dicvalue objectForKey:@"title"]];
            _topicContentStr = [NSString nullToString:[dicvalue objectForKey:@"content"]];
            
        }
        
    }];
    
}


#pragma mark - setters and getters
- (OriginalDatacontroller *)dataController{
    if (!_dataController) {
        _dataController = [[OriginalDatacontroller alloc] init];
    }
    return _dataController;
}

@end
