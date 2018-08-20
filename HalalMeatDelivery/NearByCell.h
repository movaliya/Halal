//
//  NearByCell.h
//  HalalMeatDelivery
//
//  Created by kaushik on 23/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView *Rest_IMG;
@property (strong, nonatomic) IBOutlet UILabel *RestNAME_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Desc_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Item_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Review_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Dist_LBL;
@property (strong, nonatomic) IBOutlet UIView *DistView;

@property (weak, nonatomic) IBOutlet UIImageView *Star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (strong, nonatomic) IBOutlet UIImageView *CellShadow;
@property (strong, nonatomic) IBOutlet UIView *BackView;

-(void)ReviewCount:(NSString*)stars;
@end
