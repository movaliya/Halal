//
//  PaymentView1.m
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "PaymentView1.h"
#import "PaymentView2.h"
@interface PaymentView1 ()

@end

@implementation PaymentView1
@synthesize UserCity_txt,UserName_txt,UserEmail_txt,UserAddress_txt,UserPhoneNo_txt,UserPincode_txt;
@synthesize C_ID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self getAddressData];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
}

-(void)getAddressData
{
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:GetDeleveryHistory  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleGetAddressResponse:response];
     }];
}

- (void)handleGetAddressResponse:(NSDictionary*)response
{
    NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        AddressArr=[[response valueForKey:@"result"] mutableCopy];
        for (NSString *Defaultname in AddressArr)
        {
            if ([[Defaultname valueForKey:@"isDefault"] isEqualToString:@"1"])
            {
                self.UserName_txt.text=[Defaultname valueForKey:@"name"];
                self.UserEmail_txt.text=[Defaultname valueForKey:@"email"];
                self.UserPhoneNo_txt.text=[Defaultname valueForKey:@"contact_number"];
                self.UserPincode_txt.text=[Defaultname valueForKey:@"pincode"] ;
                self.UserAddress_txt.text=[Defaultname valueForKey:@"address"] ;
                self.UserCity_txt.text=[Defaultname valueForKey:@"city"] ;
            }
        }
    }
    else
    {
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        
        if ([UserData count] != 0)
        {
            //NSString *User_UID=[[UserData valueForKey:@"u_id"] ;
            self.UserName_txt.text=[UserData valueForKey:@"u_name"] ;
            self.UserEmail_txt.text=[UserData valueForKey:@"u_email"] ;
            self.UserPhoneNo_txt.text=[UserData valueForKey:@"u_phone"];
            self.UserPincode_txt.text=[UserData valueForKey:@"u_pincode"] ;
            self.UserAddress_txt.text=[UserData valueForKey:@"u_address"] ;
            self.UserCity_txt.text=[UserData valueForKey:@"u_city"] ;
            UserEmail_txt.enabled=NO;
            UserEmail_txt.textColor=[UIColor grayColor];
            NSLog(@"UserData=%@",UserData);
        }
        //[AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
}


- (IBAction)NextBtn_action:(id)sender
{
    if ([UserName_txt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
    }
    else if ([UserAddress_txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Address" delegate:nil];
    }
    else if ([UserPincode_txt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Pincode" delegate:nil];
    }
    else if ([UserEmail_txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    else if ([UserPhoneNo_txt.text isEqualToString:@""])
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
    [dictParams setObject:PlaceOrderTakeAway1ServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:C_ID  forKey:@"cid"];
    [dictParams setObject:UserPincode_txt.text  forKey:@"u_pin"];
    
    [dictParams setObject:UserName_txt.text  forKey:@"u_name"];
    [dictParams setObject:UserEmail_txt.text  forKey:@"u_email"];
    [dictParams setObject:UserPhoneNo_txt.text  forKey:@"u_phone"];
    [dictParams setObject:UserAddress_txt.text  forKey:@"u_address"];
    
    [dictParams setObject:UserCity_txt.text  forKey:@"u_city"];
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
        
        PaymentView2 *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentView2"];
        vcr.ChargesDIC=response;
        vcr.DateNTime=self.PassDateNTime;
        vcr.Cart_ID=C_ID;
        [self.navigationController pushViewController:vcr animated:NO];
        
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
- (IBAction)BackBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
