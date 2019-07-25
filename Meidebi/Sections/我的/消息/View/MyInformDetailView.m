//
//  MyInformDetailView.m
//  Meidebi
//
//  Created by fishmi on 2017/7/3.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "MyInformDetailView.h"
#import "MDB_UserDefault.h"
#import <UIImageView+WebCache.h>
#import <YYLabel.h>
#import <YYTextView.h>
@interface MyInformDetailView ()
<
UIWebViewDelegate,
UIGestureRecognizerDelegate
>
@property (nonatomic ,strong) UILabel *nameL;
@property (nonatomic ,strong) UILabel *timeL;
@property (nonatomic ,strong) UILabel *textL;
@property (nonatomic ,strong) UIImageView *imageV;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) YYTextView *labelView;

@property (nonatomic, assign) NSInteger integerlast;


@end

@implementation MyInformDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView{
    UIImageView *imageV = [[UIImageView alloc] init];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10 *kScale);
        make.left.equalTo(self).offset(18 *kScale);
        make.size.mas_equalTo(CGSizeMake(56 *kScale, 56 * kScale));
    }];
    imageV.layer.cornerRadius = 28 *kScale ;
    imageV.clipsToBounds = YES;
    _imageV = imageV;
    
    UILabel *nameL = [[UILabel alloc] init];
    nameL.font = [UIFont systemFontOfSize:13];
    [self addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(18 *kScale);
        make.top.equalTo(self).offset(20 *kScale);
        make.width.offset(100 *kScale);
    }];
    
    nameL.textColor = [UIColor colorWithHexString:@"#a2a2a2"];
    nameL.textAlignment = NSTextAlignmentLeft;
    _nameL = nameL;
    
    UILabel *timeL = [[UILabel alloc] init];
    timeL.font = [UIFont systemFontOfSize:14];
    [self addSubview:timeL];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-18 *kScale);
        make.centerY.equalTo(nameL.mas_centerY);
        make.left.equalTo(nameL.mas_right).offset(20 *kScale);
    }];
    
    timeL.textColor = [UIColor colorWithHexString:@"#a2a2a2"];
    timeL.textAlignment = NSTextAlignmentRight;
    _timeL = timeL;
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.opaque = NO;
    _webView.backgroundColor= [UIColor clearColor];
    [self addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameL.mas_bottom).offset(30 *kScale);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
//    _labelView = [[UIWebView alloc] init];
//    [_labelView setBackgroundColor:[UIColor clearColor]];
//    [_labelView setTag:11];
//    [_labelView setOpaque:NO];
//    [self addSubview:_labelView];
//    [_labelView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(nameL.mas_bottom).offset(30 *kScale);
//        make.left.equalTo(self.mas_left).offset(10);
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.bottom.equalTo(self.mas_bottom).offset(-10);
//    }];
    
    YYTextView *titleLabel = [YYTextView new];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameL.mas_bottom).offset(30 *kScale);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
//    titleLabel.scrollEnabled = NO;
    titleLabel.showsVerticalScrollIndicator = NO;
    titleLabel.showsHorizontalScrollIndicator = NO;
    titleLabel.editable = NO;
    titleLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    titleLabel.font = [UIFont systemFontOfSize:14.f];
//    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//    [titleLabel setContentCompressionResistancePriority:998 forAxis:UILayoutConstraintAxisVertical];
//    [titleLabel setContentHuggingPriority:998 forAxis:UILayoutConstraintAxisVertical];
//    [titleLabel setContentCompressionResistancePriority:998 forAxis:UILayoutConstraintAxisHorizontal];
//    [titleLabel setContentHuggingPriority:998 forAxis:UILayoutConstraintAxisHorizontal];
    _labelView = titleLabel;

}



- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    if ([[dataDic objectForKey:@"relatenickname"] isEqualToString:@"admin"]) {
        _nameL.textColor = [UIColor orangeColor];
        _nameL.text = @"没得比";
        _imageV.image = [UIImage imageNamed:@"mdb_photo"];
    }else{
        _nameL.textColor = [UIColor colorWithHexString:@"#a2a2a2"];
        _nameL.text = [NSString nullToString:[dataDic objectForKey:@"relatenickname"]];
        if ([dataDic objectForKey:@"relatephoto"]) {
            [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString nullToString:[dataDic objectForKey:@"relatephoto"]]]];
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchToWithGesture:)];
        [_imageV addGestureRecognizer:tapGesture];
        _imageV.userInteractionEnabled = YES;
    }
    NSString *type = [NSString nullToString:[self.dataDic objectForKey:@"fromtype"]];
    if([type intValue] < 10)
    {
        [_webView setHidden:YES];
        [_labelView setHidden:NO];
        NSString *strcon = [NSString nullToString:[self.dataDic objectForKey:@"con"]];
        [_labelView setText:strcon];
        
        
        if ([type isEqualToString:@"1"]||[type isEqualToString:@"2"]||[type isEqualToString:@"3"]||[type isEqualToString:@"4"]||[type isEqualToString:@"5"]||[type isEqualToString:@"7"]||[type isEqualToString:@"8"]||[type isEqualToString:@"9"])
        {
            [_labelView setTextColor:RGB(28, 109, 225)];
            
//            NSString *str_bigfont=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bigfont01" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//            NSString *description_bigfont=[NSString stringWithFormat:@"<html>%@%@</html>",str_bigfont,strcon];
//
//
//            [_labelView loadHTMLString:description_bigfont baseURL:nil];
//
//            [_labelView.scrollView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *taplabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelAction:)];
            [taplabel setDelegate:self];
            [_labelView addGestureRecognizer:taplabel];
            
            
            
        }
        else
        {
            [_labelView setTextColor:RGB(80, 80, 80)];
//            NSString *str_bigfont=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bigfont02" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//            NSString *description_bigfont=[NSString stringWithFormat:@"<html>%@%@</html>",str_bigfont,strcon];
//
//
//            [_labelView loadHTMLString:description_bigfont baseURL:nil];
        }

    }
    else if([type intValue] == 10)
    {
        [_webView setHidden:NO];
        [_labelView setHidden:YES];
        NSString *str_bigfont=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bigfont" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSString *description_bigfont=[NSString stringWithFormat:@"<html>%@%@</html>",str_bigfont,[NSString nullToString:[dataDic objectForKey:@"content"]]];
        [_webView loadHTMLString:description_bigfont baseURL:nil];
        
    }
    
    

    if ([dataDic objectForKey:@"createtime"]) {
       _timeL.text = [MDB_UserDefault strTimefromData:[[NSString nullToString:[dataDic objectForKey:@"createtime"]] integerValue] dataFormat:nil];
    }
}

- (void)touchToWithGesture: (UIGestureRecognizer *)gesture{
    
    if ([self.delegate respondsToSelector:@selector(touchWithId:)]) {
        if ([_dataDic objectForKey:@"relateuserid"]) {
            [self.delegate touchWithId:[NSString nullToString:[_dataDic objectForKey:@"relateuserid"]]];
        }
    }
    
    
}

-(void)labelAction:(UIGestureRecognizer *)gesture
{
    NSString *type = [NSString nullToString:[self.dataDic objectForKey:@"fromtype"]];
    
    if(type.integerValue == 9)
    {
        [self.delegate webViewDidPresseeUrlWithLinkType:type andid:[NSString nullToString:[self.dataDic objectForKey:@"fromid"]] andurl:@""];
    }
    else
    {
        if(gesture.state == UITouchPhaseBegan)
        {
            _integerlast = 0;
            NSDate *date = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
            _integerlast = timeSp.integerValue*1000;
        }
        else if (gesture.state == UITouchPhaseEnded)
        {
            NSDate *date = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
            
            if(timeSp.integerValue*1000-_integerlast<1000)
            {
                if ([self.delegate respondsToSelector:@selector(webViewDidPreseeUrlWithLink:)]) {
                    [self.delegate webViewDidPreseeUrlWithLink:[NSString stringWithFormat:@"%@",@"http://www.meidebi.com/"]];
                }
            }
            
        }
    }
    
}
#pragma mark- UIWebViewDelegate 方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//        if (_isInteriorSkip) {
//            return _isInteriorSkip;
//        }
//        if ([self.delegate respondsToSelector:@selector(webViewDidPreseeUrlWithLink:)]) {
//            [self.delegate webViewDidPreseeUrlWithLink:[NSString stringWithFormat:@"%@",request.URL]];
//        }
        
        NSString *strurl = [NSString stringWithFormat:@"%@",request.URL];
        NSLog(@"%@",strurl);
        NSString *strtype = @"";
        NSString *strid = @"";
        
        ///分类点击 type
        if([strurl isEqualToString:@"https://www.meidebi.com/"]||[strurl isEqualToString:@"http://www.meidebi.com/"])
        {///跳转首页
            strtype = @"100";
        }
        else
        {
            if([strurl rangeOfString:@"quan"].location != NSNotFound)
            {///券搜搜
                strtype = @"101";
            }
            else if([strurl rangeOfString:@"original"].location != NSNotFound)
            {///原创
                strtype = @"102";
            }
            else if([strurl rangeOfString:@"fuli"].location != NSNotFound)
            {///福利
                strtype = @"103";
            }
            else if([strurl rangeOfString:@"baoliao"].location != NSNotFound)
            {///爆料
                strtype = @"104";
            }
        }
        
        ////其他详情点击 type
        NSString *strtemp = [self judgeUrlType:strurl];
        if(strtemp.length>0)
        {
            strtype = strtemp;
        }
        strid = [self judgeUrlId:strurl];
        
        ///其他详情点击 id
        [self.delegate webViewDidPresseeUrlWithLinkType:strtype andid:strid andurl:strurl];
        
        NSLog(@"++++:%@++++%@",strtype,[self judgeUrlId:strurl]);
        
        return NO;
    }
    return YES;
}

-(NSString *)judgeUrlType:(NSString *)strurl
{
    NSString *strtype = @"";
    if([strurl rangeOfString:@"guonei"].location != NSNotFound||[strurl rangeOfString:@"haitao"].location != NSNotFound||[strurl rangeOfString:@"tianmao"].location != NSNotFound||[strurl rangeOfString:@"g-"].location != NSNotFound||[strurl rangeOfString:@"h-"].location != NSNotFound||[strurl rangeOfString:@"m-"].location != NSNotFound)
    {
        strtype = @"1";
    }
    else if ([strurl rangeOfString:@"shaidan"].location != NSNotFound||[strurl rangeOfString:@"s-"].location != NSNotFound)
    {
        strtype = @"2";
    }
    else if ([strurl rangeOfString:@"trade"].location != NSNotFound)
    {
        strtype = @"3";
    }
    else if ([strurl rangeOfString:@"activityjoin"].location != NSNotFound)
    {
        strtype = @"4";
    }
    else if ([strurl rangeOfString:@"activity"].location != NSNotFound)
    {
        strtype = @"5";
    }
    else if ([strurl rangeOfString:@"special"].location != NSNotFound)
    {
        strtype = @"6";
    }
    else
    {
        strtype = @"";
    }
    return strtype;
}

-(NSString *)judgeUrlId:(NSString *)strurl
{
    
    
    
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSString *strtemp = [NSString nullToString:[strurl stringByTrimmingCharactersInSet:nonDigits]];
    
    
    return strtemp;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    _integerlast = 0;
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    _integerlast = timeSp.integerValue*1000;
    
    return YES;
}
@end
