//
//  PaymentView2.m
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "PaymentView2.h"
#import "HalalMeatDelivery.pch"
#import "ThankYouView.h"
#import "ShoppingCartView.h"
#import "HomeView.h"

@interface PaymentView2 ()
{
    ThankYouView *ThankPOPUp;
}
@property (strong, nonatomic) UIButton *ThanksOK;
@property (strong, nonatomic) UILabel *NamePop;
@property (strong, nonatomic) UILabel *MobilePop;
@property (strong, nonatomic) UILabel *CityPop;
@property (strong, nonatomic) UILabel *AddressPop;

@end

@implementation PaymentView2
@synthesize ThanksOK;
@synthesize NamePop,MobilePop,CityPop,AddressPop;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _SubTotal_LBL.text=[NSString stringWithFormat:@"£ %@",[self.ChargesDIC valueForKey:@"sub_total"]];
    _ShippingCharge_LBL.text= [NSString stringWithFormat:@"+ £ %@",[self.ChargesDIC valueForKey:@"shipping_charge"]];
    _ShippingDiscount_LBL.text=[NSString stringWithFormat:@"- £ %@",[self.ChargesDIC valueForKey:@"shipping_discount"]];
    _Grand_Total_LBL.text=[NSString stringWithFormat:@"£ %@",[self.ChargesDIC valueForKey:@"final_total"]];
    _TakeAwayDateTime.text=self.DateNTime;
    
    ThankPOPUp =[[[NSBundle mainBundle]loadNibNamed:@"TakeawayThaxView" owner:nil options:nil]firstObject];
    ThankPOPUp.frame =self.view.frame;
    [self.view addSubview:ThankPOPUp];
    ThankPOPUp.hidden=YES;
    
}
- (IBAction)PlaceOrderBtn_action:(id)sender
{
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        NSString *User_UID=[UserData valueForKey:@"u_id"] ;
        
        NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
        [dictParams setObject:r_p  forKey:@"r_p"];
        [dictParams setObject:PlaceOrderTakeAway2ServiceName  forKey:@"service"];
        [dictParams setObject:User_UID  forKey:@"uid"];
        [dictParams setObject:self.Cart_ID  forKey:@"cid"];
        
        
        NSLog(@"placeorder change Dic=%@",dictParams);
        
        [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
         {
             [self handlePlaceOrderResponse:response];
         }];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
}
- (void)handlePlaceOrderResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        take_away_address=[[response objectForKey:@"result"] objectForKey:@"take_away_address"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"QUANTITYCOUNT"];
        [self ShowPOPUP];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
#pragma mark - pop AlertView;

-(void)ShowPOPUP
{
    [ThankPOPUp bringSubviewToFront:self.view];
    ThankPOPUp.hidden=NO;
    
    ThanksOK= (UIButton *)[ThankPOPUp viewWithTag:23];
    ThanksOK.layer.cornerRadius=3.5;
    [ThanksOK addTarget:self action:@selector(ThanksOK_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    NamePop= (UILabel *)[ThankPOPUp viewWithTag:100];
    MobilePop= (UILabel *)[ThankPOPUp viewWithTag:101];
    CityPop= (UILabel *)[ThankPOPUp viewWithTag:102];
    AddressPop= (UILabel *)[ThankPOPUp viewWithTag:103];
    
    
    AddressPop.numberOfLines = 0;
    [AddressPop sizeToFit];
    
    NamePop.text=[take_away_address valueForKey:@"name"];
    MobilePop.text=[take_away_address valueForKey:@"phone"];
    CityPop.text=[take_away_address valueForKey:@"city"];
    AddressPop.text=[take_away_address valueForKey:@"address"];
    
}

-(void)ThanksOK_Click:(id)sender
{
    ThankPOPUp.hidden=YES;
    
    HomeView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
    [self.navigationController pushViewController:vcr animated:NO];
}
- (IBAction)backBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)PreviousBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
