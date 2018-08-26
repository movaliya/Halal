//
//  HHContentTableView.h
//  HHHorizontalPagingView
//
//  Created by Huanhoo on 15/7/16.
//  Copyright (c) 2015年 Huanhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHContentTableViewDelegate <NSObject>

-(void)AddToCardClick:(id)Sender;
-(void)PlushClick:(id)Sender;
-(void)MinushClick:(id)Sender;


-(void)updateScroll;

@end

@interface HHContentTableView : UITableView<HHContentTableViewDelegate>
{
    
}
@property (strong, nonatomic) NSMutableArray *Cat_Arr,*ItemDic,*MainCount,*LoadArr,*arrData;

@property ( nonatomic, assign) NSInteger expandedSectionHeaderNumber;

+ (HHContentTableView *)contentTableView;
@property (strong, nonatomic) id<HHContentTableViewDelegate> delegaterr;

@end
