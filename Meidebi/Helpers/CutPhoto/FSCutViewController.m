//
//  RootViewController.m
//  test1
//
//  Created by madao on 14-8-6.
//  Copyright (c) 2014年 焦子成. All rights reserved.
//

#import "FSCutViewController.h"

@interface FSCutViewController ()
{
    UIView *view;//手势矩形
    UIImageView *imv;
    UIView *coverView;
    UIScrollView *bgscro;
    
    float imvHeight;
}
@end

@implementation FSCutViewController
@synthesize delegate=_delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    //NSLog(@"scrollviewdidzoom scrollview tag %d %f",scrollView.tag,scrollView.zoomScale);
    scrollView.contentSize=CGSizeMake(self.view.frame.size.width*scrollView.zoomScale, (imvHeight*scrollView.zoomScale)+self.view.frame.size.height-self.view.frame.size.width-20*IOS_VERSION_7_OR_ABOVE);
    
    
}
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    // NSLog(@"imv1 %f",imv.width);
    return imv;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.alpha=0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:self.originImg];
 
    bgscro=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    bgscro.minimumZoomScale=1.0;
    bgscro.maximumZoomScale=1.5;
    bgscro.zoomScale=1.0;
    bgscro.delegate=self;
    //bgscro.clipsToBounds=YES;
    
   
    
    
    [self.view addSubview:bgscro];
    //bgscro.
    imvHeight=self.originImg.size.height*self.view.frame.size.width/self.originImg.size.width;
    imv=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2-self.view.frame.size.width/2+20*IOS_VERSION_7_OR_ABOVE, self.view.frame.size.width, imvHeight)];
    imv.contentMode=UIViewContentModeScaleAspectFit;
    
    imv.image=self.originImg;
    [bgscro addSubview:imv];
    imv.userInteractionEnabled=NO;
  
    
    
    bgscro.contentSize=CGSizeMake(self.view.frame.size.width, imvHeight+self.view.frame.size.height-self.view.frame.size.width);
    
    
    coverView=[[UIView alloc] initWithFrame:CGRectMake(0, 20*IOS_VERSION_7_OR_ABOVE, self.view.frame.size.width, self.view.frame.size.height-20*IOS_VERSION_7_OR_ABOVE)];
    coverView.backgroundColor=[UIColor clearColor];
    
    UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2-self.view.frame.size.width/2)];
    upview.backgroundColor=[UIColor blackColor];
    upview.alpha=0.5;
    [coverView addSubview:upview];
    //拖拽手势
    //UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerTap:)];
    //[imv addGestureRecognizer:pan];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-self.view.frame.size.width/2, self.view.frame.size.width, self.view.frame.size.width)];
    view.layer.borderWidth=1.0;
    view.layer.borderColor=[UIColor whiteColor].CGColor;
    view.backgroundColor=[UIColor clearColor];
    [coverView addSubview:view];
    
    UIView *downview=[[UIView alloc] initWithFrame:CGRectMake(0, (view.frame.origin.y + view.frame.size.height), self.view.frame.size.width, self.view.frame.size.height/2-self.view.frame.size.width/2)];//view.bottom
    downview.backgroundColor=[UIColor blackColor];
    downview.alpha=0.5;
    [coverView addSubview:downview];
    coverView.userInteractionEnabled=NO;
    [self.view addSubview:coverView];
    
    UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    bottomView.backgroundColor=[UIColor blackColor];
    bottomView.alpha=0.7;
    bottomView.userInteractionEnabled=NO;
    [self.view addSubview:bottomView];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(20, self.view.frame.size.height-60+8, 60, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    cancelBtn.userInteractionEnabled=YES;
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *choseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [choseBtn setFrame:CGRectMake(240, self.view.frame.size.height-60+8, 60, 44)];
    [choseBtn setTitle:@"选取" forState:UIControlStateNormal];
    [choseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:choseBtn];
    choseBtn.userInteractionEnabled=YES;
    [choseBtn addTarget:self action:@selector(choseBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)choseBtn:(id)sender{
    shotScreenModel *shotModel = [[shotScreenModel alloc]init];
    //NSLog(@"%f",imv.frame.size.width);

    imv.image=[imv.image imageByScalingProportionallyToSize:CGSizeMake(320, imv.image.size.height*320/imv.image.size.width)];
    
    [shotModel imageFromView:imv atFrame:CGRectMake((bgscro.contentOffset.x*imv.image.size.width/320)/bgscro.zoomScale, (bgscro.contentOffset.y*imv.image.size.width/320)/bgscro.zoomScale, imv.image.size.width/bgscro.zoomScale, imv.image.size.width/bgscro.zoomScale) andDelegate:self];

    
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     //NSLog(@"scrollViewDidScroll %f %f",bgscro.contentOffset.y,bgscro.contentInset.top);
     [bgscro setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}
-(void)cancelBtn:(id)sender{
   
     self.navigationController.navigationBar.alpha=1;
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - passImageDelegate
-(void)passImage:(UIImage *)image
{
    //self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    imv.image=image;
   
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"uploadheadImg" object:imv.image userInfo:nil];
    if (_delegate) {
        [_delegate loadimvImage:imv.image];
    }
   // [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

////拖拽手势
//-(void)panGestureRecognizerTap:(UIPanGestureRecognizer *)pan
//{
//    static CGPoint firstPoint;
//    
//    if (pan.state == UIGestureRecognizerStateBegan) {//手势开始
//        //        firstPoint = [pan translationInView:self.view];
//        firstPoint = [pan locationInView:imv];
//        //        printf("firstPoint--> x:%f  y:%f\n",firstPoint.x,firstPoint.y);
//    }
//    if (pan.state == UIGestureRecognizerStateChanged) {//手势移动
//        //        CGPoint lastPoint = [pan translationInView:self.view];
//        CGPoint lastPoint = [pan locationInView:imv];
//        //        printf("lastPoint--> x:%f  y:%f\n",lastPoint.x,lastPoint.y);
//        
//      
//        [imv setCenter:CGPointMake(imv.center.x+lastPoint.x-firstPoint.x, imv.center.y+lastPoint.y-firstPoint.y)];
//    }
//    if (pan.state == UIGestureRecognizerStateEnded) {//手势结束
//        //        printf("viewFram >>>  x:%f  y:%f  W:%f  H:%f\n",view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height);
//
//        
//        //截屏
////        shotScreenModel *shotModel = [[shotScreenModel alloc]init];
////        [shotModel imageFromView:imv atFrame:rect andDelegate:self];
//    }
//}




@end
