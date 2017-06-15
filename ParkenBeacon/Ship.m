//
//  Ship.m
//  ParkenBeacon
//
//  Created by Narcis Zait on 15/06/2017.
//  Copyright © 2017 Narcis Zait. All rights reserved.
//

#import "Ship.h"

typedef NS_OPTIONS(NSUInteger, CollisionCategory) {
    CollisionCategoryBullets  = 1 << 0,
    CollisionCategoryShip    = 1 << 1,
};

@implementation Ship
-(id)init{
    if ((self = [super init])) {
        SCNBox *box = [SCNBox boxWithWidth:0.1 height:0.1 length:0.1 chamferRadius:0];
        self.geometry = box;
        SCNPhysicsShape *shape = [SCNPhysicsShape shapeWithGeometry:box options:nil];
        self.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:shape];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = CollisionCategoryShip;
        self.physicsBody.contactTestBitMask = CollisionCategoryBullets;
        
        SCNMaterial *material = [SCNMaterial new];
        material.diffuse.contents = [UIImage imageNamed:@"galaxy"];
        self.geometry.materials = @[material, material, material, material, material, material];
        
        self.name = @"ship";
    }
    return self;
}

@end
