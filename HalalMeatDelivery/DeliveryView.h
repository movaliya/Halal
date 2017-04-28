//
//  DeliveryView.h
//  ScrollSample
//
//  Created by BacancyMac-i7 on 05/09/16.
//  Copyright © 2016 BacancyMac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"
#import "PayPalMobile.h"


@interface DeliveryView : UIViewController<PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate>
{
    NSString *C_ID_Delivery;
    NSString *Paymethod_Str;
    NSString *final_total;
    NSMutableDictionary *paypalInfoDic;
    
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *SecondViewGap;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TherdviewGap;

@property (strong, nonatomic) IBOutlet UIScrollView *MainScroll;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

@property (strong, nonatomic) IBOutlet UIButton *First_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Second_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Therd_BTN;
@property (strong, nonatomic) IBOutlet UIView *FirstView;
@property (strong, nonatomic) IBOutlet UIView *SecondView;
@property (strong, nonatomic) IBOutlet UIView *TherdView;

@property (strong, nonatomic) NSString *C_ID_Delivery;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ScrollHight;
@property (weak, nonatomic) IBOutlet UITextField *UserName_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserEmail_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserPhoneNo_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserPincode_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserAddress_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserCity_txt;
@property (weak, nonatomic) IBOutlet UIButton *CashOnDeleveryRadio_Btn;
@property (weak, nonatomic) IBOutlet UIButton *PaymentRadio_btn;


@property (weak, nonatomic) IBOutlet UILabel *SubTotal_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingCharge_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingDiscount_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Grand_Total_LBL;

- (IBAction)COD_radioBtn_Action:(id)sender;
- (IBAction)PaymentRadioBtn_action:(id)sender;

- (IBAction)Back_Click:(id)sender;

- (IBAction)First_Click:(id)sender;
- (IBAction)Second_Click:(id)sender;
- (IBAction)Therd_Click:(id)sender;
@end
