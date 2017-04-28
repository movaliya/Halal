
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
static dispatch_once_t predicate;


@interface SearchByShop ()<CLLocationManagerDelegate,UIScrollViewDelegate,UISearchBarDelegate>
{
    NSDictionary *DataDic;
    CLLocationManager *locationManager;
    double Latitude,Logitude;
    NSInteger limit_only,NoResponseInt;
    
    NSMutableArray *resultObjectsArray;
    NSMutableArray *SearchDictnory,*NewArr;
}
@property AppDelegate *appDelegate;
@end

@implementation SearchByShop
@synthesize Table;
@synthesize SearchBar,Search_IMG,Searc_BTN;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    limit_only=0;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
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
    return SearchDictnory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantDetailView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantDetailView"];
     vcr.R_ID=[[SearchDictnory valueForKey:@"id"]objectAtIndex:indexPath.row];
    vcr.Pin=[[SearchDictnory valueForKey:@"pin"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vcr animated:YES];
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
        [SearchBar resignFirstResponder];
        
        SearchDictnory=[NewArr mutableCopy];
        [Table reloadData];
    }
    else
    {
        Searc_BTN.selected=YES;
        [Search_IMG setImage:[UIImage imageNamed:@"Cross"] forState:UIControlStateNormal];
        SearchBar.hidden=NO;
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


@end
