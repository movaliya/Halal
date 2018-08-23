//
//  RestHeaderCell.m
//  HalalMeatDelivery
//
//  Created by kaushik on 22/08/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "RestHeaderCell.h"

@implementation RestHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)ReviewCount:(NSString*)stars
{
    NSLog(@"stars=%@",stars);
    static NSString *CellIdentifier = @"RestHeaderCell";
    RestHeaderCell *cell ;
    if ([stars integerValue]<=5)
    {
        if ([stars integerValue]==0) {
            self.star1.image=[UIImage imageNamed:@"DisableWhiteStar"];
            self.star2.image=[UIImage imageNamed:@"DisableWhiteStar"];
            self.star3.image=[UIImage imageNamed:@"DisableWhiteStar"];
            self.star4.image=[UIImage imageNamed:@"DisableWhiteStar"];
            self.star5.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==1) {
            self.star1.image=[UIImage imageNamed:@"WhiteStat"];
            self.star2.image=[UIImage imageNamed:@"DisableWhiteStar"];
            self.star3.image=[UIImage imageNamed:@"DisableWhiteStar"];
            self.star4.image=[UIImage imageNamed:@"DisableWhiteStar"];
            self.star5.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==2) {
            self.star1.image=[UIImage imageNamed:@"WhiteStat"];
            self.star2.image=[UIImage imageNamed:@"WhiteStat"];
            self.star3.image=[UIImage imageNamed:@"DisableWhiteStar"];
            self.star4.image=[UIImage imageNamed:@"DisableWhiteStar"];
            self.star5.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==3) {
            self.star1.image=[UIImage imageNamed:@"WhiteStat"];
            self.star2.image=[UIImage imageNamed:@"WhiteStat"];
            self.star3.image=[UIImage imageNamed:@"WhiteStat"];
            self.star4.image=[UIImage imageNamed:@"DisableWhiteStar"];
            self.star5.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==4) {
            self.star1.image=[UIImage imageNamed:@"WhiteStat"];
            self.star2.image=[UIImage imageNamed:@"WhiteStat"];
            self.star3.image=[UIImage imageNamed:@"WhiteStat"];
            self.star4.image=[UIImage imageNamed:@"WhiteStat"];
            self.star5.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==5) {
            self.star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"FullStar"];
            self.star4.image=[UIImage imageNamed:@"FullStar"];
            self.star5.image=[UIImage imageNamed:@"FullStar"];
        }
    }
}
@end
