//
//  RestHeaderCell.h
//  HalalMeatDelivery
//
//  Created by kaushik on 22/08/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *Restorant_Name;
@property (weak, nonatomic) IBOutlet UILabel *Rest_Addess;
@property (weak, nonatomic) IBOutlet UILabel *RestorantName2;
@property (weak, nonatomic) IBOutlet UILabel *ReviewLBL;

-(void)ReviewCount:(NSString*)stars;
@end
