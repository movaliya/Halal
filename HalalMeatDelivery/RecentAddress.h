//
//  RecentAddress.h
//  HalalMeatDelivery
//
//  Created by kaushik on 25/06/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentAddress : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *Name_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Address_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Email_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Contact_LBL;

@property (strong, nonatomic) IBOutlet UIButton *Edit_BTN;
@property (strong, nonatomic) IBOutlet UIButton *DefailtBTN;

@end
