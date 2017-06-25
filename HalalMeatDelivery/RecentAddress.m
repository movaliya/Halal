//
//  RecentAddress.m
//  HalalMeatDelivery
//
//  Created by kaushik on 25/06/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "RecentAddress.h"

@implementation RecentAddress
@synthesize Edit_BTN,DefailtBTN;
- (void)awakeFromNib {
    [super awakeFromNib];
    Edit_BTN.layer.cornerRadius=5;
    DefailtBTN.layer.cornerRadius=5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
