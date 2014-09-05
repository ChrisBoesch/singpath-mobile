//
//  deepend.m
//  Singpath
//
//  Created by Rishik on 10/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "deepend.h"
#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/QuartzCore.h>

@implementation deepend


static CMMotionManager *motionManager;
static double crop;
static double cropLeft;
static double rollFactor;
static double pitchFactor;
static CATransform3D scaleTransform;
static BOOL enabled;

// Used for the background movement
// Starts Accelerometer and then calculates shift in background image 


+(void) StartMotion: (UIImageView *) imageView
{
	
	if (!motionManager) {
		motionManager = [[CMMotionManager alloc] init];
		motionManager.deviceMotionUpdateInterval = 1.0 / 20.0;
	}
	if (!motionManager.deviceMotionActive) {
		[motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error)
         {
             if (motion) {
                 LoadSettings();
                 CGRect contentsRect;
                 contentsRect.size.width = crop;
                 contentsRect.size.height = crop;
                 CMAttitude *attitude = motion.attitude;
                 double pitch = attitude.pitch;
                 double rollBlend = fabs(pitch) * ((2.0 / M_PI) * 1.5);
                 if (rollBlend < 0.25)
                     rollBlend = rollFactor;
                 else if (rollBlend > 1.25)
                     rollBlend = 0.0;
                 else
                     rollBlend = (1.25 - rollBlend) * rollFactor;
                 contentsRect.origin.x = cropLeft + pitch * rollBlend;
                 contentsRect.origin.y = cropLeft + attitude.roll * pitchFactor;
                 CALayer *layer = imageView.layer;
                 layer.contentsRect = contentsRect;
                 CGSize size = layer.bounds.size;
                 layer.sublayerTransform = CATransform3DTranslate(scaleTransform, (cropLeft - contentsRect.origin.x) * size.width, (cropLeft - contentsRect.origin.y) * size.height, 0);
                 if (!layer.masksToBounds)
                     layer.masksToBounds = YES;
             }
         }];
	}
}

+(void)  StopMotion
{
	if (motionManager.deviceMotionActive){
		[motionManager stopDeviceMotionUpdates];
    motionManager=NULL;
    }
}
/*
CHOptimizedMethod(0, super, void, SBWallpaperView, didMoveToWindow)
{
	if (self == [CHSharedInstance(SBUIController) wallpaperView]) {
		if (self.window)
			StartMotion();
		else
			StopMotion();
	}
	CHSuper(0, SBWallpaperView, didMoveToWindow);
}

CHOptimizedMethod(0, self, void, SBAwayController, activate)
{
	StopMotion();
	CHSuper(0, SBAwayController, activate);
}

CHOptimizedMethod(0, self, void, SBAwayController, deactivate)
{
	CHSuper(0, SBAwayController, deactivate);
	if ([[CHSharedInstance(SBUIController) wallpaperView] window])
		StartMotion();
}*/

static void LoadSettings()
{
	
    double depth = 0.20;
    //0.33;
		cropLeft = depth * 0.5;
		crop = 1.0 - depth;
		scaleTransform = CATransform3DMakeScale(1.0 / crop, 1.0 / crop, 1.0);
		
		rollFactor = 1.0 * cropLeft * (1.0 / M_PI);
		pitchFactor = 1.0 * cropLeft * (1.0 / M_PI);
	
}

@end
