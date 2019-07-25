//
//  PushYuanChuangSelectFMViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/9/7.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PushYuanChuangSelectFMViewController.h"

#import "PusnYuanChuangItemModel.h"

#import "HTTPManager.h"

#import "MDB_UserDefault.h"

@interface PushYuanChuangSelectFMViewController ()
{
    
    UIImageView *imgvfm;
    
    UIScrollView *scvback;
    
    
    UIImageView *imgvnowselect;
    
    NSMutableArray *arrimage;
    
}
@end

@implementation PushYuanChuangSelectFMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择封面";
    
    [self drawUI];
    
}


-(void)drawUI
{
    float ftopheith =  kStatusBarHeight+44;
    float fother = 34.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    scvback = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopHeight, BOUNDS_WIDTH, BOUNDS_HEIGHT-kTopHeight-60-fother)];
    [self.view addSubview:scvback];
    [self drawmessage];
    
    UIButton *btpush = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120*kScale, 40*kScale)];
    [btpush setTitle:@"发布" forState:UIControlStateNormal];
    [btpush setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btpush.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btpush.layer setCornerRadius:3];
    [btpush.layer setMasksToBounds:YES];
    [btpush setBackgroundColor:RadMenuColor];
    [btpush addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [btpush setCenter:CGPointMake(BOUNDS_WIDTH/2.0, scvback.bottom+20)];
    [self.view addSubview:btpush];
    
}

-(void)drawmessage
{
    UIView *viewback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    [viewback setBackgroundColor:RGB(244, 243, 243)];
    [scvback addSubview:viewback];
    
    imgvfm = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BOUNDS_WIDTH*0.6, BOUNDS_WIDTH*0.6)];
    [imgvfm setContentMode:UIViewContentModeScaleAspectFit];
    [imgvfm setCenter:CGPointMake(BOUNDS_WIDTH/2.0, 0)];
    [imgvfm setTop:20];
    [imgvfm.layer setMasksToBounds:YES];
    [imgvfm.layer setCornerRadius:5];
    [scvback addSubview:imgvfm];
    
    UILabel *lbtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, imgvfm.bottom+10, scvback.width-20, 20)];
    [lbtitle setText:_strtitle];
    [lbtitle setTextColor:RGB(60, 60, 60)];
    [lbtitle setTextAlignment:NSTextAlignmentCenter];
    [lbtitle setFont:[UIFont systemFontOfSize:14]];
    [lbtitle sizeToFit];
    [lbtitle setCenterX:BOUNDS_WIDTH/2.0];
    [scvback addSubview:lbtitle];
    
    
    
    UILabel *lbcount = [[UILabel alloc] initWithFrame:CGRectMake(10,lbtitle.bottom+10, scvback.width-20, 20)];
    [lbcount setTextColor:RGB(160, 160, 160)];
    [lbcount setTextAlignment:NSTextAlignmentCenter];
    [lbcount setFont:[UIFont systemFontOfSize:12]];
    [scvback addSubview:lbcount];
    
    [viewback setHeight:lbcount.bottom+10];
    
    arrimage = [NSMutableArray new];
    for(PusnYuanChuangItemModel *model in _arrlistitem)
    {
        if([model.strtype isEqualToString:@"image"] || [model.strtype isEqualToString:@"video"])
        {
            [arrimage addObject:model];
        }
    }
    
    [lbcount setText:[NSString stringWithFormat:@"（共%ld张图片）",arrimage.count]];
    NSInteger iline = arrimage.count/4;
    if(arrimage.count%4!=0)
    {
        iline+=1;
    }
    
    float fitemw = (scvback.width-70)/4.0;
    
    for(int i = 0 ; i < iline; i++)
    {
        for(int j = 0 ; j < 4; j++)
        {
            if(j+i*4>=arrimage.count)break;
            PusnYuanChuangItemModel *model = arrimage[j+i*4];
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(10+(fitemw+10)*j, lbcount.bottom+20+(fitemw+10)*i, fitemw, fitemw)];
            [imgv setImage:model.image];
            [imgv setContentMode:UIViewContentModeScaleAspectFit];
            [scvback addSubview:imgv];
            [imgv setTag:j+i*4];
            [imgv setUserInteractionEnabled:YES];
            [imgv.layer setBorderColor:[UIColor whiteColor].CGColor];
            [imgv.layer setBorderWidth:1];
            [imgv.layer setMasksToBounds:YES];
            [imgv.layer setCornerRadius:5];
            [scvback setContentSize:CGSizeMake(0, imgv.bottom+20)];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgvAction:)];
            [imgv addGestureRecognizer:tap];
            if(i==0&&j==0)
            {
                imgvnowselect = imgv;
                [imgvnowselect.layer setBorderColor:RadMenuColor.CGColor];
                [imgvfm setImage:imgvnowselect.image];
            }
        }
        
    }
    
}

-(void)imgvAction:(UITapGestureRecognizer *)gesture
{
    
    [imgvnowselect.layer setBorderColor:[UIColor whiteColor].CGColor];
    UIImageView *imgv = (UIImageView *)gesture.view;
    imgvnowselect = imgv;
    [imgvnowselect.layer setBorderColor:RadMenuColor.CGColor];
    [imgvfm setImage:imgvnowselect.image];
}


///发布
-(void)pushAction
{
    @try {
        PusnYuanChuangItemModel *model0 = arrimage[imgvnowselect.tag];
        NSMutableDictionary *dicpush = [NSMutableDictionary new];
        [dicpush setObject:_strtitle forKey:@"title"];
        [dicpush setObject:[NSString stringWithFormat:@"%@",@(_type)] forKey:@"classify"];
        [dicpush setObject:[NSString nullToString:_strcontent] forKey:@"content"];
        [dicpush setObject:model0.strimageurl forKey:@"pic"];
        [dicpush setObject:[NSString nullToString:_strdraft_id] forKey:@"draft_id"];
        [dicpush setObject:_strtitle forKey:@"title"];
        [dicpush setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"];
        
        
        
        NSMutableArray *arrcontentarr = [NSMutableArray new];
        for(PusnYuanChuangItemModel *model in _arrlistitem)
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
        
        
        [HTTPManager sendRequestUrlToService:URL_TopicPost3 withParametersDictionry:dicpush view:self.view.window completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            BOOL state = NO;
            NSString *describle = @"";
            if (responceObjct!=nil){
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                    state = YES;
                    
                }else{
                    describle = dicAll[@"info"];
                }
            }else{
                describle = @"网络错误";
            }
            
            if(state)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"yuanchuangfabugengxin"];
                [_timercaogao invalidate];
                _timercaogao = nil;
                [MDB_UserDefault showNotifyHUDwithtext:@"发布成功！小编审核通过后才能在原创频道查看哦" inView:self.view.window];
                NSArray *arrvcs = self.navigationController.viewControllers;
                if(arrvcs.count>2)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"yuanchuangfabugengxin1"];
                    UIViewController *vc = arrvcs[arrvcs.count-3];
                    [self.navigationController popToViewController:vc animated:YES];
                }
                else
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
                
            }
            else
            {
                [MDB_UserDefault showNotifyHUDwithtext:describle inView:self.view];
            }
            
        } ];
    } @catch (NSException *exception) {
        [MDB_UserDefault showNotifyHUDwithtext:@"数据错误，请返回重新上传" inView:self.view];
    } @finally {
        
    }
    
    
    
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
