//
//  LeapQCPlugIn.m
//  LeapQC
//
//  Created by Andrew Pouliot on 11/17/12.
//  Copyright (c) 2012 Darknoon. All rights reserved.
//

// It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering
#import <OpenGL/CGLMacro.h>

#import "LeapQCPlugIn.h"

#import "Leap.h"

#define	kQCPlugIn_Name				@"LeapQC"
#define	kQCPlugIn_Description		@"LeapQC description"

@implementation LeapQCPlugIn {
	Leap::Controller *controller;
}

// Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
@dynamic outputHands, outputFingers;

+ (NSDictionary *)attributes
{
	// Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
    return @{QCPlugInAttributeNameKey:kQCPlugIn_Name, QCPlugInAttributeDescriptionKey:kQCPlugIn_Description};
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
	// Specify the optional attributes for property based ports (QCPortAttributeNameKey, QCPortAttributeDefaultValueKey...).
	return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	return kQCPlugInExecutionModeProvider;
}

+ (QCPlugInTimeMode)timeMode
{
	return kQCPlugInTimeModeIdle;
}


@end

@implementation LeapQCPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
	controller = new Leap::Controller();
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when the plug-in instance starts being used by Quartz Composer.
}

- (NSDictionary *)wrapVector:(const Leap::Vector)v {
	return @{@"x": @(v.x), @"y" : @(v.y), @"z" : @(v.z)};
}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
	NSMutableArray *fingers = [[NSMutableArray alloc] init];
	NSMutableArray *hands = [[NSMutableArray alloc] init];
	
	Leap::Frame frame = controller->frame();
	
	for (Leap::Hand hand : frame.hands() ) {
		const Leap::Ray *r = hand.palm();
		if (r) {
			[hands addObject:@{
			 @"position" : [self wrapVector:r->position],
			 @"direction" : [self wrapVector:r->direction],
			 }];
		}
		for (Leap::Finger finger : hand.fingers()) {
			const Leap::Ray tip = finger.tip();
			[fingers addObject:@{
			 @"position" : [self wrapVector:tip.position],
			 @"direction" : [self wrapVector:tip.direction],
			 }];
		}
	}
	
	self.outputFingers = fingers;
	self.outputHands = hands;
	
	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when the plug-in instance stops being used by Quartz Composer.
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
	delete controller;
	controller = NULL;
}

@end
