//
//  SignViewControoler.m
//  Meidebi
//
//  Created by 杜非 on 15/3/6.
//  Copyright (c) 2015年 meidebi. All rights reserved.
//

#import "PushSetingViewControoler.h"
#import "HTTPManager.h"
#import "MDB_UserDefault.h"
//#import "UMessage.h"
#import "GMDCircleLoader.h"
#import "PushSubscibeViewController.h"

//#import "UMessage.h"
#import <UMPush/UMessage.h>

@interface PushSetingViewControoler ()
<
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,assign)BOOL     isall;
@property(nonatomic,assign)BOOL     localstock;
@property(nonatomic,assign)BOOL     issound;
@property(nonatomic,assign)BOOL     isvibrate;
@property(nonatomic,assign)BOOL     istime;
@property(nonatomic,assign)NSInteger      minh;
@property(nonatomic,assign)NSInteger      maxh;
//@property (nonatomic ,weak) UILabel *subLabel;

@end

@implementation PushSetingViewControoler{
    NSArray *_arrone;
    NSArray *_arrtwo;
    NSArray *_arrthree;
    NSArray *_arrfore;
    NSArray *_arrall;
    NSString *_locatStr;
    NSString *_longitude;
    NSString *_latitude;
    UILabel  *labtimel;
    UISwitch *swithtimel;
    UIActionSheet* startsheet;
    BOOL _isClose;
    BOOL _isBest;       // 精华推送
    BOOL _iskeyword;   ///是否喲关键词
}
float   cellHig;
NSDictionary *dic;
NSMutableArray *hoursArray;
NSMutableArray *minutesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    cellHig=65.0f;
    self.title=@"推送设置";
    [self loadData];
    [self setnavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    NSDictionary *prama;
    if ([MDB_UserDefault getIsLogin]) {
        prama=@{@"umengtoken":[NSString nullToString:[MDB_UserDefault getUmengDeviceToken]],
                @"userkey":[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken]};
    }else{
        if ([MDB_UserDefault getUmengDeviceToken]) {
            prama=@{@"umengtoken":[MDB_UserDefault getUmengDeviceToken]};
        }
    }
    [HTTPManager sendRequestUrlToService:URL_getumengconfig withParametersDictionry:prama view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct) {
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]&&[[dicAll objectForKey:@"status"] intValue]) {
                if ([[dicAll objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
                     dic=[dicAll objectForKey:@"data"];
                    
                    _isall=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"isclose"]]boolValue];
                    _issound=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"issound"]]boolValue];
                    _isvibrate=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"isvibrate"]]boolValue];
                    _isBest=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"best"]]boolValue];
                    
                    _isall=!_isall;
                    
                    _minh=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"minh"]]intValue];
                    _maxh=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"maxh"]]intValue];
                    _iskeyword =  [[NSString stringWithFormat:@"%@",[dic objectForKey:@"keyword"]]boolValue];
                    [self setArrall];
                    [self settablevw];
                }
            }
        }
    }];

}

-(void)setArrall{
    
    _arrone = !_arrone?@[@"a"]:_arrone;
    _arrtwo = !_isall ? nil : @[@"a"];
    _arrthree = !_isall? nil: @[@"a"];
    _arrfore = @[@"a",@"b"];
//    _arrall=!_arrall?[NSArray arrayWithObjects:_arrone,_arrtwo,_arrthree,_arrfore, nil]:_arrall;
    _arrall=!_arrall?[NSArray arrayWithObjects:_arrone,_arrtwo, nil]:_arrall;
    if (_maxh == 0 && _minh == 0) {
        _minh = 22;
        _maxh = 8;
        _istime = NO;
        [MDB_UserDefault setAaronLiStarDate:[NSString stringWithFormat:@"%@",@(_minh)]];
        [MDB_UserDefault setAaronLiEndDate:[NSString stringWithFormat:@"%@",@(_maxh)]];
    }
    else
    {
       _istime = YES;
    }
}

-(void)settablevw{
    _tableview=[[UITableView alloc]init];
    //改变换行线颜色
    _tableview.separatorColor = [UIColor blueColor];
    //设定行高
//    _tableview.rowHeight=cellHig;
    //设定cell分行线的样式，默认为UITableViewCellSeparatorStyleSingleLine
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //设定cell分行线颜色
    [_tableview setSeparatorColor:RadLineColor];
    //编辑tableView
   // _tableview.editing=NO;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kTopHeight, 0, 0, 0));
        }
    }];
}
-(void)setnavigation{
    UIButton *butleft=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [butleft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [butleft setImage:[UIImage imageNamed:@"back_click.png"] forState:UIControlStateHighlighted];
    [butleft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [butleft addTarget:self action:@selector(doClickBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithCustomView:butleft];
    self.navigationItem.leftBarButtonItem=leftBar;
}
/*
 if(_keys.length>0)
 {
 if(_isBest)
 {
 [UMessage removeTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
 
 }];
 [UMessage addTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
 
 }];
 }
 else
 {
 [UMessage removeTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
 
 }];
 [UMessage removeTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
 
 }];
 }
 }
 else
 {
 //UMessage
 if(_isBest)
 {
 [UMessage removeTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
 
 }];
 [UMessage addTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
 
 }];
 }
 else
 {
 [UMessage removeTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
 
 }];
 [UMessage addTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
 
 }];
 }
 }
 */
-(void)doClickBackAction{
//    NSString *musta = [[MDB_UserDefault getPushCats] componentsJoinedByString:@","];
//    NSString *org = @"";
//    if ([MDB_UserDefault getPushSources].count ==0) {
//        org = [@[@"1",@"2",@"3"] componentsJoinedByString:@","];
//    }else{
//        org = [[MDB_UserDefault getPushSources] componentsJoinedByString:@","];
//    }
    
    NSMutableDictionary *prama=[[NSMutableDictionary alloc]init];
    [MDB_UserDefault getUmengDeviceToken]?[prama setObject:[MDB_UserDefault getUmengDeviceToken] forKey:@"umengtoken"]:nil;
    [MDB_UserDefault defaultInstance].usertoken?[prama setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"]:nil;
    [MDB_UserDefault getIsLogin]?[prama setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"]:nil;
    _istime?[prama setObject:[NSString stringWithFormat:@"%@",@(_minh)] forKey:@"minh"]:[prama setObject:@"0" forKey:@"minh"];
    _istime?[prama setObject:[NSString stringWithFormat:@"%@",@(_maxh)] forKey:@"maxh"]:[prama setObject:@"0" forKey:@"maxh"];
    _issound?[prama setObject:@"1" forKey:@"issound"]:[prama setObject:@"0" forKey:@"issound"];
    _isvibrate?[prama setObject:@"1" forKey:@"isvibrate"]:[prama setObject:@"0" forKey:@"isvibrate"];
    _isBest?[prama setObject:@"1" forKey:@"best"]:[prama setObject:@"0" forKey:@"best"];
    _isall?[prama setObject:@"0" forKey:@"isclose"]:[prama setObject:@"1" forKey:@"isclose"];
    
    
    [MDB_UserDefault setAaronLiEndDate:[NSString stringWithFormat:@"%@",@(_maxh)]];
    [MDB_UserDefault setAaronLiStarDate:[NSString stringWithFormat:@"%@",@(_minh)]];
    
    if (_isall) {
        [HTTPManager sendRequestUrlToService:URL_newsetconfig withParametersDictionry:prama view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            if (responceObjct==nil) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
               
                
                if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]&&[dicAll objectForKey:@"status"]) {
                    
                    [self settuisongsehzhi];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                   [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }else{
        if (![MDB_UserDefault getUmengDeviceToken]){
            [self.navigationController popViewControllerAnimated:YES];
            return;
        };
        [HTTPManager sendRequestUrlToService:URL_newsetconfig withParametersDictionry:prama view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
            if (responceObjct==nil) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
                NSDictionary *dicAll=[str JSONValue];
                if ([[dicAll objectForKey:@"info"]isEqualToString:@"GET_DATA_SUCCESS"]&&[[dicAll objectForKey:@"status"] intValue]) {
                    
                    [self settuisongsehzhi];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
    
}


-(void)settuisongsehzhi
{
    if(_iskeyword)
    {
        if(_isBest)
        {
//            [UMessage removeTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//            }];
//
//
//            [UMessage addTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//            }];
            
            [UMessage deleteTags:@"daihuanxing" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                
            }];
            [UMessage addTags:@"jinghua" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                
            }];
            
        }
        else
        {
//            [UMessage removeTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//            }];
//            [UMessage removeTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//            }];
            
            [UMessage deleteTags:@"daihuanxing" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                
            }];
            [UMessage deleteTags:@"jinghua" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                
            }];
        }
    }
    else
    {
        //UMessage
        if(_isBest)
        {
//            [UMessage removeTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//            }];
//            [UMessage addTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//            }];
            
            [UMessage deleteTags:@"daihuanxing" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                
            }];
            [UMessage addTags:@"jinghua" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                
            }];
            
        }
        else
        {
//            [UMessage removeTag:@"jinghua" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//            }];
//            [UMessage addTag:@"daihuanxing" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
//
//            }];
            [UMessage deleteTags:@"jinghua" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                
            }];
            [UMessage addTags:@"daihuanxing" response:^(id  _Nullable responseObject, NSInteger remain, NSError * _Nullable error) {
                
            }];
            
            
            
        }
    }
    
}

#pragma mark Uitableview Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return cellHig-20;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrall.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65 *kScale;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    UIView *lineV = [[UIView alloc] init];
    [cell addSubview:lineV];
    lineV.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cell);
        make.height.offset(1);
    }];
    
    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"消息推送";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(20 *kScale);
            make.centerY.equalTo(cell);
            make.width.offset(100 *kScale);
        }];
        
        UISwitch *swiths = [[UISwitch alloc] init];
        [cell addSubview:swiths];
        [swiths mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-26 *kScale);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(50 *kScale, 30 *kScale));
        }];
        swiths.tag = 41;
        swiths.on = _isall;
        [swiths addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
    }else if (indexPath.row ==1){
        UILabel *label = [[UILabel alloc] init];
        label.text = @"精华推送";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(20 *kScale);
            make.centerY.equalTo(cell);
            make.width.offset(100 *kScale);
        }];
        
        UISwitch *swiths = [[UISwitch alloc] init];
        [cell addSubview:swiths];
        [swiths mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-26 *kScale);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(50 *kScale, 30 *kScale));
        }];
        swiths.tag = 1000;
        swiths.on = _isBest;
        [swiths addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
    }else if (indexPath.row ==2){
        UILabel *label = [[UILabel alloc] init];
        label.text = @"勿扰模式";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(20 *kScale);
            make.top.equalTo(cell).offset(15);
            make.width.offset(100 *kScale);
        }];
        UILabel *subLabel = [[UILabel alloc] init];
//        subLabel.text = @"";
        subLabel.tag = 343;
        subLabel.textAlignment = NSTextAlignmentLeft;
        subLabel.font = [UIFont systemFontOfSize:12];
        subLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [cell addSubview:subLabel];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(20 *kScale);
            make.top.equalTo(label.mas_bottom).offset(6);
            make.width.offset(150 *kScale);
        }];
//        _subLabel = subLabel;
        if (_istime) {
//            [subLabel setTextColor:RadLineColor];
//            [subLabel setTextColor:RadCellBiaoColor];
            subLabel.text=[NSString stringWithFormat:@"(%@:00-%@:00)",@(_minh),@(_maxh)];
            labtimel=subLabel;
            [MDB_UserDefault setAaronLiStarDate:[NSString stringWithFormat:@"%@",@(_minh)]];
            [MDB_UserDefault setAaronLiEndDate:[NSString stringWithFormat:@"%@",@(_maxh)]];
        }else{
            _minh = 22;
            _maxh = 8;
            [MDB_UserDefault setAaronLiStarDate:@"22"];
            [MDB_UserDefault setAaronLiEndDate:@"8"];
            [MDB_UserDefault setAaronLiStarDate:[NSString stringWithFormat:@"%@",@(_minh)]];
            [MDB_UserDefault setAaronLiEndDate:[NSString stringWithFormat:@"%@",@(_maxh)]];
            subLabel.text=[NSString stringWithFormat:@"(%@:00-%@:00)",@(_minh),@(_maxh)];
            labtimel=subLabel;
        }

        
        
        UISwitch *swiths = [[UISwitch alloc] init];
        [cell addSubview:swiths];
        [swiths mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-26 *kScale);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(50 *kScale, 30 *kScale));
        }];
        swiths.tag = 44;
        swiths.on = _istime;
        [swiths addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
    }else{
        UILabel *label = [[UILabel alloc] init];
        label.text = @"声音震动";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(20 *kScale);
            make.centerY.equalTo(cell);
            make.width.offset(100 *kScale);
        }];
        
        UISwitch *swiths = [[UISwitch alloc] init];
        [cell addSubview:swiths];
        [swiths mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-26 *kScale);
            make.centerY.equalTo(cell);
            make.size.mas_equalTo(CGSizeMake(50 *kScale, 30 *kScale));
        }];
        swiths.tag = 42;
        swiths.on = _issound;
        [swiths addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
    }
    
//    UITableViewCell *cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, cellHig *kScale)];
//    if (indexPath.row==0) {
//        UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
//        [vies setBackgroundColor:RadLineColor];
//        [cell addSubview:vies];
//    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
//    UIView *vies=[[UIView alloc]initWithFrame:CGRectMake(0, cellHig-1, self.view.frame.size.width, 1)];
//    [vies setBackgroundColor:RadLineColor];
//    [cell addSubview:vies];
//    UILabel *labels=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, cellHig-10)];
//    [labels setTextColor:RadCellBiaoColor];
//    float scoWithfloat=self.view.frame.size.width-70;
//    
//    if (indexPath.section==0) {
//        if (_arrone) {
//            labels.text=@"消息推送";
//             BOOL bools=_isall;
//            [self setcell:cell tag:41 bools:bools];
//        }
//    }else  if (indexPath.section==1){
//        if (_arrtwo) {
//            if (indexPath.row == 0) {
//                labels.text=@"精华推送";
//                [self setcell:cell tag:1000 bools:_isBest];
//            }
//            else if (indexPath.row == 1){
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                labels.text=@"关键词订阅推送";
//            }
//        }
//    }else  if (indexPath.section==2){
//        if (_arrthree) {
//            if (indexPath.row==0) {
//                labels.text=@"声音震动";
//                [self setcell:cell tag:42 bools:_issound];
//            }
//            else{
//                labels.text=@"震动";
//                [self setcell:cell tag:43 bools:_isvibrate];
//            }
//        }
//    }else  if (indexPath.section==3){
//        if (_arrfore) {
//            if (indexPath.row==0) {
//                labels.text=@"勿扰模式";
//                BOOL bools=(_minh == 0 && _maxh == 0)?NO:YES;
//                _istime=bools;
//                [self setcell:cell tag:44 bools:bools];
//            }else if (indexPath.row==1){
//                labels.text=@"勿扰时间段";
//                UILabel *laes=[[UILabel alloc]initWithFrame:CGRectMake(scoWithfloat-65.0, 5, 120.0, cellHig-10.0)];
//                laes.textAlignment = NSTextAlignmentRight;
//                laes.tag=343;
//                [cell addSubview:laes];
//                if (_istime) {
//                    [laes setTextColor:RadLineColor];
//                    [laes setTextColor:RadCellBiaoColor];
//                    laes.text=[NSString stringWithFormat:@"%@:00-%@:00",@(_minh),@(_maxh)];
//                    labtimel=laes;
//                    [MDB_UserDefault setAaronLiStarDate:[NSString stringWithFormat:@"%@",@(_minh)]];
//                    [MDB_UserDefault setAaronLiEndDate:[NSString stringWithFormat:@"%@",@(_maxh)]];
//                }else{
//                    _minh = 22;
//                    _maxh = 8;
//                    [MDB_UserDefault setAaronLiStarDate:@"22"];
//                    [MDB_UserDefault setAaronLiEndDate:@"8"];
//                    [MDB_UserDefault setAaronLiStarDate:[NSString stringWithFormat:@"%@",@(_minh)]];
//                    [MDB_UserDefault setAaronLiEndDate:[NSString stringWithFormat:@"%@",@(_maxh)]];
//                    laes.text=[NSString stringWithFormat:@"%@:00-%@:00",@(_minh),@(_maxh)];
//                    labtimel=laes;
//                }
//            }
//        }
//    }
//    
//    [cell addSubview:labels];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        UIPickerView *pickV=[self setPickView];
        if (IOS_VERSION_8_OR_ABOVE) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                           {
                                               
                                               UITableViewCell *cells=[tableView cellForRowAtIndexPath:indexPath];
//                                               NSIndexPath *indexpath2=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
//                                               UITableViewCell *cell2=[tableView cellForRowAtIndexPath:indexpath2];
                                               if (IOS_VERSION_8_OR_ABOVE) {
                                                   
                                                   
                                                   for (UIView *las in [cells subviews]) {
                                                       if (las.tag==343) {
                                                           UILabel *lasl=(UILabel *)las;
                                                           lasl.text=[NSString stringWithFormat:@"(%@:00-%@:00)",@(_minh),@(_maxh)];
                                                           lasl.textColor=RadCellBiaoColor;
                                                       }else if (las.tag==44){
                                                           
                                                           UISwitch *lasl=(UISwitch *)las;
                                                           lasl.on=YES;
                                                           
                                                       }

                                                   }
                                               }else{
                                                   labtimel.text=[NSString stringWithFormat:@"(%@:00-%@:00)",@(_minh),@(_maxh)];
                                                   labtimel.textColor=RadCellBiaoColor;
                                                   swithtimel.on=YES;
                                               }
//                                               for (UIView *las in [cell2 subviews]) {
//                                                   if (las.tag==44) {
//                                                       UISwitch *lasl=(UISwitch *)las;
//                                                       lasl.on=YES;
//                                                       
//                                                   }
//                                               }
                                           }];
            
            [alertController.view addSubview:pickV];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            
            startsheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil,
                          nil];
            startsheet.tag = 333;
            [startsheet addSubview:pickV];
            [startsheet showInView:self.view];
        }

    }
    
//    if (indexPath.section==1) {
//        if (indexPath.row == 1) {
//            PushSubscibeViewController *subscibeVc = [[PushSubscibeViewController alloc] init];
//            [self.navigationController pushViewController:subscibeVc animated:YES];
//        }
//    }else if (indexPath.section==3) {
//        if (indexPath.row==1) {
//                    }
//    }
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableview){
        CGFloat sectionHeaderHeight = 64; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(void)setcell:(UITableViewCell *)cell tag:(int)tage bools:(BOOL)bools{
    
    float scoWithfloat=self.view.frame.size.width-65;
    UISwitch *swiths=[[UISwitch alloc]initWithFrame:CGRectMake(scoWithfloat, 5, 80, cellHig-10)];
    [swiths addTarget:self action:@selector(PicMode_switched:) forControlEvents:UIControlEventValueChanged];
    swiths.tag=tage;
    swiths.on=bools;
    if (tage==44) {
        swithtimel=swiths;
    }
    [cell addSubview:swiths];

}

-(void)deleteSection{
    _arrall=@[_arrone];
    _arrtwo=nil;
    _arrthree=nil;
    _arrfore=nil;
    [_tableview reloadData];
    
}
-(void)setSection{
    if ([MDB_UserDefault getAaronLiStarDate]) {
        _minh=[[NSString stringWithFormat:@"%@",[MDB_UserDefault getAaronLiStarDate]]intValue];
    }else{
        _minh = 22;
    }
    if ([MDB_UserDefault getAaronLiEndDate]) {
        _maxh=[[NSString stringWithFormat:@"%@",[MDB_UserDefault getAaronLiEndDate]]intValue];
    }else{
        _maxh = 8;
    }
    
    
    _arrtwo=!_arrtwo?@[@"a",@"b"]:_arrtwo;
    _arrthree=!_arrthree?@[@"a"]:_arrthree;
    _arrfore = @[@"a",@"b"];
//    _arrall=[NSArray arrayWithObjects:_arrone,_arrtwo,_arrthree,_arrfore, nil];
    _arrall=[NSArray arrayWithObjects:_arrone,_arrtwo, nil];
    _issound = YES;
    _isvibrate = YES;

    [_tableview reloadData];

    
}
-(void)PicMode_switched:(UISwitch *)sender{
    NSInteger tag=sender.tag;
    switch (tag) {
        case 41:
        {
            ///消息推送
            _isall=sender.isOn;
            if (!_isall) {
               [self deleteSection];
            }else{
               [self setSection];
            }
        }
            break;
        case 42:
        {
            ///声音震动
            _issound=sender.isOn;
            _isvibrate=sender.isOn;
            NSIndexPath *indes=[NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cels=[_tableview cellForRowAtIndexPath:indes];
            for (UIView *views in [cels subviews]) {
                if (views.tag==41) {
                    UISwitch *swiths=(UISwitch *)views;
                    swiths.on=YES;
                }
            }
                
//            if (!_isall) {
//                _isall=YES;
//                NSIndexPath *indes=[NSIndexPath indexPathForRow:0 inSection:0];
//                UITableViewCell *cels=[_tableview cellForRowAtIndexPath:indes];
//                for (UIView *views in [cels subviews]) {
//                    if (views.tag==41) {
//                        UISwitch *swiths=(UISwitch *)views;
//                        swiths.on=YES;
//                    }
//                }
//            }
        }
            break;
        case 44:
        {
            ///勿扰模式
            _istime=sender.isOn;
            if (!_istime) {
//                _arrfore=@[@"a"];
//                _arrall=[NSArray arrayWithObjects:_arrone,_arrtwo,_arrthree,_arrfore, nil];
//                [_tableview beginUpdates];
//                [_tableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationFade];
//                [_tableview endUpdates];
            }else{
//                _arrfore=@[@"a",@"b"];
//                _arrall=[NSArray arrayWithObjects:_arrone,_arrtwo,_arrthree,_arrfore, nil];
//                [_tableview beginUpdates];
//                [_tableview insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationFade];
//                [_tableview endUpdates];
                [self setcellsl:_istime];
            }
        }
            break;
        case 1000:{///精华推送
            _isBest=sender.isOn;
            if (_isBest) {
                NSIndexPath *indes=[NSIndexPath indexPathForRow:1 inSection:1];
                UITableViewCell *cels=[_tableview cellForRowAtIndexPath:indes];
                for (UIView *views in [cels subviews]) {
                    if (views.tag==41) {
                        UISwitch *swiths=(UISwitch *)views;
                        swiths.on=YES;
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)setcellsl:(BOOL)bools{
    NSIndexPath *indss=[NSIndexPath indexPathForRow:1 inSection:3];
    UITableViewCell *cells=[_tableview cellForRowAtIndexPath:indss];
    if (IOS_VERSION_8_OR_ABOVE) {
        for (UIView *las in [cells subviews]) {
            if (las.tag==343) {
                UILabel *lasl=(UILabel *)las;
                if (_istime) {
                    lasl.textColor=RadCellBiaoColor ;
                }else{
                lasl.textColor=RadLineColor;
                }
            }
        }
    }else{
        if (_istime) {
            labtimel.textColor=RadCellBiaoColor ;
        }else{
            labtimel.textColor=RadLineColor;
        }
    }

}
-(void)reloadAddress{
    NSMutableDictionary *prama=[NSMutableDictionary
                                dictionaryWithDictionary:@{@"umengtoken":[MDB_UserDefault getUmengDeviceToken],
                                                           @"isclose":[NSString stringWithFormat:@"%@",@(_isClose)],
                                                           @"longitude":_isClose?@"":_longitude,
                                                           @"latitude":_isClose?@"": _latitude}];
    [MDB_UserDefault getIsLogin]?[prama setObject:[NSString nullToString:[MDB_UserDefault defaultInstance].usertoken] forKey:@"userkey"]:nil;
    [HTTPManager sendRequestUrlToService:URL_setumengaddress withParametersDictionry:prama view:self.view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        if (responceObjct){
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            NSLog(@"dicAll -- %@",dicAll);
        }}];
    
}


-(UIPickerView *)setPickView{
    UIPickerView *customPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(10.0, 0, self.view.frame.size.width-60.0, 200)];
    customPicker.delegate=self;
    customPicker.dataSource=self;

    hoursArray=[[NSMutableArray alloc]init];
    for (int i = 0; i <24; i++)
    {
        [hoursArray addObject:[NSString stringWithFormat:@"%d时",i]];
        
    }
    NSArray * amPmArray = @[@"到"];
    
    [customPicker selectRow:_minh inComponent:0 animated:YES];
    [customPicker selectRow:[amPmArray indexOfObject:@"到"] inComponent:1 animated:YES];
    [customPicker selectRow:_maxh inComponent:2 animated:YES];
  
    return customPicker;
    
    
}
#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        _minh = row;
    }
    else if (component == 2)
    {
       _maxh = row;
    }
}
#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 60, 70);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17.0f]];
    }
    
    if (component == 0)
    {
        if (![[hoursArray objectAtIndex:row] isKindOfClass:[NSNull class]]&&hoursArray.count>row) {
            pickerLabel.text =  [hoursArray objectAtIndex:row];
        }
        
    }
    else if (component == 1)
    {
         pickerLabel.text =  @"到"; // Date
        pickerLabel.font=[UIFont systemFontOfSize:18.0];
    }
    else if (component == 2)
    {
        if (![[hoursArray objectAtIndex:row] isKindOfClass:[NSNull class]]&&hoursArray.count>row) {
            pickerLabel.text =  [hoursArray objectAtIndex:row]; // Hours
        
        }
    }
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [hoursArray count];
    }
    else if (component == 1)
    {
         return 1;
    }
    else
    {
        return [hoursArray count];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==333) {

        NSIndexPath *inds=[NSIndexPath indexPathForRow:1 inSection:3];
        UITableViewCell *cells=[_tableview cellForRowAtIndexPath:inds];
        if (IOS_VERSION_8_OR_ABOVE) {
            
        for (UIView *las in [cells subviews]) {
            if (las.tag==343) {
                UILabel *lasl=(UILabel *)las;
                lasl.text=[NSString stringWithFormat:@"%@:00-%@:00",@(_minh),@(_maxh)];
            }
        }
        }else{
            labtimel.text=[NSString stringWithFormat:@"%@:00-%@:00",@(_minh),@(_maxh)];
            swithtimel.on=YES;
        }
        NSIndexPath *indexpath2=[NSIndexPath indexPathForRow:inds.row-1 inSection:inds.section];
        UITableViewCell *cell2=[_tableview cellForRowAtIndexPath:indexpath2];
        for (UIView *las in [cell2 subviews]) {
            if (las.tag==44) {
                UISwitch *lasl=(UISwitch *)las;
                lasl.on=YES;
            }
        }
    
    }
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:NO];
    [startsheet removeFromSuperview];
     startsheet = nil;
}



@end
