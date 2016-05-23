//
//  InterfaceController.h
//  SolarView Watch WatchKit Extension
//
//  Created by Philipp Pinkernelle on 10.08.15.
//  Copyright (c) 2015 Philipp Pinkernelle. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController : WKInterfaceController <WCSessionDelegate>
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *LeistungLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *TagLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *MonatLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *JahrLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *SolarViewLabel;
- (IBAction)refresh;

@end
