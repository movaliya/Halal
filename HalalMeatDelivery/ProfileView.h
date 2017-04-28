//
//  ProfileView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 05/09/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface ProfileView : UIViewController
{
    
}
- (IBAction)Back_click:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *Name_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Email_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Phone_TXT;
@property (strong, nonatomic) IBOutlet UITextField *PinCode_TXT;
@property (strong, nonatomic) IBOutlet UITextField *City_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Address_TXT;


@property (strong, nonatomic) IBOutlet UIButton *Update_BTN;
@property (strong, nonatomic) IBOutlet UIButton *ChangePass_BTN;

- (IBAction)Update_Click:(id)sender;
- (IBAction)ChangePass_Click:(id)sender;

@end
