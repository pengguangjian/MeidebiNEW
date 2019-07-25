//
//  DaiGouReMenShopViewController.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/3/29.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "DaiGouReMenShopViewController.h"

#import "DaiGOuReMenShopCollectionViewCell.h"
#import "DaiGouReMenShopHeaderCollectionReusableView.h"
#import "DaiGouReMenShopFooterCollectionReusableView.h"

#import "DaiGouReMenShopDataController.h"

#import "ShopMainTableViewController.h"

@interface DaiGouReMenShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
    UICollectionView *collectView;
    DaiGouReMenShopDataController *dataControl;
    
    NSMutableArray *arrzhiyouData;
    NSMutableArray *arrzhuanyunData;
    
}
@end

@implementation DaiGouReMenShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门商家";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setSubview];
    dataControl = [[DaiGouReMenShopDataController alloc] init];
    [dataControl requestDGHomeListDataInView:self.view Callback:^(NSError *error, BOOL state, NSString *describle) {
        if([[dataControl.dicReustData objectForKey:@"direct_mail"] isKindOfClass:[NSArray class]])
        {
            arrzhiyouData = [dataControl.dicReustData objectForKey:@"direct_mail"];
        }
        if([[dataControl.dicReustData objectForKey:@"transfer"] isKindOfClass:[NSArray class]])
        {
            arrzhuanyunData = [dataControl.dicReustData objectForKey:@"transfer"];
        }
        
        [collectView reloadData];
        
    }];
}


-(void)setSubview
{
    float ftopheith =  kStatusBarHeight+44;
    float fother = 34.0;
    if(ftopheith<66)
    {
        ftopheith = 64;
        fother = 0;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake((BOUNDS_WIDTH-50)/4.0, (BOUNDS_WIDTH-50)/4.0);
    collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, ftopheith, BOUNDS_WIDTH-10, BOUNDS_HEIGHT-ftopheith-fother) collectionViewLayout:layout];
    [collectView setDelegate:self];
    [collectView setDataSource:self];
    collectView.backgroundColor = [UIColor whiteColor];
    [collectView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:collectView];
    
    // 注册cell、sectionHeader、sectionFooter
    [collectView registerClass:[DaiGOuReMenShopCollectionViewCell class] forCellWithReuseIdentifier:@"DaiGOuReMenShopCollectionViewCell"];
    [collectView registerClass:[DaiGouReMenShopHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DaiGouReMenShopHeaderCollectionReusableView"];
    [collectView registerClass:[DaiGouReMenShopHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DaiGouReMenShopHeaderCollectionReusableView1"];
    [collectView registerClass:[DaiGouReMenShopFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"DaiGouReMenShopFooterCollectionReusableView"];
    [layout prepareLayout];
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return arrzhiyouData.count;
    }
    else
    {
        return arrzhuanyunData.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DaiGOuReMenShopCollectionViewCell *cell = [collectView dequeueReusableCellWithReuseIdentifier:@"DaiGOuReMenShopCollectionViewCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    if(indexPath.section == 0)
    {
        cell.dicvalue = arrzhiyouData[indexPath.row];
    }
    else
    {
        cell.dicvalue = arrzhuanyunData[indexPath.row];
    }
    
    
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        if(indexPath.section == 0)
        {
            DaiGouReMenShopHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DaiGouReMenShopHeaderCollectionReusableView" forIndexPath:indexPath];
            if(headerView == nil)
            {
                headerView = [[DaiGouReMenShopHeaderCollectionReusableView alloc] init];
            }
            [headerView  setStrtitle:@"直邮商家"];
            return headerView;
        }
        else
        {
            DaiGouReMenShopHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DaiGouReMenShopHeaderCollectionReusableView1" forIndexPath:indexPath];
            if(headerView == nil)
            {
                headerView = [[DaiGouReMenShopHeaderCollectionReusableView alloc] init];
            }
            [headerView  setStrtitle:@"转运商家"];
            return headerView;
        }
        

        
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        DaiGouReMenShopFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DaiGouReMenShopFooterCollectionReusableView" forIndexPath:indexPath];
        if(footerView == nil)
        {
            footerView = [[DaiGouReMenShopFooterCollectionReusableView alloc] init];
        }

        return footerView;
    }
    return nil;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
/////item大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return (CGSize){(BOUNDS_WIDTH-50)/4.0,(BOUNDS_WIDTH-50)/4.0};
//}
//
/////间距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 0);
//}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10.f;
//}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 1.f;
//}

///顶部的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){BOUNDS_WIDTH,44};
}

///底部的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){BOUNDS_WIDTH,11};
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic;
    if(indexPath.section == 0)
    {
        dic = arrzhiyouData[indexPath.row];
    }
    else
    {
        dic = arrzhuanyunData[indexPath.row];
    }
    NSString *strid = [dic objectForKey:@"id"];
    NSLog(@"点击%@",strid);
    ShopMainTableViewController *svc = [[ShopMainTableViewController alloc] init];
    svc.strshopid = strid;
    svc.strshopname = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    [self.navigationController pushViewController:svc animated:YES];
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
