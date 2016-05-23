//
//  OnlineViewController.m
//  SolarView Watch
//
//  Created by Philipp Pinkernelle on 10.08.15.
//  Copyright (c) 2015 Philipp Pinkernelle. All rights reserved.
//

#import "OnlineViewController.h"

@interface OnlineViewController ()

@end

@implementation OnlineViewController
NSMutableURLRequest *request;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.onlineView.delegate = self;
    self.responseData = [NSMutableData data];
    NSURL *url = [NSURL URLWithString:self.adressText];
    request = [NSMutableURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES ];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(@"Fehler.")
                                                    message:@"Es gab einen Fehler bei der Verbindung. Überprüfe deine Eingabe."
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles: nil];
    [alert show];

}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //Getting your response string
    //NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    [self.onlineView loadRequest:request];
    self.responseData = nil;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
