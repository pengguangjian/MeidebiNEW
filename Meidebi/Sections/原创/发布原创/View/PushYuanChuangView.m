//
//  PushYuanChuangView.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/5.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PushYuanChuangView.h"

#import <YYTextView.h>

#import "PusnYuanChuangItemModel.h"

#import "MDB_UserDefault.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <TZImagePickerController/UIView+Layout.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZGifPhotoPreviewController.h>

#import "TKECamOrPhotosView.h"
#import "PGGCameraViewController.h"

#import "PushYuanChuangTextView.h"

#import "PGGMoviePlayer.h"

#import "PushYuanChuangLineAlterView.h"

#import "RemarkEmoticonInputView.h"

#import "TKTopicModuleConstant.h"

#import "PushYuangChuangDataController.h"

#import "TKQiniuHelper.h"

#import "GMDCircleLoader.h"


static NSString * const kTopicItemName = @"name";
static NSString * const kTopicItemIcon = @"image";
static NSString * const kTopicItemType = @"type";

@interface PushYuanChuangView ()<UIScrollViewDelegate,TKECamOrPhotosViewDelegate,PGGCameraViewControllerDelegate,UITextViewDelegate,PushYuanChuangLineAlterViewDelegate,RemarkStatusComposeEmoticonViewDelegate,UITextFieldDelegate,TZImagePickerControllerDelegate>
{
    
    PushYuanChuangTextView *textnow;
    
    UIScrollView *scvItemView;
    
    //头部
    UIView *viewheader;
    UITextField *fieldtitle;
    PushYuanChuangTextView *textviewhd;
    
    ///底部
    UIView *viewbottom;
    PushYuanChuangLineAlterView *pview;
    
    
    ///表情
    UIView *viewbiaoqing;
    
    ///分类
    UIView *typeView;
    NSMutableArray *_arrbtType;
    UIButton *_btnowSelectType;
    NSInteger _type;
    
    ///列表数据
    NSMutableArray *arrAllList;
    
    
    ///列表cell
    NSMutableArray *arrcellview;
    
    ///键盘的高度
    float fkeyboardheight;
    
    float flastscroll;
    float flastscrollcontentofsety;
    
    
    ///保存草稿
    NSTimer *timer;
    
    BOOL isvaluechange;
    
    
    BOOL isKeybodDidShow;
    
}

@property (nonatomic , retain) NSMutableArray *topicClassifys;
@property (nonatomic , retain) PushYuangChuangDataController *dataControl;
@end

@implementation PushYuanChuangView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        UITapGestureRecognizer *tapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboarddismis)];
        [self addGestureRecognizer:tapview];
        
        
        isvaluechange = NO;
        scvItemView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-45*kScale)];
        [self addSubview:scvItemView];
        [scvItemView setDelegate:self];
        [scvItemView setScrollEnabled:YES];
        [scvItemView setContentSize:CGSizeMake(0, scvItemView.height+1)];
        
        [self drawtabheaderView];
        [self drawBottomView];
        [self drawbiaoqing];
        
        [self drawfenlei];
        
        arrAllList = [NSMutableArray new];
        arrcellview = [NSMutableArray new];
        
        //注册键盘出现的通知

        [[NSNotificationCenter defaultCenter] addObserver:self

                                                 selector:@selector(keyboardWasShown:)

                                                     name:UIKeyboardWillShowNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWasDidShown:)
         
                                                     name:UIKeyboardDidShowNotification object:nil];///
        //注册键盘消失的通知

        [[NSNotificationCenter defaultCenter] addObserver:self

                                                 selector:@selector(keyboardWillBeHidden:)

                                                     name:UIKeyboardWillHideNotification object:nil];
        
        self.dataControl = [[PushYuangChuangDataController alloc] init];
        
        
        timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(saveCaoGao) userInfo:nil repeats:YES];
        
    }
    return self;
}

///获取草稿数据
-(void)getcaogaoNOMO:(NSString *)cgid
{
    if(cgid!=nil && cgid.length>0)
    {
        NSMutableDictionary *dicpush = [NSMutableDictionary new];
        [dicpush setObject:cgid forKey:@"draft_id"];
        [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
        
        [self.dataControl requestGetCaoGaoValue:dicpush targetView:self.window callback:^(NSError *error, BOOL state, NSString *describle) {
           
            if(state)
            {
                NSLog(@"++++=%@",self.dataControl.dicnomoCaoGaoValue);
                
                NSString *strcontent = [NSString nullToString:[self.dataControl.dicnomoCaoGaoValue objectForKey:@"content"]];
                NSString *strtitle = [NSString nullToString:[self.dataControl.dicnomoCaoGaoValue objectForKey:@"title"]];
                _type = [[self.dataControl.dicnomoCaoGaoValue objectForKey:@"classify"] integerValue];
                
                [fieldtitle setText:strtitle];
                
                [textviewhd setText:strcontent];
                float ftextheight = [MDB_UserDefault countTextSize:CGSizeMake(textviewhd.width, 1000) andtextfont:[UIFont systemFontOfSize:15] andtext:textviewhd.text].height+10;
                if(ftextheight<90)
                {
                    ftextheight = 90;
                }
                [textviewhd setHeight:ftextheight];
                [viewheader setHeight:textviewhd.bottom];
                
                NSInteger itemp = 0;
                for(NSDictionary *dic in _topicClassifys)
                {
                    if([[dic objectForKey:kTopicItemType] integerValue] == _type)
                    {
                        
                        break;
                    }
                    itemp++;
                }
                if(itemp!=0&&itemp<_topicClassifys.count)
                {
                    [self typeSelectAction:_arrbtType[itemp]];
                }
                
                
                
                if([[self.dataControl.dicnomoCaoGaoValue objectForKey:@"contentarr"] isKindOfClass:[NSArray class]])
                {
                    NSArray *arrcontentarr = [self.dataControl.dicnomoCaoGaoValue objectForKey:@"contentarr"] ;
                    
                    for(NSDictionary *dictemp in arrcontentarr)
                    {
                        
                        PusnYuanChuangItemModel *model = [PusnYuanChuangItemModel viewmodeldata:dictemp];
                        [arrAllList addObject:model];
                        if([model.strtype isEqualToString:@"image"])
                        {
                            UIView *viewitem = [self drawImageItemView:CGRectMake(10, viewheader.bottom+[self fitemheight], viewheader.width-20, 100) andPusnYuanChuangItemModel:model];
                            [viewitem setTag:arrcellview.count];
                            [scvItemView addSubview:viewitem];
                            [arrcellview addObject:viewitem];
                            
                        }
                        else if([model.strtype isEqualToString:@"video"])
                        {
                            UIView *viewitem = [self drawImageItemView:CGRectMake(10, viewheader.bottom+[self fitemheight], viewheader.width-20, 100) andPusnYuanChuangItemModel:model];
                            [viewitem setTag:arrcellview.count];
                            [scvItemView addSubview:viewitem];
                            [arrcellview addObject:viewitem];
                            
                        }
                        else if([model.strtype isEqualToString:@"goodscard"])
                        {
                            UIView *view = [self drawlineView:CGRectMake(10, viewheader.bottom+[self fitemheight]+10, scvItemView.width-20, 100) andmodel:model];
                            [view setTag:arrcellview.count];
                            [scvItemView addSubview:view];
                            
                            [arrcellview addObject:view];
                            
                        }
                        else if([model.strtype isEqualToString:@"link"])
                        {
                            UIView *view = [self drawlineView:CGRectMake(10, viewheader.bottom+[self fitemheight]+10, scvItemView.width-20, 100) andmodel:model];
                            [view setTag:arrcellview.count];
                            [scvItemView addSubview:view];
                            
                            [arrcellview addObject:view];
                            
                        }
                        
                        
                    }
                    
                }
                
                [self setscrollviewContentSize];
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:@"草稿获取失败" inView:self.window];
            }
            
        }];
        
        
        
    }
    
}




-(void)drawtabheaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scvItemView.width, 100)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    fieldtitle = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, view.width-20, 50*kScale)];
    [fieldtitle setTextColor:RGB(60, 60, 60)];
    [fieldtitle setTextAlignment:NSTextAlignmentLeft];
    [fieldtitle setFont:[UIFont systemFontOfSize:15]];
    [fieldtitle setPlaceholder:@"请输入标题"];
    [fieldtitle setDelegate:self];
    [view addSubview:fieldtitle];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, fieldtitle.bottom, view.width, 1)];
    [viewline setBackgroundColor:RGB(238, 238, 238)];
    [view addSubview:viewline];
    
    textviewhd = [[PushYuanChuangTextView alloc] initWithFrame:CGRectMake(8, viewline.bottom, view.width-16, 90)];
    [textviewhd setTextAlignment:NSTextAlignmentLeft];
    [textviewhd setTextColor:RGB(60, 60, 60)];
    [textviewhd setFont:[UIFont systemFontOfSize:14]];
    [textviewhd setPlaceholderText:@"来写写您的心得，自己的购买需求。对比经历。最终选择的理由，也可以选择简单谈下商品的使用感受~"];
    [textviewhd setTag:100];
    [textviewhd setDelegate:self];
    [view addSubview:textviewhd];
    
    [view setHeight:textviewhd.bottom];
    
    [scvItemView addSubview:view];
    viewheader = view;
}

-(void)drawBottomView
{
    viewbottom = [[UIView alloc] initWithFrame:CGRectMake(0, scvItemView.bottom, self.width, 45*kScale)];
    [viewbottom setBackgroundColor:RGB(245, 245, 245)];
    [self addSubview:viewbottom];
    viewbottom.layer.shadowColor = [UIColor blackColor].CGColor;
    viewbottom.layer.shadowOpacity = 0.4f;
    viewbottom.layer.shadowOffset = CGSizeMake(0,0);
    
    NSArray *arrtitle = [NSArray arrayWithObjects:@"插入图片",@"添加链接",@"添加分类", nil];
    for(int i = 0; i<arrtitle.count; i++)
    {
        
        UIButton *btitem = [[UIButton alloc] initWithFrame:CGRectMake(viewbottom.width/3.0*i, 0, viewbottom.width/3.0-1, viewbottom.height)];
        [btitem setTitle:arrtitle[i] forState:UIControlStateNormal];
        [btitem setTitleColor:RGB(60, 60, 60) forState:UIControlStateNormal];
        [btitem.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btitem setTag:i];
        [viewbottom addSubview:btitem];
        [btitem addTarget:self action:@selector(bottomItemAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i<arrtitle.count-1)
        {
            UIView *viewlne = [[UIView alloc] initWithFrame:CGRectMake(btitem.right, 10, 1, viewbottom.height-20)];
            [viewlne setBackgroundColor:RGB(182, 182, 182)];
            [viewbottom addSubview:viewlne];
        }
        
    }
    [viewbottom setHeight:90];
}




-(void)drawbiaoqing
{
    viewbiaoqing = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 40)];
    [viewbiaoqing setBackgroundColor:RGB(245, 245, 245)];
    [viewbiaoqing setHidden:YES];
    [self addSubview:viewbiaoqing];
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewbiaoqing.width, 1)];
    [viewline setBackgroundColor:RGB(218, 218, 218)];
    [viewbiaoqing addSubview:viewline];
    
    UIButton *btbiaoqing = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, viewbiaoqing.height)];///compose_emoticonbutton_background compose_keyboardbutton_background
    
    [btbiaoqing setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    [btbiaoqing addTarget:self action:@selector(biaoqingAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewbiaoqing addSubview:btbiaoqing];
    
    
    
}



////分类
-(void)drawfenlei
{
    typeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 100)];
    [self addSubview:typeView];
    [typeView setHidden:YES];
    [typeView setBackgroundColor:RGB(243, 243, 243)];
    typeView.layer.shadowColor = [UIColor blackColor].CGColor;
    typeView.layer.shadowOpacity = 0.8f;
    typeView.layer.shadowOffset = CGSizeMake(0,0);
    
    UILabel *lbtext = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
    [lbtext setText:@"添加分类"];
    [lbtext setTextColor:RGB(50, 50, 50)];
    [lbtext setTextAlignment:NSTextAlignmentLeft];
    [lbtext setFont:[UIFont systemFontOfSize:14]];
    [typeView addSubview:lbtext];
    
    UIButton *btdel = [[UIButton alloc] initWithFrame:CGRectMake(typeView.width-40, 0, 40, 40)];
    [btdel setImage:[UIImage imageNamed:@"pushyaunchuang_delfenlei"] forState:UIControlStateNormal];
    [btdel addTarget:self action:@selector(deltypeAction) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:btdel];
    
    
    [self topicClassifys];
    _arrbtType = [NSMutableArray new];
    NSInteger iline = _topicClassifys.count/4;
    if(_topicClassifys.count%4!=0)
    {
        iline+=1;
    }
    UIButton *bttempitem;
    for(int i = 0 ; i<iline;i++)
    {
        for(int j = 0 ; j <4; j++)
        {
            if(j+i*4>=_topicClassifys.count)break;
            
            UIButton *bttype = [[UIButton alloc] initWithFrame:CGRectMake(BOUNDS_WIDTH*0.25*j, 50+40*i, BOUNDS_WIDTH*0.25, 30)];
            [typeView addSubview:bttype];
            [bttype setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
            [bttype setTitle:[_topicClassifys[j+i*4] objectForKey:kTopicItemName] forState:UIControlStateNormal];
            [bttype setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
            [bttype.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [bttype setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [bttype setTag:j+i*4];
            [bttype addTarget:self action:@selector(typeSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            bttempitem = bttype;
            [_arrbtType addObject:bttype];
        }
    }
    [typeView setHeight:bttempitem.bottom+70];
    
}


///底部按钮点击
-(void)bottomItemAction:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        ///展示不同的选项
        TKECamOrPhotosView *tview = [[TKECamOrPhotosView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight)];
        [tview setDelegate:self];
        [self addSubview:tview];
    }
    else if (sender.tag == 1)
    {
        ///添加链接
        pview = [[PushYuanChuangLineAlterView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 190)];
        [pview setBackgroundColor:RGB(245, 245, 245)];
        [pview setDelegate:self];
        [self addSubview:pview];
        [pview showView:self.height];
    }
    else if (sender.tag == 2)
    {
        ///设置分类
        [typeView setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [typeView setBottom:self.height+50];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}


#pragma mark -///图片视频样式
-(UIView *)drawImageItemView:(CGRect)rect andPusnYuanChuangItemModel:(PusnYuanChuangItemModel *)model
{
    UIView *viewback = [[UIView alloc] initWithFrame:rect];
    [viewback setBackgroundColor:RGB(255, 255, 255)];
    
    UIImageView *imgvpic = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imgvpic setTag:100];
    [viewback addSubview:imgvpic];
    
    
    UIButton *btdel = [[UIButton alloc] initWithFrame:CGRectMake(viewback.width-40, 0, 40, 40)];
    [btdel setImage:[UIImage imageNamed:@"pushyaunchuang_delimage"] forState:UIControlStateNormal];
    [btdel setTag:2];
    [btdel addTarget:self action:@selector(delImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewback addSubview:btdel];
    
    
    PushYuanChuangTextView *textview = [[PushYuanChuangTextView alloc] initWithFrame:CGRectZero];
    [textview setTextColor:RGB(60, 60, 60)];
    [textview setTextAlignment:NSTextAlignmentLeft];
    [textview setPlaceholderText:@" 空白处可以输入文字描述哦....."];
    [textview setFont:[UIFont systemFontOfSize:13]];
    [textview setDelegate:self];
    [textview setTag:103];
    [textview setScrollEnabled:NO];
    [textview setBackgroundColor:RGB(255, 255, 255)];
    [viewback addSubview:textview];
    
    
    UIButton *btvideo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50*kScale, 50*kScale)];
    [btvideo setHidden:YES];
    [btvideo setImage:[UIImage imageNamed:@"pushyaunchuang_video"] forState:UIControlStateNormal];
    [btvideo setTag:4];
    [btvideo addTarget:self action:@selector(videoAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewback addSubview:btvideo];
    
    
    
    if(model.image != nil)
    {
        [imgvpic setImage:model.image];
        [imgvpic setFrame:CGRectMake(0, 0, viewback.width, model.image.size.height*viewback.width/model.image.size.width)];
        
        [btvideo setCenter:imgvpic.center];
        if([model.strtype isEqualToString:@"video"])
        {
            [btvideo setHidden:NO];
        }
        
        [textview setFrame:CGRectMake(10, imgvpic.bottom, viewback.width-20, 40)];
        
    }
    else
    {
        [imgvpic setFrame:CGRectMake(0, 0, viewback.width, 60)];
        PusnYuanChuangItemModel *modeltemp = model;
        UIImageView *imgvtemp = imgvpic;
        
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgvtemp url:modeltemp.strimageurl image:[UIImage imageNamed:@"punot.png"] options:SDWebImageCacheMemoryOnly completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(image!= nil)
            {
                modeltemp.image = image;
                [imgvtemp setImage:image];
                
                
                [imgvtemp setHeight:model.image.size.height*viewback.width/model.image.size.width];
                [textview setTop:imgvtemp.bottom];
                
                float ftextheight = [MDB_UserDefault countTextSize:CGSizeMake(textview.width-10, 1000) andtextfont:[UIFont systemFontOfSize:13] andtext:[NSString nullToString:model.strcontent]].height+20;
                
                if(ftextheight<40)
                {
                    ftextheight = 40;
                }
                [textview setHeight:ftextheight];
                
                [viewback setHeight:textview.bottom];
                
                [btvideo setCenter:CGPointMake(viewback.width/2.0, (model.image.size.height*viewback.width/model.image.size.width)/2.0)];
                if([model.strtype isEqualToString:@"video"])
                {
                    [btvideo setHidden:NO];
                }
                
                
                [self setcellOrg];
            }
            
            
//            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
//
//            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                [self geturlImageCellOrg:imgvtemp];
//
//            });
            
        }];
        
        [textview setFrame:CGRectMake(10, imgvpic.bottom, viewback.width-20, 40)];
        
    }
    [textview setText:model.strcontent];
//    float ftextheight = [MDB_UserDefault getStrhightFont:[UIFont systemFontOfSize:13] str:[NSString nullToString:model.strcontent] wight:textview.width].height+20;
    float ftextheight = [MDB_UserDefault countTextSize:CGSizeMake(textview.width-10, 1000) andtextfont:[UIFont systemFontOfSize:13] andtext:[NSString nullToString:model.strcontent]].height+20;
    if(ftextheight<40)
    {
        ftextheight = 40;
    }
    [textview setHeight:ftextheight];
    
    
    [viewback setHeight:textview.bottom];
    return viewback;
}
#pragma mark -///绘制添加链接
-(UIView *)drawlineView:(CGRect)rect andmodel:(PusnYuanChuangItemModel *)model
{
    UIView *viewback = [[UIView alloc] initWithFrame:rect];
    [viewback.layer setBorderColor:RGB(233, 232, 233).CGColor];
    [viewback.layer setBorderWidth:1];
    
    
    if([model.strtype isEqualToString:@"goodscard"])
    { ///表示作为卡片插入
        UIImageView *imgvpic = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, viewback.height, viewback.height-20)];
        [imgvpic setContentMode:UIViewContentModeScaleAspectFit];
        [[MDB_UserDefault defaultInstance] setViewWithImage:imgvpic url:model.strimageurl];
        [viewback addSubview:imgvpic];
        
        
        UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(imgvpic.right+10, 10, viewback.width-imgvpic.right-10-50, 35)];
        [lbtitle setText:model.strtitle];
        [lbtitle setTextColor:RGB(60, 60, 60)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setNumberOfLines:2];
        [lbtitle setFont:[UIFont systemFontOfSize:13]];
        [viewback addSubview:lbtitle];
        
        
//        UILabel *lbprice = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbtitle.bottom, 100, 20)];
//        if(model.strprice.floatValue>0)
//        {
//            [lbprice setText:[NSString stringWithFormat:@"￥%@",model.strprice]];
//        }
//        [lbprice setTextColor:RGB(255, 60, 60)];
//        [lbprice setTextAlignment:NSTextAlignmentLeft];
//        [lbprice setFont:[UIFont systemFontOfSize:13]];
//        [viewback addSubview:lbprice];
//
//        UILabel *lbshop = [[UILabel alloc] initWithFrame:CGRectMake(lbtitle.left, lbprice.bottom, 100, 20)];
//        [lbshop setText:model.strsitename];
//        [lbshop setTextColor:RGB(160, 160, 160)];
//        [lbshop setTextAlignment:NSTextAlignmentLeft];
//        [lbshop setFont:[UIFont systemFontOfSize:12]];
//        [viewback addSubview:lbshop];
        
        
        UIButton *btzhida = [[UIButton alloc] initWithFrame:CGRectMake(lbtitle.left, lbtitle.bottom+10, 70, 30)];
        [btzhida setTitle:@"直达链接" forState:UIControlStateNormal];
        [btzhida setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btzhida.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btzhida.layer setCornerRadius:2];
        [btzhida.layer setMasksToBounds:YES];
        [btzhida setCenterY:viewback.height/2.0+10];
        [btzhida setBackgroundColor:RadMenuColor];
        [viewback addSubview:btzhida];
    }
    else
    {///普通超链接
        
        UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewback.width-50, 35)];
        [lbtitle setText:model.strtitle];
        [lbtitle setTextColor:RGB(0, 94, 212)];
        [lbtitle setTextAlignment:NSTextAlignmentLeft];
        [lbtitle setNumberOfLines:2];
        [lbtitle setFont:[UIFont systemFontOfSize:13]];
        [viewback addSubview:lbtitle];
        [lbtitle sizeToFit];
        if(lbtitle.height<35)
        {
            lbtitle.height = 35;
        }
        
        [viewback setHeight:lbtitle.bottom+10];
        [lbtitle setUserInteractionEnabled:YES];
        ///添加点击
        
    }
    
    UIButton *btdel = [[UIButton alloc] initWithFrame:CGRectMake(viewback.width-40, 0, 40, 40)];
    [btdel setImage:[UIImage imageNamed:@"pushyaunchuang_delimage"] forState:UIControlStateNormal];
    [btdel setTag:2];
    [btdel addTarget:self action:@selector(delImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewback addSubview:btdel];
    
    
    
    
    
    return viewback;
}


///得到网络图片后调整cell的位置和高度
-(void)geturlImageCellOrg:(UIImageView *)imgv
{
    if(imgv == nil)return;
    @try
    {
        NSInteger itag = imgv.superview.tag;
        if(arrcellview.count-1<itag)return;
        PusnYuanChuangItemModel *model = arrAllList[itag];
        
        if(model.image==nil)return;
        
        UIView *view = arrcellview[itag];
        
        UIImageView *imgvtemp = [view viewWithTag:100];
        
        [imgvtemp setHeight:model.image.size.height*view.width/model.image.size.width];
        
        UIView *viewtext = [view viewWithTag:103];
        [viewtext setTop:imgvtemp.bottom];
        
        float ftextheight = [MDB_UserDefault countTextSize:CGSizeMake(viewtext.width-10, 1000) andtextfont:[UIFont systemFontOfSize:13] andtext:[NSString nullToString:model.strcontent]].height+20;
        
        if(ftextheight<40)
        {
            ftextheight = 40;
        }
        [viewtext setHeight:ftextheight];
        
        [view setHeight:viewtext.bottom];
        
        UIButton *btvideo = [view viewWithTag:4];
        [btvideo setCenter:CGPointMake(view.width/2.0, (model.image.size.height*view.width/model.image.size.width)/2.0)];
        if([model.strtype isEqualToString:@"video"])
        {
            [btvideo setHidden:NO];
        }
        
        
        [self setcellOrg];
    }
    @catch (NSException *exc)
    {
        
    }
    @finally
    {
        
    }
    
}


#pragma mark - 播放视频
-(void)videoAction:(UIButton *)sender
{
    NSInteger itag = sender.superview.tag;
    PusnYuanChuangItemModel *model = arrAllList[itag];
    
    PGGMoviePlayer *pplayer = [[PGGMoviePlayer alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH, BOUNDS_HEIGHT)];
    [pplayer setBackgroundColor:[UIColor grayColor]];
    [self.viewController.view.window addSubview:pplayer];
    NSString *strurl = model.strvideourl;
    [pplayer playUrl:[MDB_UserDefault getCompleteWebsite:strurl]];
    pplayer.playerViewOriginalRect = pplayer.frame;
    pplayer.playerSuperView = self.viewController.view.window;
    pplayer.playerpoint = pplayer.center;
    pplayer.strtitle = @"";
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
}

#pragma mark - 删除图片
-(void)delImageAction:(UIButton *)sender
{
    NSInteger itag = sender.superview.tag;
//    PusnYuanChuangItemModel *model = arrAllList[itag];
    UIView *view = arrcellview[itag];
    [arrAllList removeObjectAtIndex:itag];
    [arrcellview removeObjectAtIndex:itag];
    [view removeFromSuperview];
    
    [self setcellOrg];
    isvaluechange = YES;
    
}

#pragma mark - 表情按钮点击
-(void)biaoqingAction:(UIButton *)sender
{
    if (textnow.inputView) {
        textnow.inputView = nil;
        [textnow reloadInputViews];
        [textnow becomeFirstResponder];
        
        [sender setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    } else {
        RemarkEmoticonInputView *v = [RemarkEmoticonInputView sharedInstance];
        v.delegate = self;
        textnow.inputView = v;
        [textnow reloadInputViews];
        [textnow becomeFirstResponder];
        [sender setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 类别选择
-(void)typeSelectAction:(UIButton *)sender
{
    if(_btnowSelectType != nil)
    {
        [_btnowSelectType setImage:[UIImage imageNamed:@"yuan_select_no"] forState:UIControlStateNormal];
    }
    _btnowSelectType = sender;
    [_btnowSelectType setImage:[UIImage imageNamed:@"yuan_select_yes"] forState:UIControlStateNormal];
    
    _type = [[_topicClassifys[sender.tag]  objectForKey:kTopicItemType] integerValue];
    isvaluechange = YES;
}

#pragma mark - 类别消失
-(void)deltypeAction
{
    [typeView setHidden:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [typeView setTop:self.height];
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark -
static NSInteger const maxPictureNumber = 15;
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
        
        int itemonu = 0;
        int ivideonu = 0;
        for(PusnYuanChuangItemModel *model in arrAllList)
        {
            if([model.strtype isEqualToString:@"image"])
            {
                itemonu++;
            }
            else if ([model.strtype isEqualToString:@"video"])
            {
                ivideonu++;
            }
        }
        if(itemonu>=15&&ivideonu>=2)
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"图片和视频达到上限" inView:self.window];
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
        
        int itemonu = 0;
        for(PusnYuanChuangItemModel *model in arrAllList)
        {
            if([model.strtype isEqualToString:@"image"])
            {
                itemonu++;
            }
        }
        
        ////这里的数量需要重新计算 图片的数量
        NSInteger inowcount = maxPictureNumber - itemonu;
        
        if (inowcount <= 0) {
            return;
        }
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:inowcount columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
        imagePickerVc.isSelectOriginalPhoto = NO;
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
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            ////上传图片
            [self.dataControl requestUploadImageToken:photos.count targetView:self.window callback:^(NSError *error, BOOL state, NSString *describle) {

                if(state)
                {
                    
                    [GMDCircleLoader setOnView:self.window withTitle:nil animated:YES];
                    NSMutableArray *arrtempimages = [NSMutableArray new];
                    for(UIImage *imagetemp in photos)
                    {
                        [arrtempimages addObject:[self imgcutsuo:imagetemp andsize:imagetemp.size]];
                    }
                    [[TKQiniuHelper currentHelper] uploadImageToQNWithTokens:self.dataControl.dicImageToken
                                                                      images:arrtempimages
                                                                    callback:^(BOOL state, NSArray *urls) {
                                                                        
                                                                        [GMDCircleLoader hideFromView:self.window animated:YES];
                                                                        
                                                                        if (state)
                                                                        {
                                                                            ////
                                                                            int i = 0;
                                                                            for(UIImage *image in arrtempimages)
                                                                            {
                                                                                PusnYuanChuangItemModel *model  = [PusnYuanChuangItemModel new];
                                                                                model.image = image;
                                                                                model.strimageurl = urls[i];
                                                                                model.strtype = @"image";
                                                                                [arrAllList addObject:model];
                                                                                i++;
                                                                                
                                                                                UIView *viewitem = [self drawImageItemView:CGRectMake(10, viewheader.bottom+[self fitemheight], viewheader.width-20, 100) andPusnYuanChuangItemModel:model];
                                                                                [viewitem setTag:arrcellview.count];
                                                                                [scvItemView addSubview:viewitem];
                                                                                [arrcellview addObject:viewitem];
                                                                                
                                                                            }
                                                                            
                                                                            [self setscrollviewContentSize];
                                                                            isvaluechange = YES;
                                                                            
                                                                            [self scrollToBottom];
                                                                        }
                                                                        else
                                                                        {
                                                                            [MDB_UserDefault showNotifyHUDwithtext:@"图片上传失败" inView:self];
                                                                        }
                                                                    }];
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:@"图片上传失败" inView:self];
                }
            }];
            
        }];
        [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)selectNomoImageItem
{
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
    
    int itemonu = 0;
    for(PusnYuanChuangItemModel *model in arrAllList)
    {
        if([model.strtype isEqualToString:@"image"])
        {
            itemonu++;
        }
    }
    
    ////这里的数量需要重新计算 图片的数量
    NSInteger inowcount = maxPictureNumber - itemonu;
    
    if (inowcount <= 0) {
        return;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:inowcount columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
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
    [imagePickerVc setPickerDelegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        
        
        if(photos.count<1)
        {
            [self.delegate selectNomoImageNO];
        }
        else
        {
            //上传图片
            [self.dataControl requestUploadImageToken:photos.count targetView:self.window callback:^(NSError *error, BOOL state, NSString *describle) {

                if(state)
                {
                    
                    [GMDCircleLoader setOnView:self.window withTitle:nil animated:YES];
                    NSMutableArray *arrtempimages = [NSMutableArray new];
                    for(UIImage *imagetemp in photos)
                    {
                        [arrtempimages addObject:[self imgcutsuo:imagetemp andsize:imagetemp.size]];
                    }
                    
                    
                    [[TKQiniuHelper currentHelper] uploadImageToQNWithTokens:self.dataControl.dicImageToken
                                                                      images:arrtempimages
                                                                    callback:^(BOOL state, NSArray *urls) {
                                                                        
                                                                        [GMDCircleLoader hideFromView:self.window animated:YES];
                                                                        
                                                                        if (state)
                                                                        {
                                                                            ////
                                                                            int i = 0;
                                                                            for(UIImage *image in arrtempimages)
                                                                            {
                                                                                PusnYuanChuangItemModel *model  = [PusnYuanChuangItemModel new];
                                                                                model.image = image;
                                                                                model.strimageurl = urls[i];
                                                                                model.strtype = @"image";
                                                                                [arrAllList addObject:model];
                                                                                i++;
                                                                                
                                                                                UIView *viewitem = [self drawImageItemView:CGRectMake(10, viewheader.bottom+[self fitemheight], viewheader.width-20, 100) andPusnYuanChuangItemModel:model];
                                                                                [viewitem setTag:arrcellview.count];
                                                                                [scvItemView addSubview:viewitem];
                                                                                [arrcellview addObject:viewitem];
                                                                                
                                                                            }
                                                                            
                                                                            [self setscrollviewContentSize];
                                                                            isvaluechange = YES;
                                                                        }
                                                                        else
                                                                        {
                                                                            [MDB_UserDefault showNotifyHUDwithtext:@"图片上传失败" inView:self];
                                                                        }
                                                                    }];
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:@"图片上传失败" inView:self];
                }
            }];
        }
        
    }];
    [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
    [self.delegate selectNomoImageNO];
}

///设置滚动范围
-(void)setscrollviewContentSize
{
    float ftemp = [self fitemheight]+viewheader.bottom;
    if(ftemp<scvItemView.height+1)
    {
        ftemp = scvItemView.height+1;
    }
    [scvItemView setContentSize:CGSizeMake(0, ftemp)];
}

///重新整理cell的位置
-(void)setcellOrg
{
    float ftemp = viewheader.bottom;
    int i = 0;
    for(UIView *view in arrcellview)
    {
        [view setTag:i];
        [view setTop:ftemp];
        ftemp = view.bottom+10;
        i++;
    }
    if(ftemp<=scvItemView.height)
    {
        ftemp = scvItemView.height+1;
    }
    [scvItemView setContentSize:CGSizeMake(0, ftemp)];
}

-(float)fitemheight
{
    float ftemp = 0.0;
    for(UIView *view in arrcellview)
    {
        ftemp+=view.height+10;
    }
    
    return ftemp;
}

#pragma mark -///添加链接
-(void)addLineUrlValue:(NSString *)strurl
{
    if(strurl==nil || strurl.length<5)
    {
        
        return;
    }
    ///数据请求
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:strurl forKey:@"url"];
    [self.dataControl requestOriginalDetailWithID:dicpush targetView:self callback:^(NSError *error, BOOL state, NSString *describle) {
       
        if(state)
        {
            PusnYuanChuangItemModel *model = [PusnYuanChuangItemModel viewmodellinedata:self.dataControl.diclinkValue];
            
            UIView *view = [self drawlineView:CGRectMake(10, viewheader.bottom+[self fitemheight]+10, scvItemView.width-20, 100) andmodel:model];
            [view setTag:arrcellview.count];
            [scvItemView addSubview:view];
            
            
            [arrcellview addObject:view];
            [arrAllList addObject:model];
            
            
            [self setcellOrg];
            isvaluechange = YES;
            
            [self scrollToBottom];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:[NSString nullToString:describle] inView:self];
        }
        
    }];
    
}

///获取消息的爆料卡片
-(void)getMessageBaoLiao:(NSArray *)arrbaoliao
{
    for(NSString *str in arrbaoliao)
    {
        [self addLineUrlValue:str];
    }
    
}

#pragma mark  WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [textnow replaceRange:textnow.selectedTextRange withText:text];
    }
}

- (void)emoticonInputDidTapBackspace {
    [textnow deleteBackward];
}

#pragma mark - PGGCameraViewControllerDelegate
- (void)cameraMovieBack:(NSURL *)movieurl
{
    int ivideonu = 0;
    for(PusnYuanChuangItemModel *model in arrAllList)
    {
        if ([model.strtype isEqualToString:@"video"])
        {
            ivideonu++;
        }
    }
    if(ivideonu>=2)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"视频达到上限" inView:self.window];
        return;
    }
    
    ////上传视频
    [self.dataControl requestUploadMovieToken:@"mp4" targetView:self.window callback:^(NSError *error, BOOL state, NSString *describle) {
       
        if(state)
        {
            [GMDCircleLoader setOnView:self.window withTitle:nil animated:YES];
            NSData *datatemp = [NSData dataWithContentsOfURL:movieurl];
            NSArray *arrimage = [NSArray arrayWithObjects:datatemp, nil];
            [[TKQiniuHelper currentHelper] uploadDataWithTokens:self.dataControl.dicMovieToken images:arrimage callback:^(BOOL state, NSArray *urls , NSArray *picurls) {
                
                
                [GMDCircleLoader hideFromView:self.window animated:YES];
                
                if(state)
                {
                    ////
                    UIImage *image = [[MDB_UserDefault defaultInstance] getVideoPreViewImage: [NSURL URLWithString:[MDB_UserDefault getCompleteWebsite:movieurl.absoluteString]]];
                    
                    
                    PusnYuanChuangItemModel *model  = [PusnYuanChuangItemModel new];
                    model.image = image;
                    model.strimageurl = picurls[0];
                    model.strtype = @"video";
                    model.strvideourl = urls[0];
                    model.isvideo = YES;
                    [arrAllList addObject:model];
                    
                    
                    UIView *viewitem = [self drawImageItemView:CGRectMake(10, viewheader.bottom+[self fitemheight], viewheader.width-20, 100) andPusnYuanChuangItemModel:model];
                    [viewitem setTag:arrcellview.count];
                    [scvItemView addSubview:viewitem];
                    [arrcellview addObject:viewitem];
                    
                    [self setscrollviewContentSize];
                    isvaluechange = YES;
                    [self scrollToBottom];
                }
                else
                {
                    [MDB_UserDefault showNotifyHUDwithtext:@"视频上传失败" inView:self];
                }
            }];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"视频上传失败" inView:self];
        }
        
    }];
    
}
- (void)cameraPhotoBack:(UIImage *)image
{
    int itemonu = 0;
    for(PusnYuanChuangItemModel *model in arrAllList)
    {
        if([model.strtype isEqualToString:@"image"])
        {
            itemonu++;
        }
    
    }
    if(itemonu>=15)
    {
        [MDB_UserDefault showNotifyHUDwithtext:@"图片达到上限" inView:self.window];
        return;
    }
    NSLog(@"1=%lu",UIImageJPEGRepresentation(image, 1).length);
    image = [self imgcutsuo:image andsize:image.size];
    NSLog(@"2=%lu",UIImageJPEGRepresentation(image, 1).length);
    
    
    ////上传图片
    [self.dataControl requestUploadImageToken:1 targetView:self.window callback:^(NSError *error, BOOL state, NSString *describle) {
       
        if(state)
        {
            [GMDCircleLoader setOnView:self.window withTitle:nil animated:YES];
            NSMutableArray *arrtempimages = [NSMutableArray arrayWithObjects:image, nil];
            [[TKQiniuHelper currentHelper] uploadImageToQNWithTokens:self.dataControl.dicImageToken
                                                              images:arrtempimages
                                                            callback:^(BOOL state, NSArray *urls) {
                                                                
                                                                [GMDCircleLoader hideFromView:self.window animated:YES];
                                                                
                                                                if (state)
                                                                {
                                                                    ////
                                                                    
                                                                    PusnYuanChuangItemModel *model  = [PusnYuanChuangItemModel new];
                                                                    model.image = image;
                                                                    model.strimageurl = urls[0];
                                                                    model.strtype = @"image";
                                                                    [arrAllList addObject:model];
                                                                    
                                                                    
                                                                    UIView *viewitem = [self drawImageItemView:CGRectMake(10, viewheader.bottom+[self fitemheight], viewheader.width-20, 100) andPusnYuanChuangItemModel:model];
                                                                    [viewitem setTag:arrcellview.count];
                                                                    [scvItemView addSubview:viewitem];
                                                                    [arrcellview addObject:viewitem];
                                                                    
                                                                    [self setscrollviewContentSize];
                                                                    isvaluechange = YES;
                                                                    
                                                                    [self scrollToBottom];
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    [MDB_UserDefault showNotifyHUDwithtext:@"图片上传失败" inView:self];
                                                                }
                                                            }];
        }
        else
        {
            [MDB_UserDefault showNotifyHUDwithtext:@"图片上传失败" inView:self];
        }
    }];
    
    
    
}

-(void)scrollToBottom
{
    CGPoint bottomOffset = CGPointMake(0, scvItemView.contentSize.height - scvItemView.bounds.size.height);
    [scvItemView setContentOffset:bottomOffset animated:YES];
    
}



-(void)keyboarddismis
{
    [textnow resignFirstResponder];
    [fieldtitle resignFirstResponder];
    [textviewhd resignFirstResponder];
    if(typeView.bottom == self.height)
    {
        [typeView setHidden:YES];
        [UIView animateWithDuration:0.5 animations:^{
            [typeView setTop:typeView.superview.bottom];
            
        } completion:^(BOOL finished) {
            
            
        }];
    }
    [pview hiddenView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self keyboarddismis];
    
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textnow = nil;
    return YES;
}
#pragma mark - YYTextViewDelegate
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView
{
    textnow = (PushYuanChuangTextView *)textView;
    return YES;
}
//isKeybodDidShow = NO;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(isKeybodDidShow==NO)
    {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.tag!= 100)
    {
        NSInteger itag = textView.superview.tag;
        PusnYuanChuangItemModel *model = arrAllList[itag];
        UIView *view = arrcellview[itag];
        model.strcontent = textView.text;
//        float ftextheight = [MDB_UserDefault getStrhightFont:[UIFont systemFontOfSize:13] str:[NSString nullToString:model.strcontent] wight:scvItemView.width-20].height+5;
        float ftextheight = [MDB_UserDefault countTextSize:CGSizeMake(textView.width-10, 1000) andtextfont:[UIFont systemFontOfSize:13] andtext:[NSString nullToString:model.strcontent]].height+20;
        if(ftextheight<40)
        {
            ftextheight = 40;
        }
        
        
        PushYuanChuangTextView *viewtext = [view viewWithTag:103];
        
        [viewtext setHeight:ftextheight];
        
        
        [view setHeight:viewtext.bottom];
        
        
        [self setcellOrg];
        float fsize = viewheader.bottom+[self fitemheight];
        
//        NSLog(@"%lf+++%lf",fsize,flastscroll);
        
        if([self fitemheight]+viewheader.bottom>self.height-fkeyboardheight-40)
        {
            [scvItemView setContentOffset:CGPointMake(scvItemView.contentOffset.x, flastscrollcontentofsety+fsize-flastscroll) animated:NO];
        }
    }
    else
    {///头部的描述
        
        float ftextheight = [MDB_UserDefault countTextSize:CGSizeMake(textviewhd.width, 1000) andtextfont:[UIFont systemFontOfSize:15] andtext:textviewhd.text].height+10;
        if(ftextheight<90)
        {
            ftextheight = 90;
        }
        
        [textviewhd setHeight:ftextheight];
        [viewheader setHeight:textviewhd.bottom];
        
        ///调整其他的位置
        [self setcellOrg];
        
    }
    
    
}


#pragma mark - 键盘监听
- (void)keyboardWasShown:(NSNotification*)aNotification

{
    //键盘高度
    isKeybodDidShow = NO;
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if(textnow!=nil)
    {
        float ftopheith =  kStatusBarHeight+44;
        float fother = 34.0;
        if(ftopheith<66)
        {
            ftopheith = 64;
            fother = 0;
        }
        [viewbiaoqing setBottom:self.height - keyBoardFrame.size.height+fother];
    }
    else
    {
        [viewbiaoqing setTop:self.height];
    }
    [viewbiaoqing setHidden:NO];
    
    if(pview!=nil)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [pview setBottom:self.height-keyBoardFrame.size.height];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    
}

-(void)keyboardWasDidShown:(NSNotification*)aNotification
{
    isKeybodDidShow = YES;
    isvaluechange = YES;
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    fkeyboardheight = keyBoardFrame.size.height;
    if([self fitemheight]+viewheader.bottom>self.height-keyBoardFrame.size.height-40)
    {
        
//        if(textnow!=nil && textnow.tag !=100)
        if(textnow!=nil)
        {
//            if (textnow.inputView)
//            {
                [scvItemView setContentOffset:CGPointMake(scvItemView.contentOffset.x, scvItemView.contentOffset.y+50) animated:NO];
                flastscroll = viewheader.bottom+[self fitemheight];
                flastscrollcontentofsety = scvItemView.contentOffset.y+50;
//            }
//            else
//            {
//                [scvItemView setContentOffset:CGPointMake(scvItemView.contentOffset.x, scvItemView.contentOffset.y+60) animated:YES];
//                flastscroll = viewheader.bottom+[self fitemheight];
//                flastscrollcontentofsety = scvItemView.contentOffset.y+60;
//            }
        }
        
        
    }
    
    
}


-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    [viewbiaoqing setTop:self.height];
    [viewbiaoqing setHidden:YES];
}


- (NSMutableArray *)topicClassifys{
    if (!_topicClassifys) {
        _topicClassifys = @[
                            @{kTopicItemName:@"生活经验",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_enable"],
                              kTopicItemType:@(TKTopicTypeEnable)
                              },
                            @{kTopicItemName:@"服饰鞋包",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_looks"],
                              kTopicItemType:@(TKTopicTypeLooks)
                              },
                            @{kTopicItemName:@"美妆护肤",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_meizhuanghufu"],
                              kTopicItemType:@(TKTopicTypeBeauty)
                              },
                            @{kTopicItemName:@"数码家电",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_3Cshuma"],
                              kTopicItemType:@(TKTopicType3C)
                              },
                            @{kTopicItemName:@"美食旅游",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_meishilvyou"],
                              kTopicItemType:@(TKTopicTypeDeliciousfood)
                              },
                            @{kTopicItemName:@"评测试用",
                              kTopicItemIcon:[UIImage imageNamed:@"topic_evaluation"],
                              kTopicItemType:@(TKTopicTypeEvaluation)
                              },
//                            @{kTopicItemName:@"匿名吐槽",
//                              kTopicItemIcon:[UIImage imageNamed:@"topic_spitslot"],
//                              kTopicItemType:@(TKTopicTypeSpitslot)
//                              },
                            //                            @{kTopicItemName:@"日常话题",
                            //                              kTopicItemIcon:[UIImage imageNamed:@"topic_daily"],
                            //                              kTopicItemType:@(TKTopicTypeDaily)
                            //                              },
                            @{kTopicItemName:@"其他",
                              kTopicItemIcon:[UIImage imageNamed:@"yuanchuang_other"],
                              kTopicItemType:@(TKTopicTypeOther)
                              }];
    }
    return _topicClassifys;
}


#pragma mark - 保存草稿
-(void)saveCaoGao
{
 
    if(fieldtitle.text.length==0 && textviewhd.text.length == 0 && arrAllList.count == 0)
    {
        return;
    }
    if(isvaluechange==NO)
    {
        return;
    }
    
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:fieldtitle.text] forKey:@"title"];
    if(_type!=0)
    {
        [dicpush setObject:[NSString stringWithFormat:@"%@",@(_type)] forKey:@"classify"];
    }
    [dicpush setObject:[NSString nullToString:textviewhd.text] forKey:@"content"];
    [dicpush setObject:[NSString nullToString:_strdraft_id] forKey:@"draft_id"];
    [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
    
    
    
    NSMutableArray *arrcontentarr = [NSMutableArray new];
    for(PusnYuanChuangItemModel *model in arrAllList)
    {
        if([model.strtype isEqualToString:@"image"])
        {
            NSMutableDictionary *dicmodel = [NSMutableDictionary new];
            [dicmodel setObject:[NSString nullToString:@"image"] forKey:@"type"];
            [dicmodel setObject:model.strimageurl forKey:@"imageurl"];
            [dicmodel setObject:[NSString nullToString:model.strcontent] forKey:@"remark"];
            [arrcontentarr addObject:dicmodel];
            
        }
        else if([model.strtype isEqualToString:@"video"])
        {
            
            NSMutableDictionary *dicmodel = [NSMutableDictionary new];
            [dicmodel setObject:[NSString nullToString:@"video"] forKey:@"type"];
            [dicmodel setObject:model.strimageurl forKey:@"imageurl"];
            [dicmodel setObject:[NSString nullToString:model.strcontent] forKey:@"remark"];
            [dicmodel setObject:model.strvideourl forKey:@"videourl"];
            [arrcontentarr addObject:dicmodel];
            
        }
        else if([model.strtype isEqualToString:@"goodscard"])
        {
            
            NSMutableDictionary *dicmodel = [NSMutableDictionary new];
            [dicmodel setObject:[NSString nullToString:@"goodscard"] forKey:@"type"];
            [dicmodel setObject:model.strimageurl forKey:@"imageurl"];
            [dicmodel setObject:[NSString nullToString:model.strcontent] forKey:@"remark"];
            [dicmodel setObject:model.strtitle forKey:@"title"];
            [dicmodel setObject:model.strlineurl forKey:@"linkurl"];
            [dicmodel setObject:model.strprice forKey:@"price"];
            [dicmodel setObject:model.strsitename forKey:@"sitename"];
            [arrcontentarr addObject:dicmodel];
            
        }
        else if([model.strtype isEqualToString:@"link"])
        {
            
            NSMutableDictionary *dicmodel = [NSMutableDictionary new];
            [dicmodel setObject:[NSString nullToString:@"link"] forKey:@"type"];
            [dicmodel setObject:model.strtitle forKey:@"title"];
            [dicmodel setObject:model.strlineurl forKey:@"linkurl"];
            [arrcontentarr addObject:dicmodel];
            
        }
        
    }
    
    NSString *strarritem = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrcontentarr options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
    
    [dicpush setObject:strarritem forKey:@"contentarr"];
    
    
    [self.dataControl requestUploadCaoGaoValue:dicpush targetView:nil callback:^(NSError *error, BOOL state, NSString *describle) {
        if(state)
        {
            if(_strdraft_id==nil || [_strdraft_id isEqualToString:@""])
            {
                _strdraft_id = [NSString nullToString:[self.dataControl.dicCaoGaoValue objectForKey:@"draft_id"]];
            }
            NSLog(@"保存成功");
            isvaluechange = NO;
        }
        else
        {
            
        }
    }];
    
    
    
}


///对图片进行缩
-(UIImage *)imgcutsuo:(UIImage *)image andsize:(CGSize)size
{
    NSData *datatemp = UIImageJPEGRepresentation(image, 0.5);
    image = [UIImage imageWithData:datatemp];
//    size = CGSizeMake(size.width/2.0, size.height/2.0);
//    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    return image;
}

-(void)timerremove
{
    [timer invalidate];
    timer = nil;
    
}


-(NSInteger)gettype
{
    return _type;
}
-(NSString *)gettitle
{
    return fieldtitle.text;
}
-(NSString *)getcontent
{
    return textviewhd.text;
}
-(NSMutableArray *)getlistmodel
{
    return arrAllList;
}

-(NSTimer *)getcaogaotimer
{
    return timer;
}

-(void)dealloc
{
    [timer invalidate];
    timer = nil;
}

@end
