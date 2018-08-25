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




- (IBAction)HeaderReview_Click:(id)sender {
}
@end
