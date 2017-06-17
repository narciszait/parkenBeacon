//
//  Scenario2.h
//  ParkenBeacon
//
//  Created by Narcis Zait on 14/04/2017.
//  Copyright © 2017 Narcis Zait. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JAALEEBeaconSDK/JAALEEBeaconIOSSDK.h>

#define ESTIMOTE_UUID   [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]

static NSString * const kIdentifier = @"ParkenBeacon";

@interface Scenario2 : UIViewController <JLEBeaconManagerDelegate>

@end

