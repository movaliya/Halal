//
//  GetHelpVW.m
//  HalalMeatDelivery
//
//  Created by Mango Lab on 20/08/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "GetHelpVW.h"

@interface GetHelpVW ()

@end

@implementation GetHelpVW

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BackBtn_Click:(id)sender
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
