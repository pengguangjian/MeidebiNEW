//
//  BrokeTypeAlertView.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/28.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "BrokeTypeActionSheetView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
@interface BrokeTypeActionSheetView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) UIWindow *showWindow;

@end

@implementation BrokeTypeActionSheetView
{
    BOOL Display[20];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview{
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.offset(52);
    }];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#FD7A0F"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5.f;
    [cancelBtn addTarget:self action:@selector(respondsToCancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _typeTableView = [UITableView new];
    [self addSubview:_typeTableView];
    [_typeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancelBtn.mas_top).offset(-10);
        make.left.right.equalTo(cancelBtn);
        make.height.offset(300);
    }];
    _typeTableView.layer.masksToBounds = YES;
    _typeTableView.layer.cornerRadius = 5.f;
    _typeTableView.delegate = self;
    _typeTableView.dataSource = self;
    _typeTableView.estimatedRowHeight = 0;
    _typeTableView.estimatedSectionFooterHeight = 0;
    _typeTableView.estimatedSectionHeaderHeight = 0;
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.types.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (Display[section])
    {
        return [self.types[section][@"value"] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1.0];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    NSArray *subTypes = self.types[indexPath.section][@"value"];
    cell.textLabel.text = subTypes[indexPath.row][@"name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(brokeTypeActionSheetView:didSelectType:)]) {
        NSMutableDictionary *dictemp = [[NSMutableDictionary alloc] initWithDictionary:self.types[indexPath.section][@"value"][indexPath.row]];
        [dictemp setObject:self.types[indexPath.section][@"name"] forKey:@"supername"];
        [self.delegate brokeTypeActionSheetView:self didSelectType:dictemp];////self.types[indexPath.section][@"value"][indexPath.row]
    }
    [self hiddenAlert];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIControl *headerview = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 50)];
    headerview.backgroundColor = [UIColor whiteColor];
    headerview.tag = section;
    [headerview addTarget:self action:@selector(respondsToHeaderEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [UIView new];
    [headerview addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(headerview);
        make.height.offset(1);
    }];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#DBDBDB"];
    
    UILabel *typeContentLabel = [UILabel new];
    [headerview addSubview:typeContentLabel];
    [typeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerview);
    }];
    typeContentLabel.textAlignment = NSTextAlignmentCenter;
    typeContentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    typeContentLabel.font = [UIFont systemFontOfSize:16.f];
    typeContentLabel.text = self.types[section][@"name"];
    
    return headerview;
}


- (void)respondsToHeaderEvent:(id)sender{
    
    UIControl *headerControl = (UIControl *)sender;
    NSInteger section = headerControl.tag;
    Display[section] = !Display[section];
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:section];
    [_typeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)respondsToCancelBtnEvent:(id)sender{
    [self hiddenAlert];
}
- (void)showActionSheet{
     _showWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
     _showWindow.windowLevel = UIWindowLevelAlert;
     _showWindow.backgroundColor = [UIColor clearColor];
    [_showWindow addSubview:self];
    [_showWindow makeKeyAndVisible];

}

- (void)hiddenAlert{
    [self removeFromSuperview];
    _showWindow.hidden = YES;
    _showWindow = nil;
}

#pragma mark - setter and getter
- (void)setTypes:(NSArray *)types{
    _types = types;
    [_typeTableView reloadData];
}

@end
