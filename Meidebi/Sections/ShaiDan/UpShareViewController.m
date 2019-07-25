//
//  UpShareViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/12.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "UpShareViewController.h"
#import "Constants.h"
#import "MDB_UserDefault.h"
#import "FSCutViewController.h"
#import "FMDBHelper.h"
#import "Marked.h"
#import "Photoscle.h"
#import "UITextView+Placeholder.h"
#import "PhotoDeleteViewController.h"
#import "UpPhotoObj.h"
#import "MallAppraisalViewController.h"
#import "ZYQAssetPickerController.h"

@interface UpShareViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,PhotoDelegate,ZYQAssetPickerControllerDelegate>{
    UIScrollView *_scrollView;
    UITextView  *_textView;
    UITextView *_titleTextView;
    float      _imageWeith;
    UIButton    *_butAdd;
    UIImagePickerController * Imagepicker;
    int         _imvInt;
    UpPhotoObj *_uphotoObj;
    UIView *_spanLineView;
}
@property (nonatomic, assign) NSInteger number;
@end

@implementation UpShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑原创";
    self.view.backgroundColor = [UIColor whiteColor];
    _uphotoObj=[[UpPhotoObj alloc]init];
    _imvInt=1;
    [self setNavigation];
    [self setScrollViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)setScrollViews{
    
    _imageWeith=CGRectGetWidth(self.view.frame)/(8.0/70.0*5+4);
     _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight, self.view.frame.size.width, self.view.frame.size.height-kTopHeight)];
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height+1.0)];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_scrollView];
    
    _titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 25, kMainScreenW-16, 30)];
    _titleTextView.delegate = self;
    _titleTextView.backgroundColor = [UIColor clearColor];
    _titleTextView.font = [UIFont systemFontOfSize:14];
    _titleTextView.textColor = [UIColor colorWithHexString:@"#666666"];
    _titleTextView.returnKeyType = UIReturnKeyNext;
    _titleTextView.placeholder = @"请输入标题";
    [_scrollView addSubview:_titleTextView];
    
    _spanLineView = [[UIView alloc] init];
    _spanLineView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [_scrollView addSubview:_spanLineView];
    
    _textView=[[UITextView alloc]init];
    _textView.delegate=self;
    _textView.backgroundColor=[UIColor clearColor];
    _textView.font=[UIFont systemFontOfSize:14.0];
    _textView.textColor=RGB(153.0, 153.0, 153.0);
    [_textView setTextAlignment:NSTextAlignmentLeft];
    _textView.placeholder = @"晒晒这次购物的心情吧!...";
    _textView.returnKeyType=UIReturnKeyDone;
    [_scrollView addSubview:_textView];
    
    _butAdd=[[UIButton alloc]init];
    [_butAdd setBackgroundImage:[UIImage imageNamed:@"tjzp_click.png"] forState:UIControlStateHighlighted];
    [_butAdd setBackgroundImage:[UIImage imageNamed:@"tjzp.png"] forState:UIControlStateNormal];
    [_butAdd addTarget:self action:@selector(butAdd) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_butAdd];//125.0
    [self layoutSubviewFrame];
}

- (void)layoutSubviewFrame{
    _spanLineView.frame = CGRectMake(CGRectGetMinX(_titleTextView.frame), CGRectGetMaxY(_titleTextView.frame)+20, CGRectGetWidth(_titleTextView.frame), 1);
    _textView.frame = CGRectMake(CGRectGetMinX(_titleTextView.frame), CGRectGetMaxY(_spanLineView.frame)+20, CGRectGetWidth(self.view.frame)-16.0, 110.0);
    _butAdd.frame  = CGRectMake(_imageWeith*8.0/70.0, CGRectGetMaxY(_textView.frame)+20, _imageWeith, _imageWeith);
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(_butAdd.frame))];
}
-(void)butAdd{
    [_titleTextView resignFirstResponder];
    [_textView resignFirstResponder];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camaraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Imagepicker = [[UIImagePickerController alloc] init] ;
        Imagepicker.delegate=self;
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            Imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:Imagepicker animated:YES completion:nil];
        }
    }];
    UIAlertAction *camaralibAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection =(11-_imvInt)>=10?10:11-_imvInt;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:camaraAction];
    [alertController addAction:camaralibAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:NULL];

}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
       UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        UIImage *images= [MDB_UserDefault imageWithImage:tempImg scaledToSize:CGSizeMake(500, tempImg.size.height*500.0/tempImg.size.width)];
        [_uphotoObj.mutArr addObject:images];
        [self setImvWithImage:images];

    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *orighImg=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *images=[MDB_UserDefault imageWithImage:orighImg scaledToSize:CGSizeMake(500, orighImg.size.height*500.0/orighImg.size.width)];
    [_uphotoObj.mutArr addObject:images];
    [self setImvWithImage:images];
    
}


-(UIButton *)setImvWithImage:(UIImage *)image{
    _imvInt++;
    UIButton *imvBut=[[UIButton alloc]initWithFrame:CGRectMake(_imageWeith*8.0/70.0*((_imvInt-1)%4+1)+_imageWeith*((_imvInt-1)%4), (_imvInt-1)/4*(_imageWeith+_imageWeith*8.0/70.0)+CGRectGetMaxY(_textView.frame)+20, _imageWeith, _imageWeith)];
    imvBut.tag=50+_imvInt;
    [imvBut setBackgroundImage:image forState:UIControlStateNormal];
    
    [imvBut addTarget:self action:@selector(tapGrestur:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:imvBut];
    if ((_imvInt-1)/4*(_imageWeith+_imageWeith*8.0/70.0)+CGRectGetMaxY(_textView.frame)+20+_imageWeith>_scrollView.frame.size.height+1) {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, (_imvInt-1)/4*(_imageWeith+_imageWeith*8.0/70.0)+CGRectGetMaxY(_textView.frame)+20+_imageWeith)];
    }

    if (_imvInt==11) {
        _butAdd.hidden=YES;
        [self setScrollNil];
    }else{
        _butAdd.hidden=NO;
    }
    return imvBut;
}
-(void)setScrollNil{
    for (UIView *viewl in [_scrollView subviews]) {
        if ([viewl isKindOfClass:[UIButton class]]&&viewl!=_butAdd) {
            UIButton *butll=(UIButton *)viewl;
            int  imvl=(int)butll.tag-50;
            butll.frame=CGRectMake(_imageWeith*8.0/70.0*((imvl-2)%4+1)+_imageWeith*((imvl-2)%4), (imvl-2)/4*(_imageWeith+_imageWeith*8.0/70.0)+CGRectGetMaxY(_textView.frame)+20, _imageWeith, _imageWeith);
        }
    }
    
}

-(void)tapGrestur:(UIButton *)sender{
    NSInteger s=sender.tag-50;
    
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Share" bundle:nil];
    PhotoDeleteViewController *photoVC=[story instantiateViewControllerWithIdentifier:@"com.mdb.PhotoDeleteVC"];
    photoVC.photoArr=_uphotoObj.mutArr;
    photoVC.beloct=s-2;
    photoVC.delegate=self;
    [self.navigationController pushViewController:photoVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==112) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)delet:(NSArray *)arr{
    [_uphotoObj.mutArr removeAllObjects];
    [_uphotoObj.mutArr addObjectsFromArray:arr];
    [self reloadScrow];
}
-(void)reloadScrow
{
    _imvInt=1;
    for (id objc in [_scrollView subviews]) {
        if ([objc isKindOfClass:[UIButton class]]) {
            UIButton *buto=(UIButton *)objc;
            if (buto!=_butAdd) {
                [buto removeFromSuperview];
            }
        }
    }
    for (UIImage *Image in _uphotoObj.mutArr) {
        [self setImvWithImage:Image];
    }

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == _titleTextView) {
        CGRect frame = textView.frame;
        float height = [ self heightForTextView:textView WithText:textView.text];
        if ((NSInteger)frame.size.height != (NSInteger)height) {
            frame.size.height = height;
            _titleTextView.frame = frame;
            [self layoutSubviewFrame];
        }
        if ([text isEqualToString:@"\n"]) {
            [_textView becomeFirstResponder];
            return NO;
        }
    }else{
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)setNavigation{
    UIButton* btnRight = [[UIButton alloc]initWithFrame:CGRectMake(0,15,60,29)];//btnLeft.backgroundColor=[UIColor redColor];
    [btnRight setTitle:@"发布" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(doClickRightAction) forControlEvents:UIControlEventTouchUpInside];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btnRight setBackgroundColor: [UIColor colorWithHexString:@"#FF925D"]];
    btnRight.layer.masksToBounds = YES;
    btnRight.layer.cornerRadius = 4.f;
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
-(void)doClickRightAction{//
    
    if ([_titleTextView.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"原创标题不能为空"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        return;
    }
    
    if ([_textView.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您还没对此次原创进行描述"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        return;
    }
    if (_uphotoObj.mutArr.count==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您还没对此次原创添加图片"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        return;
    }
  
    [[FMDBHelper shareInstance] createMarkeEditTable];
    NSDate *nowDate=[NSDate date];
    NSTimeInterval ints=[nowDate timeIntervalSince1970];
    NSString *strInter=[NSString stringWithFormat:@"%f",ints];

    Marked *marke = [[Marked alloc] init];
    marke.markedid = strInter;
    marke.content = _textView.text;
    marke.title = _titleTextView.text;
    marke.usertoken = [NSString nullToString:[MDB_UserDefault defaultInstance].usertoken];
    marke.count = @"1";
    marke.time = [NSString stringWithFormat:@"%@",[NSDate date]];
    [[FMDBHelper shareInstance] saveMarkeEditContent:marke];

    for (id obj in _uphotoObj.mutArr) {
        if ([obj isKindOfClass:[UIImage class]]) {
            NSData *data = UIImagePNGRepresentation(obj);
            Photoscle *photo = [[Photoscle alloc] init];
            photo.markid = strInter;
            photo.index = [NSString stringWithFormat:@"%@",@([_uphotoObj.mutArr indexOfObject:obj])];
            photo.pdata = data;
            [[FMDBHelper shareInstance] saveMarkePhoto:photo];
        }
    }
    [MDB_UserDefault setFinishBaskDate:[NSDate date]];
    [[NSNotificationCenter defaultCenter]postNotificationName:kShaidanUpshareImageManagerNotification object:nil];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"晒单正在提交，请到我的原创里查看"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
    alertView.tag=112;
    [alertView show];

}
-(void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 14;
    return textHeight;
}

@end
