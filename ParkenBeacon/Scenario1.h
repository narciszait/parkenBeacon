//
//  Scenario1.h
//  ParkenBeacon
//
//  Created by Narcis Zait on 14/04/2017.
//  Copyright © 2017 Narcis Zait. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JAALEEBeaconSDK/JAALEEBeaconIOSSDK.h>

static NSString * const kIdentifier = @"ParkenBeacon";
static NSString * const kEstimote = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";

@interface Scenario1 : UIViewController <JLEBeaconManagerDelegate>

@end
