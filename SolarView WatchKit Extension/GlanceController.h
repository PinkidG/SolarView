//
//  GlanceController.h
//  SolarView Watch WatchKit Extension
//
//  Created by Philipp Pinkernelle on 10.08.15.
//  Copyright (c) 2015 Philipp Pinkernelle. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>


@interface GlanceController : WKInterfaceController <WCSessionDelegate>
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *GlanceLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *TextLabel;

@end
