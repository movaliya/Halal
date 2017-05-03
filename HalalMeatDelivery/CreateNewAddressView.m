//
//  CreateNewAddressView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 03/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "CreateNewAddressView.h"
#import "HalalMeatDelivery.pch"

@interface CreateNewAddressView ()

@end

@implementation CreateNewAddressView
@synthesize Submit_BTN,AddressDic;
@synthesize UserName_TXT,Email_TXT,Mobile_TXT,Post_TXT,Address_TXT,City_TXT;

- (void)viewDidLoad
{
    [super viewDidLoad];
    Submit_BTN.layer.cornerRadius=20;
    
    if (AddressDic.count>0)
    {
        [self SetaddressData];
    }
    
}

-(void)SetaddressData
{
    UserName_TXT.text=[AddressDic valueForKey:@"name"];
    Email_TXT.text=[AddressDic valueForKey:@"email"];
    Mobile_TXT.text=[AddressDic valueForKey:@"contact_number"];
    Post_TXT.text=[AddressDic valueForKey:@"pincode"];
    Address_TXT.text=[AddressDic valueForKey:@"address"];
    City_TXT.text=[AddressDic valueForKey:@"city"];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Submit_Click:(id)sender
{
    
}


-(void)AddAddressData
{
    //http://bulkbox.in/feedmemeat/service/service_general.php?r_p=1224&service=create_new_delivery_address&uid=1&name=Jai&address=402ajsdlksj&email=ajk@gmail.com&contact_number=9978078494&city=Vervala&state=punjab&country=India&pincode=336005&isDefault=1
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:getFilterServiceName  forKey:@"service"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleGetFilterResponse:response];
     }];
}

- (void)handleGetFilterResponse:(NSDictionary*)response
{
    NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        
    }
    else
    {
        
    }
}

@end
