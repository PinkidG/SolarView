//
//  ViewController.h
//  SolarView Watch
//
//  Created by Philipp Pinkernelle on 10.08.15.
//  Copyright (c) 2015 Philipp Pinkernelle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController : UIViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,WCSessionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *adressTextField;
- (IBAction)saveButtonAction:(id)sender;

@end

