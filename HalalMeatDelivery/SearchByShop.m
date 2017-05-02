
//
//  SearchByCategoryView.m
//  HalalMeatDelivery
//
//  Created by Mango Software Lab on 26/08/2016.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "SearchByShop.h"
#import "HalalMeatDelivery.pch"
#import "SearchByCatCell.h"
#import "UIImageView+WebCache.h"
#import "NearByView.h"
#import "NearByCell.h"
#import "RestaurantDetailView.h"
#import <CoreLocation/CoreLocation.h>
#import "CategoryCell.h"

static dispatch_once_t predicate;

#define SelectedButtonColor [UIColor colorWithRed:169.0f/255.0f green:32.0f/255.0f blue:40.0f/255.0f alpha:1.0f]
#define UnSelectedButtonColor [UIColor colorWithRed:101.0f/255.0f green:100.0f/255.0f blue:98.0f/255.0f alpha:1.0f]

@interface SearchByShop ()<CLLocationManagerDelegate,UIScrollViewDelegate,UISearchBarDelegate>
{
    NSDictionary *DataDic;
    CLLocationManager *locationManager;
    double Latitude,Logitude;
    NSInteger limit_only,NoResponseInt;
    
    NSMutableArray *resultObjectsArray;
    NSMutableArray *SearchDictnory,*NewArr;
    
    NSMutableArray *CatArr,*CatselectedArr;
    NSMutableArray *DistanceArr,*DistanceSelectArr;
    NSMutableArray *FreeDelArr,*FreeDelSelectArr;
    NSMutableArray *ReviewStarArr,*ReviewStarSelectArr;
    NSMutableArray *SortByPriceArr;
    NSInteger SelectedShort;
    NSMutableDictionary *FilterDict;
    
    NSMutableArray *filter_idArry;
    
    NSMutableArray *catParsingArr;
    NSMutableArray *PriceParsingArr;
    NSMutableArray *RatingParsingArr;
    NSMutableArray *DistanceParsingArr;
    NSMutableArray *FreDelParsingArr;
    
}
@property AppDelegate *appDelegate;
@end

@implementation SearchByShop
@synthesize Table,Filter_BTN;
@synthesize SearchBar,Search_IMG,Searc_BTN;
@synthesize FilterView,SearchByCatBTN,SearchByRatBTN,SearchByDistBTN,SearchByPriceBTN,FreeDelevBTN;
@synthesize CatTBL,PriceView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rangeSliderCurrency.hidden=YES;
    SelectedShort=0;
    CatTBL.hidden=NO;
    [SearchByCatBTN setBackgroundColor:SelectedButtonColor];
    [SearchByCatBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    FilterView.hidden=YES;
    // Getting Lat Log
    SearchDictnory=[[NSMutableArray alloc]init];
    NewArr=[[NSMutableArray alloc]init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];
     predicate = 0;
    [locationManager startUpdatingLocation];
    
    SearchBar.hidden=YES;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [SearchBar setImage:[UIImage imageNamed:@"SearchIcon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    self.appDelegate = [AppDelegate sharedInstance];
    
    
    UINib *nib = [UINib nibWithNibName:@"NearByCell" bundle:nil];
    NearByCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table.rowHeight = cell.frame.size.height;
    [Table registerNib:nib forCellReuseIdentifier:@"NearByCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"CategoryCell" bundle:nil];
    CategoryCell *cell2 = [[nib2 instantiateWithOwner:nil options:nil] objectAtIndex:0];
    CatTBL.rowHeight = cell2.frame.size.height;
    [CatTBL registerNib:nib2 forCellReuseIdentifier:@"CategoryCell"];
    
    limit_only=0;
    // Do any additional setup after loading the view.
    [self getFilterData];
    
    catParsingArr=[[NSMutableArray alloc]init];
    PriceParsingArr=[[NSMutableArray alloc]init];
    RatingParsingArr=[[NSMutableArray alloc]init];
    DistanceParsingArr=[[NSMutableArray alloc]init];
    FreDelParsingArr=[[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:NO];
}
-(void)getFilterData
{
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:getFilterServiceName  forKey:@"service"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleGetFilterResponse:response];
     }];
}
- (void)handleGetFilterResponse:(NSDictionary*)response
{
    NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        FilterDict=[response valueForKey:@"result"];
        filter_idArry=[[NSMutableArray alloc]init];
        filter_idArry=[FilterDict valueForKey:@"filter_id"];
        for (NSArray *filtername in FilterDict)
        {
            if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Search By Category"])
            {
                // Search By Category.
                CatArr=[[NSMutableArray alloc]init];
                CatArr=[filtername valueForKey:@"data"];
                CatselectedArr=[[NSMutableArray alloc]init];
                for (int i= 0; i<CatArr.count; i++)
                {
                    [CatselectedArr addObject:@"0"];
                }
            }
            else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Sort By Distance"])
            {
                // Search By Distance.
                DistanceArr=[[NSMutableArray alloc]init];
                DistanceArr=[filtername valueForKey:@"data"];
                DistanceSelectArr=[[NSMutableArray alloc]init];
                for (int i= 0; i<DistanceArr.count; i++)
                {
                    [DistanceSelectArr addObject:@"0"];
                }
            }
            else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Free Delivery"])
            {
                // Search By FreeDelivery.
                FreeDelArr=[[NSMutableArray alloc]init];
                FreeDelArr=[filtername valueForKey:@"data"];
                FreeDelSelectArr=[[NSMutableArray alloc]init];
                for (int i= 0; i<FreeDelArr.count; i++)
                {
                    [FreeDelSelectArr addObject:@"0"];
                }
            }
            else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Sort By Rating"])
            {
                // Search By FreeDelivery.
                ReviewStarArr=[[NSMutableArray alloc]init];
                ReviewStarArr=[filtername valueForKey:@"data"];
                ReviewStarSelectArr=[[NSMutableArray alloc]init];
                for (int i= 0; i<ReviewStarArr.count; i++)
                {
                    [ReviewStarSelectArr addObject:@"0"];
                }
            }
            else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Sort By Price"])
            {
                // Search By Range Bar.
                SortByPriceArr=[[NSMutableArray alloc]init];
                SortByPriceArr=[filtername valueForKey:@"data"];
            }
        }
       [CatTBL reloadData];
    }
    else
    {
       
    }
}
-(void)CallForSearchByShop
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:SerachByShopServiceName  forKey:@"service"];
    [dictParams setObject:[NSString stringWithFormat:@"%.8f", Latitude]  forKey:@"lat"];
    [dictParams setObject:[NSString stringWithFormat:@"%.8f", Logitude]  forKey:@"long"];
    [dictParams setObject:[NSString stringWithFormat:@"%ld", (long)limit_only]  forKey:@"limit_only"];
    NSLog(@"dictParams===%@",dictParams);
    
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,SerachByShop_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleCategoryResponse:response];
     }];
}

- (void)handleCategoryResponse:(NSDictionary*)response
{
    NSLog(@"response ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        DataDic=[response valueForKey:@"result"];
        for (NSDictionary *dic in DataDic)
        {
            //NSLog(@"===%@",dic);
            [SearchDictnory addObject:dic];
            
        }
        NewArr=[[NSMutableArray alloc]initWithArray:SearchDictnory];
        limit_only=limit_only+5;
        NoResponseInt=1;
        [Table reloadData];
    }
    else
    {
        NoResponseInt=0;
       // oldLimit_ony=limit_only;
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // in your case, there are 3 cells
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==CatTBL)
    {
        if (SelectedShort==0)
        {
            return CatArr.count;
        }
        else if (SelectedShort==2)
        {
            return ReviewStarArr.count;
        }
        else if (SelectedShort==3)
        {
            return DistanceArr.count;
        }
        else if (SelectedShort==4)
        {
            return FreeDelArr.count;
        }
        
    }
    return SearchDictnory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==CatTBL)
    {
        static NSString *CellIdentifier = @"CategoryCell";
        CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
        
        if (SelectedShort==0)
        {
            [cell.StarView setHidden:YES];
            [cell.CatTitle_LBL setHidden:NO];
           
            if ([[CatselectedArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                cell.CatIMG.image=[UIImage imageNamed:@"UnselectChkBox"];
            }
            else
            {
                cell.CatIMG.image=[UIImage imageNamed:@"SelectChkBox"];
            }
            
            cell.CatTitle_LBL.text=[[CatArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row];
        }
        if (SelectedShort==2)
        {
             [cell.StarView setHidden:NO];
             [cell.CatTitle_LBL setHidden:YES];
            
            if ([[ReviewStarSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                cell.CatIMG.image=[UIImage imageNamed:@"UnselectChkBox"];
            }
            else
            {
                cell.CatIMG.image=[UIImage imageNamed:@"SelectChkBox"];
            }
            if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]<=5)
            {
                NSLog(@"reviewStar=%@",[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]);
                
                if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]==5) {
                    [cell.Start1 setHidden:NO];
                    [cell.Start2 setHidden:NO];
                    [cell.Start3 setHidden:NO];
                    [cell.Start4 setHidden:NO];
                    [cell.Start5 setHidden:NO];
                   
                }
                if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]==4) {
                    [cell.Start1 setHidden:NO];
                    [cell.Start2 setHidden:NO];
                    [cell.Start3 setHidden:NO];
                    [cell.Start4 setHidden:NO];
                    [cell.Start5 setHidden:YES];
                }
                if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]==3) {
                    [cell.Start1 setHidden:NO];
                    [cell.Start2 setHidden:NO];
                    [cell.Start3 setHidden:NO];
                    [cell.Start4 setHidden:YES];
                    [cell.Start5 setHidden:YES];
                }
                if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]==2) {
                    [cell.Start1 setHidden:NO];
                    [cell.Start2 setHidden:NO];
                    [cell.Start3 setHidden:YES];
                    [cell.Start4 setHidden:YES];
                    [cell.Start5 setHidden:YES];
                }
                if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]==1) {
                    [cell.Start1 setHidden:NO];
                    [cell.Start2 setHidden:YES];
                    [cell.Start3 setHidden:YES];
                    [cell.Start4 setHidden:YES];
                    [cell.Start5 setHidden:YES];
                }
            }
            
        }
        else if (SelectedShort==3)
        {
             [cell.StarView setHidden:YES];
            [cell.CatTitle_LBL setHidden:NO];
            if ([[DistanceSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                cell.CatIMG.image=[UIImage imageNamed:@"UnselectChkBox"];
            }
            else
            {
                cell.CatIMG.image=[UIImage imageNamed:@"SelectChkBox"];
            }
            
            cell.CatTitle_LBL.text=[[DistanceArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row];
        }
        else if (SelectedShort==4)
        {
             [cell.StarView setHidden:YES];
            [cell.CatTitle_LBL setHidden:NO];
            if ([[FreeDelSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                cell.CatIMG.image=[UIImage imageNamed:@"UnselectChkBox"];
            }
            else
            {
                cell.CatIMG.image=[UIImage imageNamed:@"SelectChkBox"];
            }
            
            cell.CatTitle_LBL.text=[[FreeDelArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row];
        }
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"NearByCell";
        NearByCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
        NSString *Urlstr=[[SearchDictnory valueForKey:@"image_path"] objectAtIndex:indexPath.row];
        Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.Rest_IMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        [cell.Rest_IMG setShowActivityIndicatorView:YES];
        
        cell.RestNAME_LBL.text=[[SearchDictnory valueForKey:@"name"] objectAtIndex:indexPath.row];
        cell.Item_LBL.text=[[SearchDictnory valueForKey:@"serving_category"] objectAtIndex:indexPath.row];
        
        NSString *develveryOption=[[SearchDictnory valueForKey:@"delivery_option"] objectAtIndex:indexPath.row];
        
        if ([develveryOption isEqualToString:@"1"])
        {
            NSString *option=[[SearchDictnory valueForKey:@"min_delivery_amount"] objectAtIndex:indexPath.row];
            cell.Desc_LBL.text=[NSString stringWithFormat:@"Deliver Min :£%@",option];
            cell.Desc_LBL.textColor=[UIColor colorWithRed:(62/255.0) green:(124/255.0) blue:(77/255.0) alpha:1.0];
        }
        else
        {
            cell.Desc_LBL.text=@"Take away";
            cell.Desc_LBL.textColor=[UIColor colorWithRed:(204/255.0) green:(61/255.0) blue:(53/255.0) alpha:1.0];
        }
        
        
        cell.Review_LBL.text=[NSString stringWithFormat:@"(%@ Review)",[[SearchDictnory valueForKey:@"count_review"] objectAtIndex:indexPath.row]];
        cell.Dist_LBL.text=[NSString stringWithFormat:@" %@ ",[[SearchDictnory valueForKey:@"distance"] objectAtIndex:indexPath.row]] ;
        
        [cell ReviewCount:[[SearchDictnory valueForKey:@"count_review"] objectAtIndex:indexPath.row]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==CatTBL)
    {
        if (SelectedShort==0)
        {
            if ([[CatselectedArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                [CatselectedArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
                
                NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
                [fliterdic setObject:[[CatArr valueForKey:@"filter_value_id"] objectAtIndex:indexPath.row]  forKey:@"filter_value_id"];
                [fliterdic setObject:[[CatArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]  forKey:@"filter_value_name"];
                [fliterdic setObject:[[CatArr valueForKey:@"filter_value"] objectAtIndex:indexPath.row]  forKey:@"filter_value"];
                [fliterdic setObject:[filter_idArry objectAtIndex:0]  forKey:@"filter_id"];
                [catParsingArr addObject:fliterdic];
                
            }
            else
            {
                [CatselectedArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
            }

        }
        else if (SelectedShort==2)
        {
            if ([[ReviewStarSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                [ReviewStarSelectArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
                
                NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
                [fliterdic setObject:[[ReviewStarArr valueForKey:@"filter_value_id"] objectAtIndex:indexPath.row]  forKey:@"filter_value_id"];
                [fliterdic setObject:[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]  forKey:@"filter_value_name"];
                [fliterdic setObject:[[ReviewStarArr valueForKey:@"filter_value"] objectAtIndex:indexPath.row]  forKey:@"filter_value"];
                [fliterdic setObject:[filter_idArry objectAtIndex:2]  forKey:@"filter_id"];
                [RatingParsingArr addObject:fliterdic];
            }
            else
            {
                [ReviewStarSelectArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
            }
            
        }
        else if (SelectedShort==3)
        {
            if ([[DistanceSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                [DistanceSelectArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
                
                NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
                [fliterdic setObject:[[DistanceArr valueForKey:@"filter_value_id"] objectAtIndex:indexPath.row]  forKey:@"filter_value_id"];
                [fliterdic setObject:[[DistanceArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]  forKey:@"filter_value_name"];
                [fliterdic setObject:[[DistanceArr valueForKey:@"filter_value"] objectAtIndex:indexPath.row]  forKey:@"filter_value"];
                [fliterdic setObject:[filter_idArry objectAtIndex:3]  forKey:@"filter_id"];
                [DistanceParsingArr addObject:fliterdic];
            }
            else
            {
                [DistanceSelectArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
            }

        }
        else if (SelectedShort==4)
        {
            if ([[FreeDelSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                [FreeDelSelectArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
                
                NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
                [fliterdic setObject:[[FreeDelArr valueForKey:@"filter_value_id"] objectAtIndex:indexPath.row]  forKey:@"filter_value_id"];
                [fliterdic setObject:[[FreeDelArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]  forKey:@"filter_value_name"];
                [fliterdic setObject:[[FreeDelArr valueForKey:@"filter_value"] objectAtIndex:indexPath.row]  forKey:@"filter_value"];
                [fliterdic setObject:[filter_idArry objectAtIndex:4]  forKey:@"filter_id"];
                [FreDelParsingArr addObject:fliterdic];
            }
            else
            {
                [FreeDelSelectArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
            }
            
        }
        [CatTBL reloadData];
    }
    else
    {
        RestaurantDetailView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantDetailView"];
        vcr.R_ID=[[SearchDictnory valueForKey:@"id"]objectAtIndex:indexPath.row];
        vcr.Pin=[[SearchDictnory valueForKey:@"pin"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vcr animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"drag Call");
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= -2)
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            if (NoResponseInt==1) {
                 [self CallForSearchByShop];
            }
           
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        
    }
}

- (IBAction)Search_Click:(id)sender
{
    if (Searc_BTN.selected==YES)
    {
        Searc_BTN.selected=NO;
        [Search_IMG setImage:[UIImage imageNamed:@"SearchIcon.png"] forState:UIControlStateNormal];
        SearchBar.hidden=YES;
        Filter_BTN.hidden=NO;
        [SearchBar resignFirstResponder];
        
        SearchDictnory=[NewArr mutableCopy];
        [Table reloadData];
    }
    else
    {
        Searc_BTN.selected=YES;
        [Search_IMG setImage:[UIImage imageNamed:@"Cross"] forState:UIControlStateNormal];
        SearchBar.hidden=NO;
        Filter_BTN.hidden=YES;
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [AppDelegate showErrorMessageWithTitle:@"Warning." message:@"To re-enable, please go to Settings and turn on Location Service for this app." delegate:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
   
    if (currentLocation != nil)
    {
        
        Latitude= currentLocation.coordinate.latitude;
        Logitude= currentLocation.coordinate.longitude;
        
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            
            dispatch_once(&predicate, ^{
                //your code here
                [self CallForSearchByShop];
                 [locationManager stopUpdatingLocation];
                locationManager=nil;
            });
        }
        else
        {
            dispatch_once(&predicate, ^{
                //your code here
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
                [locationManager stopUpdatingLocation];
                locationManager=nil;
            });
        }
        
       
        NSLog(@"longitude=%.8f",currentLocation.coordinate.longitude);
        NSLog(@"latitude=%.8f",currentLocation.coordinate.latitude);
        
    }
    
}

- (IBAction)Menu_Click:(id)sender
{
    [self.rootNav drawerToggle];
}

#pragma mark - SerachBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    SearchDictnory=[[NSMutableArray alloc]initWithArray:NewArr];
    [SearchBar resignFirstResponder];
    [Table reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //SearchBar.showsCancelButton = YES;
    //MainScroll.hidden=YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // SearchBar.showsCancelButton = NO;
    //MainScroll.hidden=YES;
    //SearchDictnory=[MainDic mutableCopy];
    [Table reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        SearchDictnory=[NewArr mutableCopy];
        [Table reloadData];
        return;
    }
    
    resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in SearchDictnory)
    {
        NSString *wineName = [wine objectForKey:@"name"];
        NSRange range = [wineName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    SearchDictnory=[resultObjectsArray mutableCopy];
    NSLog(@"resultObjectsArray=%lu",(unsigned long)resultObjectsArray.count);
    NSLog(@"tempdict=%@",SearchDictnory);
    [Table reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if([searchBar.text isEqualToString:@""] || searchBar.text==nil)
    {
        SearchDictnory=[NewArr mutableCopy];
        [Table reloadData];
        return;
    }
    resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in SearchDictnory)
    {
        NSString *wineName = [wine objectForKey:@"name"];
        NSRange range = [wineName rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    SearchDictnory=[resultObjectsArray mutableCopy];
    NSLog(@"resultObjectsArray=%lu",(unsigned long)resultObjectsArray.count);
    NSLog(@"tempdict=%@",SearchDictnory);
    [Table reloadData];
    [SearchBar resignFirstResponder];
}


- (IBAction)Filter_click:(id)sender
{
    PriceView.hidden=YES;
    FilterView.hidden=NO;
    self.rangeSliderCurrency.hidden=YES;
    
    CatTBL.hidden=NO;
    SelectedShort=0;
    [SearchByCatBTN setBackgroundColor:SelectedButtonColor];
    [SearchByCatBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    SearchByPriceBTN.titleLabel.textColor=UnSelectedButtonColor;
    SearchByRatBTN.titleLabel.textColor=UnSelectedButtonColor;
    SearchByDistBTN.titleLabel.textColor=UnSelectedButtonColor;
    FreeDelevBTN.titleLabel.textColor=UnSelectedButtonColor;
    
    [SearchByPriceBTN setBackgroundColor:[UIColor clearColor]];
    [SearchByRatBTN setBackgroundColor:[UIColor clearColor]];
    [SearchByDistBTN setBackgroundColor:[UIColor clearColor]];
    [FreeDelevBTN setBackgroundColor:[UIColor clearColor]];
    
    
    NSInteger MaxRang=[[[SortByPriceArr valueForKey:@"filter_value_name"] objectAtIndex:0] integerValue];
    NSLog(@"MaxRang=%d",MaxRang);
    //currency range slider
    self.rangeSliderCurrency.delegate = self;
    self.rangeSliderCurrency.minValue = 0;
    self.rangeSliderCurrency.maxValue = MaxRang;
    self.rangeSliderCurrency.selectedMinimum = 0;
    self.rangeSliderCurrency.selectedMaximum = MaxRang;
    self.rangeSliderCurrency.handleColor = [UIColor colorWithRed:(185/255.0) green:(23/255.0) blue:(44/255.0) alpha:1.0];;
    self.rangeSliderCurrency.handleDiameter = 20;
    self.rangeSliderCurrency.selectedHandleDiameterMultiplier = 1;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
   // self.rangeSliderCurrency.numberFormatterOverride = formatter;
    [self.rangeSliderCurrency bringSubviewToFront:self.view];
}

- (IBAction)FilterBack_Ckick:(id)sender
{
    FilterView.hidden=YES;
}

- (IBAction)AllCatBTN_Click:(id)sender
{
    PriceView.hidden=YES;
    CatTBL.hidden=NO;
    self.rangeSliderCurrency.hidden=YES;
    if (sender==SearchByCatBTN)
    {
        SelectedShort=0;
        [SearchByCatBTN setBackgroundColor:SelectedButtonColor];
        [SearchByCatBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        SearchByPriceBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByRatBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByDistBTN.titleLabel.textColor=UnSelectedButtonColor;
        FreeDelevBTN.titleLabel.textColor=UnSelectedButtonColor;
        
        [SearchByPriceBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByRatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByDistBTN setBackgroundColor:[UIColor clearColor]];
        [FreeDelevBTN setBackgroundColor:[UIColor clearColor]];
        
    }
    else if (sender==SearchByPriceBTN)
    {
        SelectedShort=1;
        PriceView.hidden=NO;
        CatTBL.hidden=YES;
        self.rangeSliderCurrency.hidden=NO;
        
        [SearchByPriceBTN setBackgroundColor:SelectedButtonColor];
        [SearchByPriceBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        SearchByCatBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByRatBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByDistBTN.titleLabel.textColor=UnSelectedButtonColor;
        FreeDelevBTN.titleLabel.textColor=UnSelectedButtonColor;
        
        [SearchByCatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByRatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByDistBTN setBackgroundColor:[UIColor clearColor]];
        [FreeDelevBTN setBackgroundColor:[UIColor clearColor]];
        
    }
    else if (sender==SearchByRatBTN)
    {
        SelectedShort=2;
        
        [SearchByRatBTN setBackgroundColor:SelectedButtonColor];
        [SearchByRatBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        SearchByCatBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByPriceBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByDistBTN.titleLabel.textColor=UnSelectedButtonColor;
        FreeDelevBTN.titleLabel.textColor=UnSelectedButtonColor;
        
        [SearchByCatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByPriceBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByDistBTN setBackgroundColor:[UIColor clearColor]];
        [FreeDelevBTN setBackgroundColor:[UIColor clearColor]];
    }
    else if (sender==SearchByDistBTN)
    {
        SelectedShort=3;
        
        [SearchByDistBTN setBackgroundColor:SelectedButtonColor];
        [SearchByDistBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        SearchByCatBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByPriceBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByRatBTN.titleLabel.textColor=UnSelectedButtonColor;
        FreeDelevBTN.titleLabel.textColor=UnSelectedButtonColor;
        
        [SearchByCatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByPriceBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByRatBTN setBackgroundColor:[UIColor clearColor]];
        [FreeDelevBTN setBackgroundColor:[UIColor clearColor]];
    }
    else if (sender==FreeDelevBTN)
    {
        SelectedShort=4;
        
        [FreeDelevBTN setBackgroundColor:SelectedButtonColor];
        [FreeDelevBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        SearchByCatBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByPriceBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByRatBTN.titleLabel.textColor=UnSelectedButtonColor;
        SearchByDistBTN.titleLabel.textColor=UnSelectedButtonColor;
        
        [SearchByCatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByPriceBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByRatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByDistBTN setBackgroundColor:[UIColor clearColor]];
    }
    [CatTBL reloadData];
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum
{
    if (sender == self.rangeSliderCurrency)
    {
        NSLog(@"Currency slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        /*
        NSString *maxval=[NSString stringWithFormat:@"%.0f",selectedMaximum];
        NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
        [fliterdic setObject:[SortByPriceArr valueForKey:@"filter_value_id"]   forKey:@"filter_value_id"];
        [fliterdic setObject:maxval   forKey:@"filter_value_name"];
        [fliterdic setObject:[SortByPriceArr valueForKey:@"filter_value"]  forKey:@"filter_value"];
        [fliterdic setObject:[filter_idArry objectAtIndex:1]  forKey:@"filter_id"];
        [PriceParsingArr addObject:fliterdic];*/
        
    }
}

- (IBAction)ConfrimFliterBtn_action:(id)sender
{
    
    NSLog(@"filter_idArry=%@",filter_idArry);
    NSLog(@"cat=%@",catParsingArr);
    NSLog(@"RatingParsingArr=%@",RatingParsingArr);
    NSLog(@"RatingParsingArr=%@",RatingParsingArr);
    NSLog(@"FreDelParsingArr=%@",FreDelParsingArr);
    NSLog(@"PriceParsingArr=%@",PriceParsingArr);
    
}

- (IBAction)ClearFliterBtn_action:(id)sender
{
    
}
@end
