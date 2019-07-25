//
//  PhotoDeleteViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/3/23.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "PhotoDeleteViewController.h"
#import "Constants.h"
@interface PhotoDeleteViewController ()<UIScrollViewDelegate>

@end

@implementation PhotoDeleteViewController{

    UIScrollView *_scrollv;
    NSInteger ints;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    [self.view setBackgroundColor:RGB(220.0, 220.0, 220.0)];
    UIView *vis=[[UIView alloc]initWithFrame:CGRectMake(0, 80, 20, 20)];
    [self.view addSubview:vis];
    _scrollv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64.0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollv.showsVerticalScrollIndicator=NO;
    _scrollv.showsHorizontalScrollIndicator=NO;
    _scrollv.delegate=self;
    _scrollv.pagingEnabled=YES;
    [_scrollv setContentSize:CGSizeMake(_scrollv.frame.size.width*_photoArr.count+2, _scrollv.frame.size.height)];
    self.title=[NSString stringWithFormat:@"%d/%@",(int)_beloct+1,@(_photoArr.count)];
    [self.view addSubview:_scrollv];
    ints=_beloct;
    
    [self setScrollV];
    _scrollv.contentOffset = CGPointMake(self.view.frame.size.width*ints, 0);
}
-(void)setScrollV{
    
    for (UIImage *image in _photoArr) {
        NSInteger slg=[_photoArr indexOfObject:image];
        UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(slg*self.view.frame.size.width, 0, self.view.frame.size.width, _scrollv.frame.size.height-64)];
        imv.tag=slg;
        imv.image=image;
        [imv setContentMode:UIViewContentModeScaleAspectFit];
        [_scrollv addSubview:imv];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = _scrollv.frame.size.width;
    int page =(int)floor((_scrollv.contentOffset.x - pagewidth/(_photoArr.count+1))/pagewidth);
    ints=page+1;
    self.title=[NSString stringWithFormat:@"%d/%@",page+2,@(_photoArr.count)];
}




-(void)setNavigation{
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(doClickLeftAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    UIButton* btnright = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnright.frame = CGRectMake(0,0,44,44);
    [btnright setImage:[UIImage imageNamed:@"clearSearchHistory"] forState:UIControlStateNormal];
    [btnright addTarget:self action:@selector(doShareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnright];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
-(void)doClickLeftAction:(id)sender{
    [_delegate delet:[NSArray arrayWithArray:_photoArr]];
    
     [self.navigationController popViewControllerAnimated:YES];
}
-(void)doShareAction{
    [_photoArr removeObjectAtIndex:ints];
    UIImageView *imgVs;
    for (UIImageView *imgV in [_scrollv subviews]) {
//        if (imgV.tag==ints) {
//            [imgV removeFromSuperview];
//        }else if(imgV.tag>ints){
//            imgV.frame=CGRectMake(imgV.frame.origin.x-self.view.frame.size.width, imgV.frame.origin.y, imgV.frame.size.width, imgV.frame.size.height);
//        }
        NSUInteger index=[[_scrollv subviews] indexOfObject:imgV];
        if (ints==index) {
            imgVs=imgV;
        }else if (index>ints){
        imgV.frame=CGRectMake(imgV.frame.origin.x-self.view.frame.size.width, imgV.frame.origin.y, imgV.frame.size.width, imgV.frame.size.height);
        }
    }
    [imgVs removeFromSuperview];
    [_scrollv setContentSize:CGSizeMake(_scrollv.frame.size.width*_photoArr.count, _scrollv.frame.size.height)];
   
    if (_photoArr.count==0) {
        [_delegate delet:[NSArray arrayWithArray:_photoArr]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (ints>_photoArr.count) {
        [_delegate delet:[NSArray arrayWithArray:_photoArr]];
        self.title=[NSString stringWithFormat:@"%@/%@",@(_photoArr.count),@(_photoArr.count)];
    }else{
    self.title=[NSString stringWithFormat:@"%d/%@",(int)ints+1,@(_photoArr.count)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
