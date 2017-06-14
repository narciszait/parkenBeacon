//
//  Scenario3.m
//  ParkenBeacon
//
//  Created by Narcis Zait on 14/04/2017.
//  Copyright © 2017 Narcis Zait. All rights reserved.
//

#import "Scenario3.h"
#import "PulsingHaloLayer.h"

#define kMaxRadius 200
#define kMaxDuration 10
#define DOT_MIN_POS 20
#define DOT_MAX_POS screenHeight - 70;

@interface Scenario3 ()
@property (nonatomic, strong) JLEBeaconManager *beaconManager;
@property (nonatomic, strong) JLEBeaconRegion *beaconRegionForClue1;
@property (nonatomic, strong) JLEBeaconRegion *beaconRegionForClue2;
@property (nonatomic, strong) JLEBeaconRegion *beaconRegionForClue3;
@property (nonatomic, strong) JLEBeaconDevice *mSelectBeaconDevice;

@property (nonatomic, weak) PulsingHaloLayer *halo;
@property (nonatomic, weak) IBOutlet UIImageView *beaconView;
@property (nonatomic, strong) UIImageView* positionDot;
@property (weak, nonatomic) IBOutlet UILabel *clueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dotPositionLabel;

@property (nonatomic) float dotMinPos;
@property (nonatomic) float dotRange;



@end

@implementation Scenario3

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.leftBarButtonItem = done;
    
    PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    self.halo.haloLayerNumber = 5;
    self.halo.radius = 360;
    self.halo.animationDuration = 16;
    self.halo.backgroundColor = [UIColor colorWithRed:0 green:0.455 blue:0.756 alpha:1.0].CGColor;
    [self.beaconView.superview.layer insertSublayer:self.halo below:self.beaconView.layer];
    [self.halo start];
    
    self.beaconManager = [[JLEBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    self.beaconRegionForClue1 = [[JLEBeaconRegion alloc] initWithProximityUUID:JAALEE_PROXIMITY_UUID major:1 minor:2 identifier:region1];
    self.beaconRegionForClue2 = [[JLEBeaconRegion alloc] initWithProximityUUID:JAALEE_PROXIMITY_UUID major:1 minor:3 identifier:region2];
    self.beaconRegionForClue3 = [[JLEBeaconRegion alloc] initWithProximityUUID:JAALEE_PROXIMITY_UUID major:1 minor:4 identifier:region3];
    
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegionForClue1];
    
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegionForClue2];
    
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegionForClue3];
    
    self.positionDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotImage"]];
    self.positionDot.center = CGPointMake(self.view.frame.size.width / 2, self.dotMinPos);
    self.positionDot.alpha = 0;
    [self.view addSubview:self.positionDot];
    
    self.dotMinPos = 150;
    self.dotRange = 200;
    
    self.dotPositionLabel.text = [NSString stringWithFormat:@"x: %.02f y: %.02f", self.positionDot.frame.origin.x, self.positionDot.frame.origin.y]; //  @"";  //
    self.dotPositionLabel.alpha = 0.0;
    
    self.clueLabel.alpha = 0;
    self.clueLabel.text = @"";
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDebugLabel:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDebugLabel:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tripleTap];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.halo.position = self.beaconView.center;
}

-(void)beaconManager:(JLEBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(JLEBeaconRegion *)region {
    if ([region.identifier isEqualToString:region1]) {
        if (beacons.count != 0) {
            JLEBeacon *temp = [beacons firstObject];
            
            float distFactor = (-1) / ((float)temp.rssi);
            float newYPos = self.dotMinPos + distFactor * self.dotRange * 105;
            [UIView animateWithDuration:1.0 animations:^(void) {
                self.positionDot.center = CGPointMake(self.view.bounds.size.width / 2, newYPos);
                self.positionDot.alpha = 1.0;
            }];
            
            self.dotPositionLabel.text = [NSString stringWithFormat:@"x: %.02f y: %.02f %ld %f", self.positionDot.frame.origin.x, self.positionDot.frame.origin.y, (long)temp.rssi, temp.accuracy]; // @"";  //
            
            switch (temp.proximity) {
                case CLProximityFar: {
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"Warm";
                        self.positionDot.alpha = 1.0;
                    }];
                    break;
                }
                case CLProximityNear: {
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"Warmer";
                        self.positionDot.alpha = 1.0;
                    }];
                    break;
                }
                case CLProximityImmediate:{
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"HOT!! Go behind the tribune";
                        self.positionDot.alpha = 1.0;
                    }];
                    break;
                }
                default: {
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"Brrr... Cold";
                        self.positionDot.alpha = 0;
                    }];
                    break;
                }
            }
        }
    }
    if ([region.identifier isEqualToString:region2]) {
        if (beacons.count != 0) {
            JLEBeacon *temp = [beacons firstObject];
            
            float distFactor = (-1) / ((float)temp.rssi);
            float newYPos = self.dotMinPos + distFactor * self.dotRange * 105;
            [UIView animateWithDuration:1.0 animations:^(void) {
                self.positionDot.center = CGPointMake(self.view.bounds.size.width / 2, newYPos);
                self.positionDot.alpha = 1.0;
            }];
            
            self.dotPositionLabel.text = [NSString stringWithFormat:@"x: %.02f y: %.02f %ld %f", self.positionDot.frame.origin.x, self.positionDot.frame.origin.y, (long)temp.rssi, temp.accuracy]; // @"";  //
            
            switch (temp.proximity) {
                case CLProximityFar: {
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"Warm";
                        self.positionDot.alpha = 1.0;
                    }];
                    break;
                }
                case CLProximityNear: {
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"Warmer";
                        self.positionDot.alpha = 1.0;
                    }];
                    break;
                }
                case CLProximityImmediate:{
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"HOT!! Go to the bathroom";
                        self.positionDot.alpha = 1.0;
                    }];
                    break;
                }
                default: {
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"Brrr... Cold";
                        self.positionDot.alpha = 0;
                    }];
                    break;
                }
            }
        }
    }
    
    if ([region.identifier isEqualToString:region3]) {
        if (beacons.count != 0) {
            JLEBeacon *temp = [beacons firstObject];
            
            float distFactor = (-1) / ((float)temp.rssi);
            float newYPos = self.dotMinPos + distFactor * self.dotRange * 105;
            [UIView animateWithDuration:1.0 animations:^(void) {
                self.positionDot.center = CGPointMake(self.view.bounds.size.width / 2, newYPos);
                self.positionDot.alpha = 1.0;
            }];
            
            self.dotPositionLabel.text = [NSString stringWithFormat:@"x: %.02f y: %.02f rssi: %ld d(m): %.02f", self.positionDot.frame.origin.x, self.positionDot.frame.origin.y, (long)temp.rssi, temp.accuracy]; // @"";  //
            
            switch (temp.proximity) {
                case CLProximityFar: {
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"Warm";
                        self.positionDot.alpha = 1.0;
                    }];
                    break;
                }
                case CLProximityNear: {
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"Warmer";
                        self.positionDot.alpha = 1.0;
                    }];
                    break;
                }
                case CLProximityImmediate:{
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 1.0;
                        self.clueLabel.text = @"HOT!! Go at the entrance";
                        self.positionDot.alpha = 1.0;
                    }];
                    break;
                }
                default: {
                    [UIView animateWithDuration:1.0 animations:^(void) {
                        self.clueLabel.alpha = 0.0;
                        self.clueLabel.text = @"Brrr... Cold";
                        self.positionDot.alpha = 0;
                    }];
                    break;
                }
            }
        }
    }
}

-(void)doneButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegionForClue1];
    
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegionForClue2];
    
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegionForClue3];
}

-(void)showDebugLabel:(id)sender {
    [UIView animateWithDuration:1.0 animations:^(void) {
        self.dotPositionLabel.alpha = 1.0;
    }];
}

-(void)hideDebugLabel:(id)sender {
    [UIView animateWithDuration:1.0 animations:^(void) {
        self.dotPositionLabel.alpha = 0.0;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
