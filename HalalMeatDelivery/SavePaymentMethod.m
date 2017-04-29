//
//  SavePaymentMethod.m
//  HalalMeatDelivery
//
//  Created by Mango SW on 29/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "SavePaymentMethod.h"

@interface SavePaymentMethod ()

@end

@implementation SavePaymentMethod
@synthesize SaveBtn,MainVIEW,CashOndlvryIMAGE,OnlinePaymtIMAGE;


- (void)viewDidLoad {
    [super viewDidLoad];
    MainVIEW.layer.masksToBounds = NO;
    MainVIEW.layer.shadowOffset = CGSizeMake(-5, 5);
    MainVIEW.layer.shadowRadius = 5;
    MainVIEW.layer.shadowOpacity = 0.5;
    
    SaveBtn.layer.cornerRadius=11;
    SaveBtn.layer.masksToBounds=YES;
    SaveBtn.layer.borderColor=[[UIColor colorWithRed:161.0f/255.0f green:32.0f/255.0f blue:40.0f/255.0f alpha:1.0] CGColor];
    SaveBtn.layer.borderWidth=1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CashOnDelivery_Action:(id)sender
{
    CashOndlvryIMAGE.image=[UIImage imageNamed:@"RadioEnable"];
    OnlinePaymtIMAGE.image=[UIImage imageNamed:@"RadioDisable"];
    
    Paymethod_Str=@"CashOnDelivery";
}
- (IBAction)OnlinePayment_action:(id)sender
{
    CashOndlvryIMAGE.image=[UIImage imageNamed:@"RadioDisable"];
    OnlinePaymtIMAGE.image=[UIImage imageNamed:@"RadioEnable"];
    
    Paymethod_Str=@"OnlinePayment";
}
- (IBAction)SaveBtn_action:(id)sender
{
    
}
- (IBAction)BackBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
