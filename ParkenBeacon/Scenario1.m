//
//  Scenario1.m
//  ParkenBeacon
//
//  Created by Narcis Zait on 14/04/2017.
//  Copyright © 2017 Narcis Zait. All rights reserved.
//

#import "Scenario1.h"

@interface Scenario1 ()
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@property (nonatomic, strong) JLEBeaconManager  *beaconManager;
@property (nonatomic, strong) JLEBeaconRegion  *beaconRegion;

@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;

@end

@implementation Scenario1

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.leftBarButtonItem = done;
    
    self.qrCodeImageView.alpha = 0.0;
    
    self.beaconManager = [[JLEBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    self.beaconRegion = [[JLEBeaconRegion alloc] initWithProximityUUID:JAALEE_PROXIMITY_UUID major:1 minor:2 identifier:kIdentifier];
    
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
}

-(void)beaconManager:(JLEBeaconManager *)manager didEnterRegion:(JLEBeaconRegion *)region {
    if ([region.identifier isEqualToString:kIdentifier]){
        [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
        region.notifyOnEntry = YES;
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = @"Welcome to Telia Parken!";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        NSLog(@"inside 2");
    }
}

-(void)beaconManager:(JLEBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(JLEBeaconRegion *)region {
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    if ([region.identifier isEqualToString:kIdentifier]) {
        if (beacons.count != 0) {
            JLEBeacon *temp = [beacons firstObject];
    
            switch (temp.proximity) {
                case CLProximityFar: {
                    self.zoneLabel.text = @"Far";
                    break;
                }
                case CLProximityNear: {
                    self.zoneLabel.text = @"Welcome to Telia Parken!";
                    break;
                }
                case CLProximityImmediate: {
                    self.zoneLabel.text = @"Immediate";
                    break;
                }
                default: {
                    self.zoneLabel.text = @"";
                    break;
                }
            }
        }
    }
}

-(void)beaconManager:(JLEBeaconManager *)manager didExitRegion:(JLEBeaconRegion *)region {
    UILocalNotification *notification = [UILocalNotification new];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertBody = @"As a loyal football fan, we would like to offer you 20 DKK discount on any food purchase";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    region.notifyOnExit = YES;
    
    self.zoneLabel.text = @"As a loyal football fan, we would like to offer you 20 DKK discount on any food purchase";
    
    [UIView animateWithDuration:1.0 animations:^(void) {
        self.qrCodeImageView.alpha = 1.0;
    }];
    
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
}

-(void)doneButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.beaconManager stopMonitoringForRegion:self.beaconRegion];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
