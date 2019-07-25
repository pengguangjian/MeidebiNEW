//
//  MyStickerBrowserViewController.m
//  ImessageIcon
//
//  Created by mdb-losaic on 2018/5/10.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "MyStickerBrowserViewController.h"

@interface MyStickerBrowserViewController ()<MSStickerBrowserViewDataSource>

@property (nonatomic, strong) NSMutableArray *dateArray;//数据源数据

@end

@implementation MyStickerBrowserViewController

- (void)loadView{
    [super loadView];
    self.dateArray = [NSMutableArray array];
    self.stickerBrowserView.dataSource = self;
    
    for (int i = 1; i < 17; i++) {
        NSString *nameStr = [NSString stringWithFormat:@"0%d",i];
        NSURL *url = [[NSBundle mainBundle] URLForResource:nameStr withExtension:@"gif"];
        MSSticker *sticker = [[MSSticker alloc]initWithContentsOfFileURL:url localizedDescription:@"" error:nil];
        [self.dateArray addObject:sticker];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.stickerBrowserView reloadData];
    
}

- (NSInteger)numberOfStickersInStickerBrowserView:(MSStickerBrowserView *)stickerBrowserView{
    return self.dateArray.count;
}

- (MSSticker *)stickerBrowserView:(MSStickerBrowserView *)stickerBrowserView stickerAtIndex:(NSInteger)index{
    MSSticker *sticker = self.dateArray[index];
    return sticker;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
