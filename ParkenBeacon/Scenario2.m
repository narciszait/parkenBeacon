//
//  Scenario2.m
//  ParkenBeacon
//
//  Created by Narcis Zait on 14/04/2017.
//  Copyright © 2017 Narcis Zait. All rights reserved.
//

#import "Scenario2.h"

@interface Scenario2 ()

@property (nonatomic) bool ticketValid;
@property (weak, nonatomic) IBOutlet UIImageView *ticketImageView;

@property (nonatomic, strong) JLEBeaconManager  *beaconManager;
@property (nonatomic, strong) JLEBeaconRegion  *beaconRegion;

@property (weak, nonatomic) IBOutlet UILabel *ticketNumber;

@end

@implementation Scenario2

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.leftBarButtonItem = done;

    self.ticketValid = NO;
    
    self.beaconManager = [[JLEBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    self.beaconRegion = [[JLEBeaconRegion alloc] initWithProximityUUID:JAALEE_PROXIMITY_UUID major:1 minor:2 identifier:kIdentifier];
    
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
}

-(void)beaconManager:(JLEBeaconManager *)manager didEnterRegion:(JLEBeaconRegion *)region {
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)beaconManager:(JLEBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(JLEBeaconRegion *)region {
    if ([region.identifier isEqualToString:kIdentifier]) {
        if (beacons.count != 0) {
            if ([self.ticketNumber.text isEqualToString:@"(00) 0 0123456 000000001 8"]) {
                self.ticketValid = YES;
                
                JLEBeacon *temp = [beacons firstObject];
                self.ticketNumber.text = @"Welcome to Telia Parken!";
                
                switch (temp.proximity) {
                    case CLProximityFar:
                        break;
                    case CLProximityNear: {
                        UILocalNotification *notification = [UILocalNotification new];
                        notification.soundName = UILocalNotificationDefaultSoundName;
                        notification.alertBody = @"Welcome to Telia Parken! Your ticket is valid, please continue!";
                        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                        
                        self.ticketNumber.text = @"Ticket valid";
                    }
                    case CLProximityImmediate:
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

-(void)beaconManager:(JLEBeaconManager *)manager didExitRegion:(JLEBeaconRegion *)region {
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"As a loyal footbal fan, we would like to offer you 20 DKK discount on any food purchase";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    self.ticketNumber.text = @"As a loyal footbal fan, we would like to offer you 20 DKK discount on any food purchase";
    
    if (self.ticketValid){
        self.ticketImageView.image = [UIImage imageNamed:@"qr"];
    }
    
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
