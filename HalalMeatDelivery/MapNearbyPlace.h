//
//  MapNearbyPlace.h
//  Halal Meat Delivery
//
//  Created by kaushik on 21/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HalalMeatDelivery.pch"
@interface MapNearbyPlace : UIViewController<CCKFNavDrawerDelegate>
{
    NSMutableDictionary *NearbydictParams;
    NSString *LATITUDESTR,*LONGITUDESTR;
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@end
