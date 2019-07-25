//
//  MallAppraisalViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/4/28.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "MallAppraisalViewController.h"
#import "AppraiseVIew.h"
#import "MallViewController.h"
#import "MDB_UserDefault.h"
#import "FMDBHelper.h"
#import "Marked.h"
#import "Photoscle.h"

@interface MallAppraisalViewController ()<MallAppraisalViewCDelaget,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *MallViewSelect;
@property (weak, nonatomic) IBOutlet UILabel *MallTitle;
@property (weak, nonatomic) IBOutlet AppraiseVIew *OneView;
@property (weak, nonatomic) IBOutlet AppraiseVIew *twoView;
@property (weak, nonatomic) IBOutlet AppraiseVIew *thereView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MallAppraisalViewController{
    NSString *textl;
    NSArray *photoArrl;
    
    NSInteger   sdquality;
    NSInteger   sdship;
    NSInteger   sdcustom;
    
    MallObjct   *_mallobj;
}

-(void)setText:(NSString *)text arr:(NSArray *)photoArr{

    textl=text;
    photoArrl=photoArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"商城评价";
    sdquality=1;
    sdship=1;
    sdcustom=1;
    _scrollView.contentSize=CGSizeMake(self.view.frame.size.width, _scrollView.frame.size.width+1);
    
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    //[btnLeft setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 22.0)];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    
    [_OneView setIntloadWight:22];
    _OneView.tag=301;
    [_twoView setIntloadWight:22];
    _twoView.tag=302;
    [_thereView setIntloadWight:22];
    _thereView.tag=303;
    
    UITapGestureRecognizer *tapGesturel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestruel:)];
    tapGesturel.numberOfTapsRequired=1;
    tapGesturel.numberOfTouchesRequired=1;
    
    [_MallViewSelect addGestureRecognizer:tapGesturel];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestrue:)];
    tapGesture.numberOfTapsRequired=1;
    tapGesture.numberOfTouchesRequired=1;
   
    [_OneView addGestureRecognizer:tapGesture];

    
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestrue:)];
    tapGesture2.numberOfTapsRequired=1;
    tapGesture2.numberOfTouchesRequired=1;
    
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestrue:)];
    tapGesture3.numberOfTapsRequired=1;
    tapGesture3.numberOfTouchesRequired=1;
    
    [_twoView addGestureRecognizer:tapGesture2];
    [_thereView addGestureRecognizer:tapGesture3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tapGestruel:(UIGestureRecognizer *)gesture{

    UIStoryboard *comStory=[UIStoryboard storyboardWithName:@"Comment" bundle:nil];
    MallViewController *mallVC=[comStory instantiateViewControllerWithIdentifier:@"com.mdb.CommentMallViewC"];
    mallVC.delegate=self;
    [self.navigationController pushViewController:mallVC animated:YES];

}
-(void)tapGestrue:(UIGestureRecognizer *)gesture{
    AppraiseVIew *vil=(AppraiseVIew *)gesture.view;
    CGPoint pint=[gesture locationInView:vil];
    float wight=vil.sumWidth/5.0;
    NSInteger cout=pint.x/wight;
  
    if ([vil isKindOfClass:[AppraiseVIew class]]) {
        AppraiseVIew *appl=(AppraiseVIew *)vil;
        
        [appl setSelectImageIndex:cout+1];
        
        switch (appl.tag-300) {
            case 1:
                sdquality=cout+1;
                break;
            case 2:
                sdship=cout+1;
                break;
            case 3:
                sdcustom=cout+1;
                break;
            default:
                break;
        }
    }

}
- (IBAction)upButton:(id)sender {
    if (!_mallobj) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您还没没选商城"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        alertView.tag=111;
        [alertView show];
        
    }else{
    
    [[FMDBHelper shareInstance] createMarkeEditTable];

        
    NSDate *nowDate=[NSDate date];
    NSTimeInterval ints=[nowDate timeIntervalSince1970];
    NSString *strInter=[NSString stringWithFormat:@"%f",ints];

    Marked *marke = [[Marked alloc] init];
    marke.markedid = strInter;
    marke.content = textl;
    marke.usertoken = [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
    marke.count = @"1";
    marke.time = [NSString stringWithFormat:@"%@",[NSDate date]];
    marke.sdquality = [NSString stringWithFormat:@"%@",@(sdquality)];
    marke.sdship = [NSString stringWithFormat:@"%@",@(sdship)];
    marke.sdcustom = [NSString stringWithFormat:@"%@",@(sdcustom)];
    marke.siteid = [NSString stringWithFormat:@"%@",@(_mallobj.mallid)];
    [[FMDBHelper shareInstance] saveMarkeEditContent:marke];
    
    for (id obj in photoArrl) {
        if ([obj isKindOfClass:[UIImage class]]) {
            NSData *data = UIImagePNGRepresentation(obj);
            Photoscle *photo = [[Photoscle alloc] init];
            photo.markid = strInter;
            photo.index = [NSString stringWithFormat:@"%@",@([photoArrl indexOfObject:obj])];
            photo.pdata = data;
            [[FMDBHelper shareInstance] saveMarkePhoto:photo];
        }
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"晒单正在提交，请到我的原创里查看"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
    alertView.tag=112;
    [alertView show];
        
    [MDB_UserDefault setFinishBaskDate:[NSDate date]];
    [[NSNotificationCenter defaultCenter]postNotificationName:kShaidanUpshareImageManagerNotification object:nil];
    
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==112) {
    if (buttonIndex==0) {
        if (_upshareView) {
            _upshareView.isPoPViewC=YES;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    }
}

-(void)appRriceSelect:(MallObjct *)mallob{
    if (![mallob.name isKindOfClass:[NSNull class]]) {
    _MallTitle.text=mallob.name;
    }
    _mallobj=mallob;
}
-(void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
