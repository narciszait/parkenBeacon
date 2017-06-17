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
@property (nonatomic, strong) SCNNode *ball;
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
    
//    SCNScene *scene = [SCNScene new];
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ball.dae"];
    
    self.sceneView.scene = scene;
    self.sceneView.scene.physicsWorld.contactDelegate = self;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    [self addNewShip];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boardTapped:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:self.sceneView.gestureRecognizers];
    self.sceneView.gestureRecognizers = gestureRecognizers;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    ARWorldTrackingSessionConfiguration *configuration = [ARWorldTrackingSessionConfiguration new];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    
    [self.sceneView.session runWithConfiguration:configuration];
}

-(void)addNewShip{
//    self.cube = [[Ship alloc] init];
    
    self.ball = [SCNNode new];
    self.ball = [self.sceneView.scene.rootNode childNodeWithName:@"Football" recursively:YES];
    self.ball.scale = SCNVector3Make(0.001, 0.001, 0.001);
    
    double posX = ((double)arc4random() / ARC4RANDOM_MAX) * (0.0f - 0.5f) + 0.5f;
    double posY = ((double)arc4random() / ARC4RANDOM_MAX) * (0.0f - 0.5f) + 0.5f;
    
//    self.cube.position = SCNVector3Make(posX, posY, -1);
    self.ball.position = SCNVector3Make(posX, posY, -1);
//    [self.sceneView.scene.rootNode addChildNode:self.cube];
    [self.sceneView.scene.rootNode addChildNode:self.ball];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)boardTapped:(UIGestureRecognizer*)gestureRecognize
{
    CGPoint p = [gestureRecognize locationInView:self.sceneView];
    NSArray *hitResults = [self.sceneView hitTest:p options:nil];
    
    if([hitResults count] > 0){
        
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        if(result.node == self.ball){
            [result.node removeFromParentNode];
            NSLog(@"ball.scale %f %f %f", self.ball.position.x,self.ball.position.y, self.ball.scale.z);
            score++;
            self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
            [self checkScore];
        }
    }
}

-(void)checkScore{
    NSLog(@"score: %@", self.scoreLabel.text);
    if (score == 1){
//        dispatch_async(dispatch_get_main_queue(), ^{
            self.scoreLabel.text= @"HOT!! Go at the entrance";
            score = 0;
//        });
    } else {
        [self addNewShip];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [self.sceneView.session pause];
}

@end

