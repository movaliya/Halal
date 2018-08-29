//
//  HeaderCell.h
//  HalalMeatDelivery
//
//  Created by kaushik on 29/08/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;
@property (strong, nonatomic) IBOutlet UIImageView *ArrowIMG;
@property (strong, nonatomic) IBOutlet UIButton *CellBTN;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ArrowHight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ArrowWidht;
@end
