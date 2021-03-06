//
//  NTParallaxLayer.m
//  NTParallax
//
//  Created by Nick Esposito on 7/10/13.
//  Copyright (c) 2013 NickTitle. All rights reserved.
//

#import "NTParallaxLayer.h"

#import "NTMotionReporter.h"

NTMotionReporter *reporter;

@implementation NTParallaxLayer

@synthesize parallaxView;
@synthesize verticalMotionRange;
@synthesize horizontalMotionRange;
@synthesize origX;
@synthesize origY;


-(id)initWithView:(UIView *)view motionRange:(double)mR origin:(CGPoint)origin {
    self = [self initWithView:view vRange:mR hRange:mR origin:origin];
    return self;
}


-(id)initWithView:(UIView *)view vRange:(double)vR hRange:(double)hR origin:(CGPoint)origin {
    self = [super init];
    self.parallaxView = view;
    self.verticalMotionRange = vR;
    self.horizontalMotionRange = hR;
    self.origX = origin.x;
    self.origY = origin.y;
    
    reporter = [NTMotionReporter singleReporter];
    
    return self;
}


//Processing is done in the background, and then the view is updated on the main thread
-(void)updateViewFromNotification:(NSNotification *)n {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGRect currFrame = parallaxView.frame;
        
        double roll = reporter.calcRoll;
        double pitch = reporter.calcPitch;
        
        double xOffset = horizontalMotionRange * (roll/3.14);
        double yOffset = verticalMotionRange * (pitch/3.14);
        
        double newX = origX+xOffset;
        double newY = origY+yOffset;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.parallaxView setFrame:CGRectMake(newX, newY, currFrame.size.width, currFrame.size.height)];
        });
        
    });
}

@end
