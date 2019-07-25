//
//  PersonalBirthAlertView.m
//  Meidebi
//  生日弹窗
//  Created by fishmi on 2017/6/23.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "PersonalBirthAlertView.h"

@interface PersonalBirthAlertView ()
@property (nonatomic ,weak) UIView *backgrandV;
@property (nonatomic ,weak) UIButton *cancleBtn;
@property (nonatomic ,weak) UIButton *finishBtn;
@property (nonatomic ,weak) UILabel *titleL;
@property (nonatomic ,strong) NSMutableArray *yearArray;
@property (nonatomic ,strong) NSMutableArray *monthArray;
@property (nonatomic ,strong) NSString *birth;
//@property (nonatomic ,strong) NSString *year;
//@property (nonatomic ,strong) NSString *month;
@end
static NSString *const cellID = @"PersonalBirthTableViewCell";
@implementation PersonalBirthAlertView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.frame = CGRectMake(0, 0, kMainScreenW, kMainScreenH);
        [self setDataArray];
        [self setUpSubView];
        
    }
    return self;
}

- (void)setDataArray{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSDate *datenow = [NSDate date];
    NSString *currentYearString = [formatter stringFromDate:datenow];
    NSMutableArray *yearArray = [NSMutableArray array];
    for (NSInteger i = 0; i < ([currentYearString integerValue] - 1950 + 1); i ++) {
        NSInteger year = 1950 + i;
        NSString *str = [NSString stringWithFormat:@"%@年",@(year)];
        [yearArray addObject:str];
    }
    _yearArray = yearArray;
    
    NSMutableArray *monthArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 12; i ++) {
        NSInteger month = i + 1;
        NSString *str = [NSString stringWithFormat:@"%@月",@(month)];
        [monthArray addObject:str];
    }
    _monthArray = monthArray;
    

}

- (void)setUpSubView{
    
    UIView *backgrandV = [[UIView alloc] init];
    [self addSubview:backgrandV];
    [backgrandV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    backgrandV.backgroundColor = [UIColor darkGrayColor];
    backgrandV.alpha = 0.8;
    _backgrandV = backgrandV;
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backgrandV);
        make.size.mas_equalTo(CGSizeMake(321 *kScale, 227 *kScale));
    }];
    view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    view.layer.cornerRadius = 4;
    view.clipsToBounds = YES;
    
    
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.textColor = [UIColor colorWithHexString:@"#333333"];
    titleL.text = @"生日";
    titleL.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    titleL.font = [UIFont systemFontOfSize:18];
    titleL.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.offset((227 *kScale - 4) * 0.2);
    }];
    _titleL = titleL;
    
    
//    UIPickerView *pickerView = [[UIPickerView alloc] init];
//    pickerView.tag = 100;
//    pickerView.backgroundColor = [UIColor whiteColor];
//    pickerView.delegate = self;
//    pickerView.dataSource = self;
//    [view addSubview:pickerView];
//    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view);
//        make.top.equalTo(titleL.mas_bottom).offset(1);
//        make.right.equalTo(view);
//        make.height.offset((227 *kScale - 4) * 0.6);
//    }];
    
    UIDatePicker *datePicker  = [[UIDatePicker alloc] init];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    //picker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(seletedBirthyDate:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:datePicker];
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.top.equalTo(titleL.mas_bottom).offset(1);
        make.right.equalTo(view);
        make.height.offset((227 *kScale - 4) * 0.6);
    }];
    [self seletedBirthyDate:datePicker];

    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.tag = 3;
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setBackgroundColor:[UIColor whiteColor]];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [view addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(view);
        make.top.equalTo(datePicker.mas_bottom).offset(1);
        make.width.offset(321 *kScale *0.5 - 1);
        
    }];
    _cancleBtn = cancleBtn;
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.tag = 4;
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:finishBtn];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(view);
        make.top.equalTo(datePicker.mas_bottom).offset(1);
        make.left.equalTo(cancleBtn.mas_right).offset(1);
        
    }];
    _finishBtn = finishBtn;
    
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return 2;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    if (component == 0) {
//        return _yearArray.count;
//    }else{
//        return _monthArray.count;
//    }
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (component == 0) {
//        return _yearArray[row];
//    }else{
//        return _monthArray[row];
//    }
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;{
//    UIView *subView = [pickerView viewForRow:row forComponent:component];
//    UILabel *label = [[UILabel alloc] init];
//    label.textColor = [UIColor colorWithHexString:@"#999999"];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:16];
//    [subView addSubview:label];
//    label.center = subView.center;
//    label.width = 0.25 *kMainScreenW *kScale;
//    
//    if (component == 0) {
//        label.text = _yearArray[row];
//    }else{
//        label.text = _monthArray[row];
//    }
//    
//    return label;
//    
//}

//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
//    return (227 *kScale - 4) * 0.2;
//}
//
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    if (component == 0) {
//         _year = _yearArray[row];
//    }else if(component == 1){
//        _month = _monthArray[row];
//    }
//}


- (void)seletedBirthyDate:(UIDatePicker *)datePicker{
     NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *data = [fmt stringFromDate:datePicker.date];
    _birth = data;
}

- (void)btnClicked: (UIButton *)btn{
    if (btn.tag == 3) {
        [self removeFromSuperview];
    }else if (btn.tag == 4){
        if ([self.delegate respondsToSelector:@selector(finishBtnClicked:view:)]) {
            [self.delegate finishBtnClicked:_birth view:self];
        }
        [self removeFromSuperview];
    }
}





@end
