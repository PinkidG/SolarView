//
//  OnlineViewController.h
//  SolarView Watch
//
//  Created by Philipp Pinkernelle on 10.08.15.
//  Copyright (c) 2015 Philipp Pinkernelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *onlineView;
- (IBAction)backAction:(id)sender;
@property (strong,nonatomic) NSString *adressText;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) NSMutableData *responseData;


@end
