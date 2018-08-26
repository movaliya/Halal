//
//  HHHeaderView.h
//  HHHorizontalPagingView
//
//  Created by Huanhoo on 15/7/16.
//  Copyright (c) 2015年 Huanhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHHeaderView : UIView
{
    
}
@property (nonatomic, strong) NSMutableDictionary *RestraorntDic;
@property (strong, nonatomic) IBOutlet UILabel *HeaderTitle_LBL;
@property (strong, nonatomic) IBOutlet UILabel *HeaderDesc_LBL;
@property (strong, nonatomic) IBOutlet UILabel *HeaderReview_LBL;
@property (strong, nonatomic) IBOutlet UIButton *ReviewBTN;


@property (strong, nonatomic) IBOutlet UIScrollView *ImageScroll;
@property (strong, nonatomic) IBOutlet UIPageControl *PageCont;

@property (nonatomic, weak) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
-(void)ReviewCount:(NSString*)stars;

@property (strong, nonatomic) IBOutlet UIButton *BackBTN;
@property (strong, nonatomic) IBOutlet UIButton *MapBTN;


+ (HHHeaderView *)headerView;

@end
