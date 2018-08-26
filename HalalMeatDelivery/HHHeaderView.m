//
//  HHHeaderView.m
//  HHHorizontalPagingView
//
//  Created by Huanhoo on 15/7/16.
//  Copyright (c) 2015年 Huanhoo. All rights reserved.
//

#import "HHHeaderView.h"
#import "HalalMeatDelivery.pch"
#import "UIImageView+WebCache.h"


@implementation HHHeaderView
{
    UIImageView *ImgVW;
}

@synthesize RestraorntDic,ImageScroll,PageCont;

+ (HHHeaderView *)headerView
{
    HHHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"HHHeaderView" owner:self options:nil][0];
    return headerView;
}




- (IBAction)HeaderReview_Click:(id)sender
{
}
-(void)ReviewCount:(NSString*)stars
{
    NSLog(@"stars=%@",stars);
    
    if ([stars integerValue]<=5)
    {
        if ([stars integerValue]==0) {
            self.star1.image=[UIImage imageNamed:@"HalStar"];
            self.star2.image=[UIImage imageNamed:@"HalStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==1) {
            self.star1.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star2.image=[UIImage imageNamed:@"HalStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==2) {
            self.star1.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star2.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==3) {
            self.star1.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star2.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star3.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==4) {
            self.star1.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star2.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star3.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star4.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==5) {
            self.star1.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star2.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star3.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star4.image=[UIImage imageNamed:@"WhiteFullHeart"];
            self.star5.image=[UIImage imageNamed:@"WhiteFullHeart"];
        }
    }
}
@end
