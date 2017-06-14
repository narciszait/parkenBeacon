//
//  Scenario3.h
//  ParkenBeacon
//
//  Created by Narcis Zait on 14/04/2017.
//  Copyright © 2017 Narcis Zait. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JAALEEBeaconSDK/JAALEEBeaconIOSSDK.h>


static NSString * const region1 = @"clue1";
static NSString * const region2 = @"clue2";
static NSString * const region3 = @"clue3";

@interface Scenario3 : UIViewController <JLEBeaconManagerDelegate>

@end
