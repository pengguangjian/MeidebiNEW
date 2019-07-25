//
//  ImageCorpperViewController.m
//  xnmlss
//
//  Created by 杜非 on 15/4/15.
//
//
#define SHOW_PREVIEW NO
#import "ImageCorpperViewController.h"
#import <QuartzCore/QuartzCore.h>

#ifndef CGWidth
#define CGWidth(rect)                   rect.size.width
#endif

#ifndef CGHeight
#define CGHeight(rect)                  rect.size.height
#endif

#ifndef CGOriginX
#define CGOriginX(rect)                 rect.origin.x
#endif

#ifndef CGOriginY
#define CGOriginY(rect)                 rect.origin.y
#endif



@interface ImageCorpperViewController ()

@end

@implementation ImageCorpperViewController
@synthesize delegate=_delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.alpha=0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];

    
    if(_img){
    
        self.imageCropper = [[BJImageCropper alloc] initWithImage:_img andMaxSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:self.imageCropper];
        self.imageCropper.center = self.view.center;
//        self.imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
//        self.imageCropper.imageView.layer.shadowRadius = 3.0f;
//        self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
//        self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
        
        [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
        
        if (SHOW_PREVIEW) {
            self.preview = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,self.imageCropper.crop.size.width * 0.1, self.imageCropper.crop.size.height * 0.1)];
            self.preview.image = [self.imageCropper getCroppedImage];
            self.preview.clipsToBounds = YES;
            self.preview.layer.borderColor = [[UIColor whiteColor] CGColor];
            self.preview.layer.borderWidth = 2.0;
            [self.view addSubview:self.preview];
            
        }
    
    }
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(20, self.view.frame.size.height-60+8, 60, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    cancelBtn.userInteractionEnabled=YES;
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *choseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [choseBtn setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-320.0+240, self.view.frame.size.height-60+8, 60, 44)];
    [choseBtn setTitle:@"选取" forState:UIControlStateNormal];
    [choseBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:choseBtn];
    choseBtn.userInteractionEnabled=YES;
    [choseBtn addTarget:self action:@selector(choseBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    
//    UIButton *RotationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [RotationBtn setFrame:CGRectMake(240.0-60.0, self.view.frame.size.height-60+8, 60, 44)];
//    [RotationBtn setTitle:@"+90°" forState:UIControlStateNormal];
//    [RotationBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.view addSubview:RotationBtn];
//    RotationBtn.userInteractionEnabled=YES;
//    [RotationBtn addTarget:self action:@selector(RotationBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setFrame:CGRectMake(20+60, self.view.frame.size.height-60+8, 60, 44)];
//    [leftBtn setTitle:@"-90°" forState:UIControlStateNormal];
//    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.view addSubview:leftBtn];
//    leftBtn.userInteractionEnabled=YES;
//    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

-(void)leftBtn:(id)sender{

    [self rotation:NO];
}
-(void)RotationBtn:(id)sender{
    [self rotation:YES];
}
-(void)rotation:(BOOL)bol{
    UIImage *imal=self.imageCropper.imageView.image;//UIImageOrientation
    UIImageOrientation orientation;
    switch (imal.imageOrientation) {
        case UIImageOrientationLeft:
            orientation=bol?UIImageOrientationUp:UIImageOrientationDown;
            break;
        case UIImageOrientationDown:
            orientation=bol?UIImageOrientationLeft:UIImageOrientationRight;
            break;
        case UIImageOrientationRight:
            orientation=bol?UIImageOrientationDown:UIImageOrientationUp;
            break;
        case UIImageOrientationUp:
            orientation=bol?UIImageOrientationRight:UIImageOrientationLeft;
            break;
        default:
            orientation=bol?UIImageOrientationRight:UIImageOrientationLeft;
            break;
    }
    UIImage * imagl =[UIImage imageWithCGImage:imal.CGImage scale:1 orientation:orientation];
    
    
    
    [self.imageCropper removeFromSuperview];
    [self.imageCropper removeObserver:self forKeyPath:@"crop" ];
    self.imageCropper = [[BJImageCropper alloc] initWithImage:imagl andMaxSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.imageCropper];
    [self.view sendSubviewToBack:self.imageCropper];
    self.imageCropper.center = self.view.center;
  
    [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)cancelBtn:(id)sender{
    [self.imageCropper removeObserver:self forKeyPath:@"crop" context:nil];
   [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)choseBtn:(id)sender{
   
    UIImage *ilmage=[_imageCropper getCroppedImage];
    if (_delegate) {
        [_delegate loadimvImage:ilmage];
    }
    [self.imageCropper removeObserver:self forKeyPath:@"crop" context:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
        [self updateDisplay];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateDisplay {
    
    if (SHOW_PREVIEW) {
        self.preview.image = [self.imageCropper getCroppedImage];
        self.preview.frame = CGRectMake(10,10,self.imageCropper.crop.size.width * 0.1, self.imageCropper.crop.size.height * 0.1);
    }
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
//        [self updateDisplay];
//    }
//}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateDisplay];
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
