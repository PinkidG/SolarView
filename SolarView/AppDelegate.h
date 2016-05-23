//
//  AppDelegate.h
//  SolarView Watch
//
//  Created by Philipp Pinkernelle on 10.08.15.
//  Copyright (c) 2015 Philipp Pinkernelle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSMutableData *AllresponseData;


@end

