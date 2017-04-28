//
//  SearchByCategoryView.h
//  HalalMeatDelivery
//
//  Created by Mango Software Lab on 26/08/2016.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface SearchByShop : UIViewController<CCKFNavDrawerDelegate>
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (strong, nonatomic) IBOutlet UITableView *Table;

@property (strong, nonatomic) IBOutlet UIButton *Search_IMG;

- (IBAction)Search_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Searc_BTN;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;
- (IBAction)Menu_Click:(id)sender;

@end
