//
//  DeliveryView1.m
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "DeliveryView1.h"
#import "DeliveryView2.h"
@interface DeliveryView1 ()

@end

@implementation DeliveryView1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    if ([UserData count] != 0)
    {
        self.UserName_txt.text=[UserData valueForKey:@"u_name"];
        self.UserEmail_txt.text=[UserData valueForKey:@"u_email"];
        self.UserPhoneNo_txt.text=[UserData valueForKey:@"u_phone"];
        self.UserPincode_txt.text=[UserData valueForKey:@"u_pincode"];
        self.UserAddress_txt.text=[UserData valueForKey:@"u_address"];
        self.UserCity_txt.text=[UserData valueForKey:@"u_city"] ;
        _UserEmail_txt.enabled=NO;
        _UserEmail_txt.textColor=[UIColor grayColor];
        
        
    }
}
- (IBAction)NextBtn_action:(id)sender
{
    if ([_UserName_txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
    }
    else if ([_UserAddress_txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Address" delegate:nil];
    }
    else if ([_UserPincode_txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Pincode" delegate:nil];
    }
    else if ([_UserEmail_txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    else if ([_UserPhoneNo_txt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Phone Number" delegate:nil];
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self SendBillDetail];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        
    }

}
-(void)SendBillDetail
{
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:place_order_part_1_deliveryServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:self.C_ID_Delivery1  forKey:@"cid"];
    [dictParams setObject:_UserPincode_txt.text  forKey:@"u_pin"];
    
    [dictParams setObject:_UserName_txt.text  forKey:@"u_name"];
    [dictParams setObject:_UserEmail_txt.text  forKey:@"u_email"];
    [dictParams setObject:_UserPhoneNo_txt.text  forKey:@"u_phone"];
    [dictParams setObject:_UserAddress_txt.text  forKey:@"u_address"];
    
    [dictParams setObject:_UserCity_txt.text  forKey:@"u_city"];
    [dictParams setObject:@""  forKey:@"u_state"];
    [dictParams setObject:@""  forKey:@"u_country"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleBillProcessResponse:response];
     }];
}
- (void)handleBillProcessResponse:(NSDictionary*)response
{
    
    NSLog(@"respose bill process=%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
        
        DeliveryView2 *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeliveryView2"];
        vcr.ChargesDICNORY=response;
        vcr.CartID_DEL2=self.C_ID_Delivery1;
         vcr.dateNtime2=self.theDateNTimeDilvery;
        [self.navigationController pushViewController:vcr animated:NO];
        
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
- (IBAction)backBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
