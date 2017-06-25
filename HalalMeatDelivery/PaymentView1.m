//
//  PaymentView1.m
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "PaymentView1.h"
#import "PaymentView2.h"
#import "SelectPayment.h"
#import "RecentAddress.h"
#import "CreateNewAddressView.h"

#define ButtonColor [UIColor colorWithRed:171.0/255.0 green:30.0/255.0 blue:40.0/255.0 alpha:1.0]
#define DefaultBTNColor [UIColor colorWithRed:25.0/255.0 green:123.0/255.0 blue:48.0/255.0 alpha:1.0]

@interface PaymentView1 ()
{
    NSMutableDictionary *DefaltAddressArr;
}

@end

@implementation PaymentView1
@synthesize UserCity_txt,UserName_txt,UserEmail_txt,UserAddress_txt,UserPhoneNo_txt,UserPincode_txt;
@synthesize C_ID,TBL;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        //[self getAddressData];
        [self performSelector:@selector(getAddressData) withObject:self afterDelay:1.0 ];
        
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"RecentAddress" bundle:nil];
    RecentAddress *cell2 = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    TBL.rowHeight = cell2.frame.size.height;
    [TBL registerNib:nib forCellReuseIdentifier:@"RecentAddress"];
    /*
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        //[self getAddressData];
        [self performSelector:@selector(getAddressData) withObject:self afterDelay:1.0 ];

    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    */
    
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
    
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        AddressArr=[[response valueForKey:@"result"] mutableCopy];
         DefaltAddressArr = [[NSMutableDictionary alloc] init];
        for (NSString *Defaultname in AddressArr)
        {
            if ([[Defaultname valueForKey:@"isDefault"] isEqualToString:@"1"])
            {
                if ([Defaultname valueForKey:@"name"] != (id)[NSNull null])
                {
                    [DefaltAddressArr setObject:[Defaultname valueForKey:@"name"] forKey:@"name"];
                    //self.UserName_txt.text=[Defaultname valueForKey:@"name"];
                }
                else
                {
                    [DefaltAddressArr setObject:@"" forKey:@"name"];
                }
                
                if ([Defaultname valueForKey:@"email"] != (id)[NSNull null])
                {
                    [DefaltAddressArr setObject:[Defaultname valueForKey:@"email"] forKey:@"email"];
                }
                else
                {
                    [DefaltAddressArr setObject:@"" forKey:@"email"];
                }
                
                if ([Defaultname valueForKey:@"contact_number"] != (id)[NSNull null])
                {
                    [DefaltAddressArr setObject:[Defaultname valueForKey:@"contact_number"] forKey:@"contact_number"];
                }
                else
                {
                    [DefaltAddressArr setObject:@"" forKey:@"contact_number"];
                }
                
                if ([Defaultname valueForKey:@"pincode"] != (id)[NSNull null])
                {
                    [DefaltAddressArr setObject:[Defaultname valueForKey:@"pincode"] forKey:@"pincode"];
                }
                else
                {
                    [DefaltAddressArr setObject:@"" forKey:@"pincode"];
                }
                
                if ([Defaultname valueForKey:@"address"] != (id)[NSNull null])
                {
                    [DefaltAddressArr setObject:[Defaultname valueForKey:@"address"] forKey:@"address"];
                }
                else
                {
                    [DefaltAddressArr setObject:@"" forKey:@"address"];
                }
                
                if ([Defaultname valueForKey:@"city"] != (id)[NSNull null])
                {
                    [DefaltAddressArr setObject:[Defaultname valueForKey:@"city"] forKey:@"city"];
                }
                else
                {
                    [DefaltAddressArr setObject:@"" forKey:@"city"];
                }
            }
        }
        [TBL reloadData];
    }
    else
    {
        [self.AddressTBLView setHidden:YES];
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        
        if ([UserData count] != 0)
        {
            
            if ([UserData valueForKey:@"u_name"] != (id)[NSNull null])
            {
                self.UserName_txt.text=[UserData valueForKey:@"u_name"];
            }
            if ([UserData valueForKey:@"u_email"] != (id)[NSNull null])
            {
                self.UserEmail_txt.text=[UserData valueForKey:@"u_email"];
            }
            if ([UserData valueForKey:@"u_phone"] != (id)[NSNull null])
            {
                self.UserPhoneNo_txt.text=[UserData valueForKey:@"u_phone"];
            }
            if ([UserData valueForKey:@"u_pincode"] != (id)[NSNull null])
            {
                self.UserPincode_txt.text=[UserData valueForKey:@"u_pincode"] ;
            }
            if ([UserData valueForKey:@"u_address"] != (id)[NSNull null])
            {
                self.UserAddress_txt.text=[UserData valueForKey:@"u_address"] ;
            }
            if ([UserData valueForKey:@"u_city"] != (id)[NSNull null])
            {
                self.UserCity_txt.text=[UserData valueForKey:@"u_city"] ;
            }
            self.UserEmail_txt.enabled=NO;
            self.UserEmail_txt.textColor=[UIColor grayColor];
            
        }
    }
    
}
-(void)SetDefaultAddress :(NSString *)DeliveryAddress_idStr
{
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:SetDefautAddress  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:DeliveryAddress_idStr  forKey:@"delivery_address_id"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleSetDefaultAddress:response];
     }];
}

- (void)handleSetDefaultAddress:(NSDictionary*)response
{
    NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"result"] delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    [self getAddressData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f; // you can have your own choice, of course
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return AddressArr.count; // in your case, there are 3 cells
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecentAddress";
    RecentAddress *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    if ([[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"isDefault"] isEqualToString:@"1"])
    {
        cell.DefailtBTN.backgroundColor=DefaultBTNColor;
    }
    else
    {
        cell.DefailtBTN.backgroundColor=ButtonColor;
    }
    
    cell.Name_LBL.text=[NSString stringWithFormat:@"Name : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"name"]];
    cell.Address_LBL.text=[NSString stringWithFormat:@"Address : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"address"]];
    cell.Email_LBL.text=[NSString stringWithFormat:@"Email : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"email"]];
    cell.Contact_LBL.text=[NSString stringWithFormat:@"Contact Number : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"contact_number"]];
    
    
    cell.Edit_BTN.tag=indexPath.section;
    cell.DefailtBTN.tag=indexPath.section;
    
    [cell.Edit_BTN addTarget:self action:@selector(EditBTN_Click:) forControlEvents:UIControlEventTouchUpInside];
    [cell.DefailtBTN addTarget:self action:@selector(DefaultBTN_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(void)EditBTN_Click:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    CreateNewAddressView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateNewAddressView"];
    if (AddressArr.count>0)
    {
        vcr.CheckAddresscount=YES;
    }
    else
    {
        vcr.CheckAddresscount=NO;
    }
    vcr.AddressDic=[AddressArr objectAtIndex:btn.tag];
    [self.navigationController pushViewController:vcr animated:YES];
}

-(void)DefaultBTN_Click:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSLog(@"TAG==%ld",(long)btn.tag);
    
    [self SetDefaultAddress:[[AddressArr objectAtIndex:btn.tag] valueForKey:@"id"]];
}

- (IBAction)NextBtn_action:(id)sender
{
    self.NextBTN.enabled=NO;
    if (AddressArr.count==0)
    {
        if ([UserName_txt.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else if ([UserAddress_txt.text isEqualToString:@""])
        {
            
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Address" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else if ([UserPincode_txt.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Pincode" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else if ([UserEmail_txt.text isEqualToString:@""])
        {
            
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else if ([UserPhoneNo_txt.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Phone Number" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                //[self SendBillDetail];
                [self performSelector:@selector(SendBillDetail) withObject:self afterDelay:0.0 ];
            }
            else
            {
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
                self.NextBTN.enabled=YES;
            }
            
        }
    }
    else
    {
        if (DefaltAddressArr.count==0)
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Address is not selected" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self performSelector:@selector(SendBillDetail) withObject:self afterDelay:0.0 ];
            }
            else
            {
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
                self.NextBTN.enabled=YES;
            }
        }
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
    
    if (DefaltAddressArr.count==0)
    {
        [dictParams setObject:UserPincode_txt.text  forKey:@"u_pin"];
        [dictParams setObject:UserName_txt.text  forKey:@"u_name"];
        [dictParams setObject:UserEmail_txt.text  forKey:@"u_email"];
        [dictParams setObject:UserPhoneNo_txt.text  forKey:@"u_phone"];
        [dictParams setObject:UserAddress_txt.text  forKey:@"u_address"];
        [dictParams setObject:UserCity_txt.text  forKey:@"u_city"];
    }
    else
    {
        [dictParams setObject:[DefaltAddressArr valueForKey:@"pincode"]  forKey:@"u_pin"];
        [dictParams setObject:[DefaltAddressArr valueForKey:@"name"]  forKey:@"u_name"];
        [dictParams setObject:[DefaltAddressArr valueForKey:@"email"]  forKey:@"u_email"];
        [dictParams setObject:[DefaltAddressArr valueForKey:@"contact_number"]  forKey:@"u_phone"];
        [dictParams setObject:[DefaltAddressArr valueForKey:@"address"]  forKey:@"u_address"];
        [dictParams setObject:[DefaltAddressArr valueForKey:@"city"]  forKey:@"u_city"];
    }
   
    [dictParams setObject:@""  forKey:@"u_state"];
    [dictParams setObject:@""  forKey:@"u_country"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleBillProcessResponse:response];
     }];
}

- (void)handleBillProcessResponse:(NSDictionary*)response
{
   
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
       
        SelectPayment *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectPayment"];
        vcr.PayCart_ID=C_ID;
        vcr.PassDatefrom1=self.PassDateNTime;
        [self.navigationController pushViewController:vcr animated:NO];
        [AppDelegate showErrorMessageWithTitle:@"" message:[response objectForKey:@"ack_msg"] delegate:nil];
        self.NextBTN.enabled=YES;
        
    }
    else
    {
        self.NextBTN.enabled=YES;
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
