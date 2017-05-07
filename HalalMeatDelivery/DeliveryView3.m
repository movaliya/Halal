//
//  DeliveryView3.m
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "DeliveryView3.h"
#import "ThankYouView.h"
#import "ShoppingCartView.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeView.h"

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentNoNetwork


@interface DeliveryView3 ()
{
    ThankYouView *ThankPOPUp;
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@property (strong, nonatomic) UIButton *ThanksOK;
@end

@implementation DeliveryView3
@synthesize ThanksOK;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
}

#pragma mark - PAYPAL Deledate
- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

- (void)setPayPalEnvironment:(NSString *)environment
{
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

-(void)Set_up_payPalConfig
{
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    _payPalConfig.acceptCreditCards = YES;
#else
    _payPalConfig.acceptCreditCards = NO;
#endif
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // use default environment, should be Production in real life
    self.environment = @"sandbox";
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //PayConfig
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self Set_up_payPalConfig];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
    
    
    _SubTotal_LBL.text=[NSString stringWithFormat:@"£ %@",[self.ChargesDICNORY3 valueForKey:@"sub_total"]];
    _ShippingCharge_LBL.text= [NSString stringWithFormat:@"+ £ %@",[self.ChargesDICNORY3 valueForKey:@"shipping_charge"]];
    _ShippingDiscount_LBL.text=[NSString stringWithFormat:@"- £ %@",[self.ChargesDICNORY3 valueForKey:@"shipping_discount"]];
    _Grand_Total_LBL.text=[NSString stringWithFormat:@"£ %@",[self.ChargesDICNORY3 valueForKey:@"final_total"]];
    final_total=[NSString stringWithFormat:@"%@",[self.ChargesDICNORY3 valueForKey:@"final_total"]];
    _DileveryDateTimeLBL.text=self.DateNTimeSTR;
    
    
    
    ThankPOPUp =[[[NSBundle mainBundle]loadNibNamed:@"ThankYouView" owner:nil options:nil]firstObject];
    ThankPOPUp.frame =self.view.frame;
    [self.view addSubview:ThankPOPUp];
    ThankPOPUp.hidden=YES;
    
}
- (IBAction)PlaceOrderBtn_action:(id)sender
{
    if ([self.PAYMENT_STR isEqualToString:@"2"])
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self payByPayPAl];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
            NSString *User_UID=[UserData valueForKey:@"u_id"];
            
            NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
            [dictParams setObject:r_p  forKey:@"r_p"];
            [dictParams setObject:place_order_part_3_delivery_codServiceName  forKey:@"service"];
            [dictParams setObject:User_UID  forKey:@"uid"];
            [dictParams setObject:self.CartID_DEL3  forKey:@"cid"];
            
            [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
             {
                 [self handlePlaceOrderResponse:response];
             }];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        
    }
}
-(void)payByPayPAl
{
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    NSLog(@"final_total=%@",final_total);
    PayPalItem *item1 = [PayPalItem itemWithName:@"Feed Me Meat Order"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:final_total]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    NSLog(@"kaushik===%@",paymentDetails);
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    NSString *shortDesp=[NSString stringWithFormat:@"Order Id: %@",self.CartID_DEL3];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = shortDesp;
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails;
    
    
    // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable)
    {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
    //NSLog(@"asdasd===%hhd",acceptCreditCards);
    [self presentViewController:paymentViewController animated:YES completion:nil];
}
- (void)handlePlaceOrderResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"QUANTITYCOUNT"];
        [self ShowPOPUP];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    paypalInfoDic=[completedPayment.confirmation valueForKey:@"response"];
    
    if([completedPayment.confirmation valueForKey:@"response_type"])
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self proof_of_payment];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        
    }
}

-(void)proof_of_payment
{
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSString *status_code;
    NSString *failure_message;
    if ([[paypalInfoDic valueForKey:@"state"] isEqualToString:@"approved"])
    {
        status_code=@"1";
        failure_message=@"";
    }
    else
    {
        status_code=@"0";
        failure_message=@"unsuccessful";
    }
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:place_order_part_3_delivery_online_payment  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:self.CartID_DEL3  forKey:@"cid"];
    
    // Payment Detail
    [dictParams setObject:status_code  forKey:@"status_code"];
    [dictParams setObject:[paypalInfoDic valueForKey:@"id"]  forKey:@"tracking_id"];
    [dictParams setObject:@"paypal"  forKey:@"payment_method"];
    [dictParams setObject:[paypalInfoDic valueForKey:@"state"]  forKey:@"order_status"];
    [dictParams setObject:failure_message  forKey:@"failure_message"];
    [dictParams setObject:@"USD"  forKey:@"currency"];
    [dictParams setObject:final_total  forKey:@"amount"];
    
    NSLog(@"PaypalDetalDic=%@",dictParams);
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handlePlacePayPalOrderResponse:response];
     }];
}

- (void)handlePlacePayPalOrderResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"QUANTITYCOUNT"];
        [self ShowPOPUP];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    NSLog(@"PayPal Future Payment Authorization Success!");
    self.resultText = [futurePaymentAuthorization description];
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    NSLog(@"PayPal Future Payment Authorization Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}

#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    self.resultText = [profileSharingAuthorization description];
    
    [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}

#pragma mark - pop AlertView;

-(void)ShowPOPUP
{
    [ThankPOPUp bringSubviewToFront:self.view];
    ThankPOPUp.hidden=NO;
    
    ThanksOK= (UIButton *)[ThankPOPUp viewWithTag:23];
    ThanksOK.layer.cornerRadius=3.5;
    [ThanksOK addTarget:self action:@selector(ThanksOK_Click:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
