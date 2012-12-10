//
//  LeapQCPlugIn.h
//  LeapQC
//
//  Created by Andrew Pouliot on 11/17/12.
//  Copyright (c) 2012 Darknoon. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface LeapQCPlugIn : QCPlugIn

@property (copy) NSArray *outputHands;

@property (copy) NSArray *outputFingers;

@end
