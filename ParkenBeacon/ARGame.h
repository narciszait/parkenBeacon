//
//  ARGame.h
//  ParkenBeacon
//
//  Created by Narcis Zait on 15/06/2017.
//  Copyright © 2017 Narcis Zait. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

@interface ARGame : UIViewController <ARSCNViewDelegate, SCNPhysicsContactDelegate>
@property (weak, nonatomic) IBOutlet ARSCNView *sceneView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
