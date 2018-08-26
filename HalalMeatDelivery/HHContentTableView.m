//
//  HHContentTableView.m
//  HHHorizontalPagingView
//
//  Created by Huanhoo on 15/7/16.
//  Copyright (c) 2015年 Huanhoo. All rights reserved.
//

#import "HHContentTableView.h"
#import "ProductDetailCell.h"
#import "UIImageView+WebCache.h"

static int const kHeaderSectionTag = 6900;


@interface HHContentTableView ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableViewHeaderFooterView *expandedSectionHeader;

}
@end

@implementation HHContentTableView
@synthesize Cat_Arr,ItemDic,MainCount,LoadArr,arrData;
@synthesize expandedSectionHeaderNumber;

+ (HHContentTableView *)contentTableView
{
    HHContentTableView *contentTV = [[HHContentTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    contentTV.backgroundColor = [UIColor clearColor];
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    contentTV.bounces=NO;
    
    contentTV.expandedSectionHeaderNumber = -1;

    
    contentTV.Cat_Arr=[[NSMutableArray alloc]init];
    contentTV.ItemDic=[[NSMutableArray alloc]init];
    contentTV.MainCount=[[NSMutableArray alloc]init];
    contentTV.LoadArr=[[NSMutableArray alloc]init];
    contentTV.arrData=[[NSMutableArray alloc]init];
    
    
    UINib *nib = [UINib nibWithNibName:@"ProductDetailCell" bundle:nil];
    [contentTV registerNib:nib forCellReuseIdentifier:@"ProductDetailCell"];
    
    
    return contentTV;
}

#pragma mark
#pragma mark - Table view data source
#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return 75.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40.0;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (Cat_Arr.count > 0)
    {
        self.backgroundView = nil;
        return Cat_Arr.count;
    }
    return 0;
    //    else
    //    {
    //        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //
    //        messageLabel.text = @"Retrieving data.\nPlease wait.";
    //        messageLabel.numberOfLines = 0;
    //        messageLabel.textAlignment = NSTextAlignmentCenter;
    //        messageLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    //        [messageLabel sizeToFit];
    //        self.TBL.backgroundView = messageLabel;
    //
    //        return 0;
    //    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (expandedSectionHeaderNumber == section)
    {
        return ItemDic.count;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (Cat_Arr.count)
    {
        return [Cat_Arr objectAtIndex:section];
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductDetailCell"];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProductDetailCell"];
    }
    
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.PlushView.hidden=YES;
    cell.Update_View.hidden=YES;
    cell.Close_BTN.hidden=YES;
    cell.Close_IMG.hidden=YES;
    cell.Plush_BTN.tag=indexPath.row;
    cell.Minush_BTN.tag=indexPath.row;
    
    
    cell.RestQuatityLBL.text=[[MainCount objectAtIndex:0] objectAtIndex:indexPath.row];
    cell.TitleTriling.constant=0;
    
    
    
    [cell.AddCart_BTN addTarget:self action:@selector(AddToCardClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.AddCart_BTN.tag=indexPath.row;
    NSLog(@"ddd===%ld",(long)indexPath.row);
    
    [cell.RestPlusBtn addTarget:self action:@selector(PlushClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.RestPlusBtn.tag=indexPath.row;
    [cell.RestMinuBTN addTarget:self action:@selector(MinushClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.RestMinuBTN.tag=indexPath.row;
    
    LoadArr = [[arrData objectAtIndex:tableView.tag] mutableCopy];
    
    NSDictionary *section = [ItemDic  objectAtIndex:indexPath.section];
    cell.Title_LBL.text = [section valueForKey:@"name"];
    
    cell.Price_LBL.text=[NSString stringWithFormat:@"£%@",[[LoadArr valueForKey:@"sell_price"] objectAtIndex:indexPath.row]];
    cell.Cat_LBL.text=[[LoadArr valueForKey:@"category"] objectAtIndex:indexPath.row];
    
    NSString *Urlstr=[[LoadArr valueForKey:@"image_path"] objectAtIndex:indexPath.row];
    Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [cell.item_IMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.item_IMG setShowActivityIndicatorView:YES];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    if (indexPath.row == LoadArr.count-1)
    {
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // recast your view as a UITableViewHeaderFooterView
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithRed:184.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    
    header.textLabel.textColor = [UIColor whiteColor];
    UIImageView *viewWithTag = [self viewWithTag:kHeaderSectionTag + section];
    if (viewWithTag)
    {
        [viewWithTag removeFromSuperview];
    }
    // add the arrow image
    CGSize headerFrame = self.frame.size;
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerFrame.width - 32, 13, 18, 18)];
    theImageView.image = [UIImage imageNamed:@"Tbl_Arrow_white"];
    theImageView.tag = kHeaderSectionTag + section;
    [header addSubview:theImageView];
    
    // make headers touchable
    header.tag = section;
    UITapGestureRecognizer *headerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionItems:)];
    [header addGestureRecognizer:headerTapGesture];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.0f);
}

- (void)updateTableViewRowDisplay:(NSArray *)arrayOfIndexPaths
{
    [self beginUpdates];
    [self deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
    [self endUpdates];
}

#pragma mark - Expand / Collapse Methods

- (void)sectionItems:(UITapGestureRecognizer *)sender
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)sender.view;
    NSInteger section = headerView.tag;
    UIImageView *eImageView = (UIImageView *)[headerView viewWithTag:kHeaderSectionTag + section];
    expandedSectionHeader = headerView;
    
    if (expandedSectionHeaderNumber == -1)
    {
        expandedSectionHeaderNumber = section;
        [self tableViewExpandSection:section withImage: eImageView];
    }
    else
    {
        if (expandedSectionHeaderNumber == section)
        {
            [self tableViewCollapeSection:section withImage: eImageView];
            expandedSectionHeader = nil;
        }
        else
        {
            UIImageView *cImageView  = (UIImageView *)[self viewWithTag:kHeaderSectionTag + expandedSectionHeaderNumber];
            [self tableViewCollapeSection:expandedSectionHeaderNumber withImage: cImageView];
            [self tableViewExpandSection:section withImage: eImageView];
        }
    }
}

- (void)tableViewCollapeSection:(NSInteger)section withImage:(UIImageView *)imageView
{
    NSArray *sectionData = ItemDic;
    
    expandedSectionHeaderNumber = -1;
    if (sectionData.count == 0)
    {
        return;
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((0.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self endUpdates];
    }
    [self.delegaterr updateScroll];
}

- (void)tableViewExpandSection:(NSInteger)section withImage:(UIImageView *)imageView
{
    NSArray *sectionData = ItemDic;
    
    if (sectionData.count == 0)
    {
        expandedSectionHeaderNumber = -1;
        return;
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((180.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++)
        {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        expandedSectionHeaderNumber = section;
        [self beginUpdates];
        [self insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self endUpdates];
    }
    [self.delegaterr updateScroll];
}

-(void)AddToCardClick:(id)Sender
{
    [self.delegaterr AddToCardClick:Sender];
}

-(void)PlushClick:(id)Sender
{
    [self.delegaterr PlushClick:Sender];
}

-(void)MinushClick:(id)Sender
{
    [self.delegaterr MinushClick:Sender];
}

@end
