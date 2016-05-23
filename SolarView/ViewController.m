//
//  ViewController.m
//  SolarView Watch
//
//  Created by Philipp Pinkernelle on 10.08.15.
//  Copyright (c) 2015 Philipp Pinkernelle. All rights reserved.
//

#import "ViewController.h"
#import "OnlineViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    if(WCSession.isSupported){
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];
        
    }
    self.adressTextField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    NSUserDefaults *standartUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([standartUserDefaults stringForKey:@"adress"]!=nil)
    {
        [self.adressTextField setText:[standartUserDefaults stringForKey:@"adress"]];
    }
    else
    {
        //?
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler
{
    NSLog(@"didReceiveMessage with replyHandler");
    
    if(message){
        
        NSString* command = [message objectForKey:@"request"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          //  [self.replyLabel setText:command];
            NSLog(@"%@",command);
        });
        
        
        
        NSString* otherCounter = [message objectForKey:@"counter"];
        
        
        NSDictionary* response = @{@"response" : [NSString stringWithFormat:@"Message %@ received.",otherCounter]} ;
        
        
        if (replyHandler != nil) replyHandler(response);
        
        
        
    }
    
    
}

-(void)sessionWatchStateDidChange:(nonnull WCSession *)session
{
    
    if(WCSession.isSupported){
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];
        
        
        if(session.reachable)
        {
            NSLog(@"session.reachable");
        }
        
        if(session.paired){
            if(session.isWatchAppInstalled){
                
                if(session.watchDirectoryURL != nil){
                    
                    
                }
                
            }
        }
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)packageAndSendMessage:(NSDictionary*)request
{

    if(WCSession.isSupported){
        
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];

        if(session.reachable)
        {
            [session sendMessage:request replyHandler: ^(NSDictionary<NSString *,id> * __nonnull replyMessage)
             {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@".....replyHandler called --- %@",replyMessage);
                     
                     NSDictionary* message = replyMessage;
                     
                     NSString* response = message[@"response"];
                     
                     if(response)
                     {
                         NSLog(@"JA: %@",response);
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(@"Daten Synchronisiert!")
                                                                         message:@"Deine Apple Watch konnte eingestellt werden."
                                                                        delegate:self
                                                               cancelButtonTitle:@"Okay"
                                                               otherButtonTitles: nil];
                         alert.tag = 1;
                         [alert show];

                    }
                    else
                    {
                        NSLog(@"NEIN");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(@"FEHLER!")
                                                                        message:@"Deine Apple Watch konnte nicht eingestellt werden.\n\nSpeichere deine Einstellung noch einmal."
                                                                       delegate:self
                                                              cancelButtonTitle:@"Okay"
                                                              otherButtonTitles: nil];
                        alert.tag = 1;
                        [alert show];

                    }
                     
                     
                     
                 });
                 
                 
                 
                 
             }
             
                    errorHandler:^(NSError * __nonnull error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"%@",error.localizedDescription);
                            //[self.replyLabel setText:error.localizedDescription];
                        });
                        
                    }
             
             
             ];
        }
        else
        {
            NSLog(@"Session Not reachable");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(@"Keine Verbindung zur Watch!")
                                                            message:@"Versuche es erneut."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles: nil];
            [alert show];

        }
        
    }
    else
    {
        NSLog(@"Session Not Supported");
    }
    
    
    
    
    
}

- (IBAction)saveButtonAction:(id)sender
{
    NSUserDefaults *standartUserDefaults = [NSUserDefaults standardUserDefaults];
    [standartUserDefaults setObject:[self.adressTextField text] forKey:@"adress"];
    [self packageAndSendMessage:@{@"adress":[self.adressTextField text]}];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(@"Adresse wurde gespeichert.")
                                                    message:@"Überprüfe die Eingabe mit mit dem Button \"Online View\"."
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles: nil];
    //[alert show];
    [self dismissKeyboard];

    
}

#pragma mark - KeyboardFunktionen

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag ==17)
    {
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    return YES;
}

- (void) dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSUserDefaults *standartUserDefaults = [NSUserDefaults standardUserDefaults];
    OnlineViewController *online = segue.destinationViewController;
    online.adressText = [standartUserDefaults stringForKey:@"adress"];
    
    
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSUserDefaults *standartUserDefaults = [NSUserDefaults standardUserDefaults];

    if ([identifier isEqualToString:@"segueOnline"] && [standartUserDefaults stringForKey:@"adress"] != nil && ![[standartUserDefaults stringForKey:@"adress"] isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(@"Keine Adresse eingegeben.")
                                                        message:@"Überprüfe die obrige Eingabe!"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles: nil];
        alert.tag = 1;
        [alert show];

        return NO;
    }
    
}

@end
