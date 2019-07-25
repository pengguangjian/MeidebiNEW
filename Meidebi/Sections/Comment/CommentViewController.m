//
//  CommentViewController.m
//  Meidebi
//
//  Created by 杜非 on 15/2/5.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableView.h"
#import "HTTPManager.h"
#import "Constants.h"
#import "MDB_UserDefault.h"
#import "VKLoginViewController.h"
#import <FCUUID/FCUUID.h>
@interface CommentViewController ()<UITextViewDelegate,CommentTableViewDelegate>{
    Comment *_ment;
    int     cmType;
    BOOL    keyboredBool;
}

@end

@implementation Comment


- (id)init
{
    self = [super init];
    return self;
}
@end

@implementation CommentViewController{
    CommentTableView *_commenttableV;
    UIView          *_boomback;
    UITextView     *_textView;
    BOOL           _isZan;
    NSInteger comentid;
}
@synthesize type=_type;
@synthesize linkid=_linkid;


- (void)viewDidLoad {
    [super viewDidLoad];
    _isZan=NO;
    UIView *vis=[[UIView alloc]initWithFrame:CGRectMake(0, 64, 20.0, 20.0)];
    [self.view addSubview:vis];
    _commenttableV=[[CommentTableView alloc]initWithFrame:CGRectMake(0, 64.0, self.view.frame.size.width, self.view.frame.size.height-64.0-49.0) type:_type linkid:_linkid];
    _commenttableV.delegate=self;
    _commenttableV.type=_type;
    _commenttableV.linkid=_linkid;
    [self.view addSubview:_commenttableV];
   
    [self setNavigation];

    [self setboomback:self.view.frame.size.height-49.0];
    UISwipeGestureRecognizer *right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    right.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
}
-(void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)keyboardchange:(NSNotification *)notification{
    NSDictionary    *info=[notification userInfo];
    NSValue         *avalue=[info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect=[self.view convertRect:[avalue CGRectValue] fromView:nil];
    float keyboardHeight=keyboardRect.size.height;//键盘高度
    [self setboomback:(self.view.frame.size.height-49.0-keyboardHeight)];
}
-(void)setboomback:(float) h{
    if (_boomback) {
        [_boomback setFrame:CGRectMake(0, h, self.view.frame.size.width, 49.0)];
    }else{
        _boomback=[[UIView alloc]initWithFrame:CGRectMake(0, h, self.view.frame.size.width, 49.0)];
        [_boomback setBackgroundColor:RGB(250.0, 250.0, 250.0)];
        [self.view addSubview:_boomback];
        UIView *linev=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1.0)];
        [linev setBackgroundColor:RGB(225.0, 225.0, 225.0)];
        [_boomback addSubview:linev];
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(8.0, 10.0, self.view.frame.size.width-16.0, 30.0)];
        
        //_textView.borderStyle=UITextBorderStyleNone;
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setBorderWidth:1.0];
        
        [_textView.layer setBorderColor:RadLineColor.CGColor];
        _textView.delegate=self;
        _textView.backgroundColor=RGB(225.0, 225.0, 225.0);
       // _textView.placeholder=@"我来说点什么...";
        _textView.font=[UIFont systemFontOfSize:14.0];
        [_textView setTextAlignment:NSTextAlignmentLeft];
               //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
      //  _textView.clearButtonMode = UITextFieldViewModeWhileEditing;
        //反话按钮
        _textView.returnKeyType=UIReturnKeySend;
        [_boomback addSubview:_textView];
    }
}
-(BOOL)tableViewTouch{
    if (_boomback.frame.size.height<self.view.frame.size.height-100.0) {
        [_textView resignFirstResponder];
        // _textfield.placeholder=@"我来说点什么...";
        _ment=nil;
        [self setboomback:self.view.frame.size.height-49.0];
        
        return YES;
    }else{
        return NO;
    }
    
}

-(void)comment:(int)type cellrow:(Comment *)ment{
    if (type==1) {
        _ment=ment;
        cmType=1;
        
        [self mentZan:_ment];
    }else if (type==2){
        _ment=ment;
        cmType=2;
     //   _textView.placeholder=[NSString stringWithFormat:@"回复:%@",ment.nickname];
        [_textView becomeFirstResponder];
    }else if(type==3){
        _ment=ment;
        cmType=3;
       // _textfield.placeholder=[NSString stringWithFormat:@"引用:%@",ment.nickname];;
        [_textView becomeFirstResponder];
    }else if (type==4){
        [[UIPasteboard generalPasteboard] setString:ment.content];
        [MDB_UserDefault showNotifyHUDwithtext:@"复制成功" inView:self.view];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardchange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)mentZan:(Comment *)ment{
//    if (ment.comentid != comentid) {
    
        if ([MDB_UserDefault getIsLogin]) {
        NSDictionary *pramr=@{@"id":[NSString stringWithFormat:@"%@",@(ment.comentid)],
                              @"type":[NSString stringWithFormat:@"%@",@(_type)],
                              @"userkey":[MDB_UserDefault defaultInstance].usertoken};
        
        [HTTPManager sendRequestUrlToService:URL_commentvote withParametersDictionry:pramr view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            if (responceObjct!=nil){
                
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
               
                    if ([[dicAll objectForKey:@"status"]intValue] == 1) {
                        
                        [_commenttableV commentZan:ment];
                        _isZan=YES;
                        comentid = ment.comentid;
                    }else{
                        [MDB_UserDefault showNotifyHUDwithtext:@"赞失败" inView:self.view];
                    }
                }
                
            }
         ];

    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:122];
        [alertView show];
    }
//    }
//    else{
//        [MDB_UserDefault showNotifyHUDwithtext:@"你已经赞过了" inView:self.view];
//    }
}


-(void)setNavigation{
    self.title=@"评论";
    UIButton* btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];//btnLeft.backgroundColor=[UIColor redColor];
    btnLeft.frame = CGRectMake(0,0,44,44);
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnLeft addTarget:self action:@selector(doClickLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

}
-(void)doClickLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView{
    CGSize sizel=[MDB_UserDefault getStrhightFont:textView.font str:[NSString stringWithFormat:@"%@-",textView.text] wight:textView.frame.size.width];
    if (sizel.height>18.0&&textView.frame.size.height==30.0) {
        [_boomback setFrame:CGRectMake(0, _boomback.frame.origin.y-10.0, self.view.frame.size.width, 49.0+10.0)];
        [_textView setFrame:CGRectMake(8.0, 10.0, self.view.frame.size.width-16.0, 40.0)];
        
    }else if (sizel.height<18.0&&textView.frame.size.height==45.0){
        [_boomback setFrame:CGRectMake(0, _boomback.frame.origin.y+10, self.view.frame.size.width, 49.0)];
        [_textView setFrame:CGRectMake(8.0, 10.0, self.view.frame.size.width-16.0, 30.0)];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self textViewShouldReturn:textView.text];
    }
    
    return YES;

}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([MDB_UserDefault defaultInstance].usertoken) {
        _commenttableV.isup=YES;
        return YES;
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return NO;
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
  
    return YES;
}
- (void)textViewShouldReturn:(NSString *)textFStr
{
    NSString * toBeString = textFStr;
    if (!toBeString||[toBeString isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入内容"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
    MDB_UserDefault *userdefaul=[MDB_UserDefault defaultInstance];
    if(userdefaul.usertoken == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请登录后再试"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"登录",@"取消", nil];
        [alertView setTag:111];
        [alertView show];
        return;
    }
    NSMutableDictionary *dics;
    if (_ment) {
        if (cmType==2) {
           dics =[@{@"userid":[NSString nullToString:userdefaul.usertoken],
                   @"type":[NSString stringWithFormat:@"%@",@(_type)],
                   @"fromid":[NSString stringWithFormat:@"%@",@(_linkid)],
                   @"touserid":[NSString stringWithFormat:@"%@",@(_ment.userid)],
                   @"content":toBeString} mutableCopy];
        }else{
            dics =[@{@"userid":[NSString nullToString:userdefaul.usertoken],
                     @"type":[NSString stringWithFormat:@"%@",@(_type)],
                    @"fromid":[NSString stringWithFormat:@"%@",@(_linkid)],
                    @"referid":[NSString stringWithFormat:@"%@",@(_ment.comentid)],
                    @"content":toBeString} mutableCopy];
        }
    }else{
        dics =[@{@"userid":[NSString nullToString:userdefaul.usertoken],
                @"type":[NSString stringWithFormat:@"%@",@(_type)],
                @"fromid":[NSString stringWithFormat:@"%@",@(_linkid)],
                @"content":toBeString} mutableCopy];
    }
    [dics setValue:[FCUUID uuidForDevice] forKey:@"uniquetoken"];
    [HTTPManager sendRequestUrlToService:URL_commindex withParametersDictionry:dics view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct==nil) {
        
            
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
          
            if ([[dicAll objectForKey:@"status"]intValue]) {
                
                if ([[dicAll objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *dicobje=[NSMutableDictionary dictionaryWithDictionary:[dicAll objectForKey:@"data"]];
                    [dicobje setValue:userdefaul.userName forKey:@"nickname"];
                    [dicobje setValue:userdefaul.userphoto forKey:@"photo"];
                    //[_commenttableV.arrData addObject:[NSDictionary dictionaryWithDictionary:dicobje]];
                    Comment *ments=[self setComment:dicobje];
                    
                     [_commenttableV.arrData insertObject:ments atIndex:0];
                    [_commenttableV reloaddatewarr];
                }else{
                    NSMutableDictionary *dicobje=[[NSMutableDictionary alloc]init];
                    [dicobje setValue:userdefaul.userName forKey:@"nickname"];
                    [dicobje setValue:userdefaul.userphoto forKey:@"photo"];
                    [dicobje setValue:toBeString forKey:@"content"];
                    [dicobje setValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] ]  forKey:@"createtime"];
                    Comment *ments=[self setComment:dicobje];
                    if (_ment) {
                        if (cmType==2) {
                            ments.touserid=_ment.comentid;
                            ments.tonickname=_ment.nickname;
                            
                        }else{
                            ments.referto=_ment.comentid;
                            ments.refernickname=_ment.nickname;
                            ments.refercontent=_ment.content;
                        }
                    }
                    //[_commenttableV.arrData insertObject:[NSDictionary dictionaryWithDictionary:dicobje] atIndex:0];
                    
                     
                     [_commenttableV.arrData insertObject:ments atIndex:0];
                    [_commenttableV reloaddatewarr];
                }
               _textView.text=@"";
            }else{
                id obj=[dicAll objectForKey:@"info"];
                if ([obj isKindOfClass:[NSString class]]) {
                    NSString *sst=(NSString *)obj;
                     [MDB_UserDefault showNotifyHUDwithtext:sst inView:self.view];
                }

            }
            
        }
    }];
    [_boomback setFrame:CGRectMake(0, _boomback.frame.origin.y, self.view.frame.size.width, 49.0)];
    [_textView setFrame:CGRectMake(8.0, 10.0, self.view.frame.size.width-16.0, 30.0)];
    
    
    [_textView resignFirstResponder];
    [self setboomback:self.view.frame.size.height-49.0];
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==111||alertView.tag==110){
        if (buttonIndex==0) {
            [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
            VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
            [self.navigationController pushViewController:theViewController animated:YES ];
            
        }
    }else if(alertView.tag==122){
        if (buttonIndex==0) {
            [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
            VKLoginViewController* theViewController= [[VKLoginViewController alloc] init];
            [self.navigationController pushViewController:theViewController animated:YES ];
            
            
        }else{
            
            
        }
    }else if(alertView.tag==202){
    [_textView resignFirstResponder];
    }
}


-(Comment *)setComment:(NSDictionary *)dics{
    Comment *ment=[[Comment alloc]init];
    ment.comentid=[[NSString stringWithFormat:@"%@",[dics objectForKey:@"id"]] integerValue];
    ment.fromid=[[NSString stringWithFormat:@"%@",[dics objectForKey:@"fromid"]] integerValue];
    ment.createtime=[[NSString stringWithFormat:@"%@",[dics objectForKey:@"createtime"]] integerValue];
    ment.userid=[[NSString stringWithFormat:@"%@",[dics objectForKey:@"userid"]] integerValue];
    ment.touserid=[[NSString stringWithFormat:@"%@",[dics objectForKey:@"touserid"]] integerValue];
    ment.content=[dics objectForKey:@"content"];
    ment.tonickname=[dics objectForKey:@"tonickname"];
    ment.photo=[dics objectForKey:@"photo"];
    ment.refernickname=[dics objectForKey:@"refernickname"];
    ment.nickname=[dics objectForKey:@"nickname"];
    ment.refercontent=[dics objectForKey:@"refercontent"];
    return ment;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

@end
