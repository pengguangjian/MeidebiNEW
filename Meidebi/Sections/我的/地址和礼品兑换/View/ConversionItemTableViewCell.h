//
//  ConversionItemTableViewCell.h
//  
//
//  Created by mdb-admin on 2017/6/22.
//
//

#import <UIKit/UIKit.h>

@class ConversionItemTableViewCell;
@protocol ConversionItemTableViewCellDelegate <NSObject>

@optional - (void)tableViewCellDidClickConversionBtn:(ConversionItemTableViewCell *)cell type:(NSInteger)type;

@end

@interface ConversionItemTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ConversionItemTableViewCellDelegate> delegate;
- (void)bindDataWithModel:(NSDictionary *)dict;

@end
