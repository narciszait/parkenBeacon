//
//  ARGame.m
//  ParkenBeacon
//
//  Created by Narcis Zait on 15/06/2017.
//  Copyright © 2017 Narcis Zait. All rights reserved.
//

#import "ARGame.h"
#import "Ship.h"
#import "ViewController.h"

#define ARC4RANDOM_MAX 0x100000000

@interface ARGame ()
@property (nonatomic, strong) Ship *cube;
@end

int score;
typedef NS_OPTIONS(NSUInteger, CollisionCategory) {
    CollisionCategoryBullets  = 1 << 0,
    CollisionCategoryShip    = 1 << 1,
};

@implementation ARGame

- (void)viewDidLoad {
    [super viewDidLoad];
    score = 0;
    // Do any additional setup after loading the view.
    self.sceneView.delegate = self;
    self.sceneView.showsStatistics = YES;
    self.sceneView.autoenablesDefaultLighting = YES;
//    self.sceneView.debugOptions = ARSCNDebugOptionShowWorldOrigin | ARSCNDebugOptionShowFeaturePoints;
    
    SCNScene *scene = [SCNScene new];
    self.sceneView.scene.physicsWorld.contactDelegate = self;
    self.sceneView.scene = scene;
    self.sceneView.scene.physicsWorld.contactDelegate = self;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    [self addNewShip];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boardTapped:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:self.sceneView.gestureRecognizers];
    self.sceneView.gestureRecognizers = gestureRecognizers;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackToMenu)];
    [doubleTap setNumberOfTouchesRequired:2];
    NSMutableArray *tapRecognizers = [NSMutableArray array];
    [tapRecognizers addObject:doubleTap];
    [tapRecognizers addObjectsFromArray:self.sceneView.gestureRecognizers];
    self.sceneView.gestureRecognizers = tapRecognizers;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    ARWorldTrackingSessionConfiguration *configuration = [ARWorldTrackingSessionConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    
    [self.sceneView.session runWithConfiguration:configuration];
}

-(void)addNewShip{
    self.cube = [[Ship alloc] init];
    
    double posX = ((double)arc4random() / ARC4RANDOM_MAX) * (-0.5f - 0.5f) + 0.5f;
    double posY = ((double)arc4random() / ARC4RANDOM_MAX) * (-0.5f - 0.5f) + 0.5f;
    
    self.cube.position = SCNVector3Make(posX, posY, -1);
    [self.sceneView.scene.rootNode addChildNode:self.cube];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)boardTapped:(UIGestureRecognizer*)gestureRecognize
{
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:self.sceneView];
    NSArray *hitResults = [self.sceneView hitTest:p options:nil];
    
    if([hitResults count] > 0){
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        if(result.node == self.cube){
            //do something...
            NSLog(@"ship ship ship");
            score++;
            self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
            [self checkScore];
        }
    }
}

//- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time{
//    [self checkScore];
//}

-(void)checkScore{
    NSLog(@"score: %@", self.scoreLabel.text);
    if (score == 5){
//        dispatch_async(dispatch_get_main_queue(), ^{
            self.scoreLabel.text= @"HOT!! Go at the entrance";
            score = 0;
//        });
    }
}

-(void)goBackToMenu{
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[ViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [self.sceneView.session pause];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

