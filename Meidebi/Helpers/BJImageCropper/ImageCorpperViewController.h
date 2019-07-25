//
//  ImageCorpperViewController.h
//  xnmlss
//
//  Created by 杜非 on 15/4/15.
//
//

#import <UIKit/UIKit.h>
#import "BJImageCropper.h"
@protocol ImageCorpperViewControllerDelegate<NSObject>

-(void)loadimvImage:(UIImage *)image;

@end



@interface ImageCorpperViewController : UIViewController




@property(nonatomic,strong)UIImage  *img;
//@property (nonatomic, strong) IBOutlet UILabel *boundsText;
@property (nonatomic, strong) BJImageCropper *imageCropper;

@property (nonatomic, strong) UIImageView *preview;
@property (nonatomic,weak)id<ImageCorpperViewControllerDelegate>delegate;

@end
