//
//  PaymentView2.h
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentView2 : UIViewController
{
     NSMutableDictionary *take_away_address;
}


@property (strong, nonatomic) NSDictionary *ChargesDIC;
@property (strong, nonatomic) NSString *DateNTime;
@property (strong, nonatomic) NSString *Cart_ID;
@property (strong, nonatomic) NSString *PaymentString;

@property (weak, nonatomic) IBOutlet UILabel *TakeAwayDateTime;
@property (weak, nonatomic) IBOutlet UILabel *SubTotal_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingCharge_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingDiscount_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Grand_Total_LBL;
@property (weak, nonatomic) IBOutlet UITextField *Comment_TXT;
@end
