//
//  InterfaceController.m
//  SolarView Watch WatchKit Extension
//
//  Created by Philipp Pinkernelle on 10.08.15.
//  Copyright (c) 2015 Philipp Pinkernelle. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self.SolarViewLabel setText:@"Aktualisieren..."];
    if (WCSession.defaultSession.reachable == true)
    {
        NSLog(@"CheckOne");
    [self getMyInformation];

    }
    else
    {
        NSLog(@"CheckNO");
        [self getMyInformation];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void) getMyInformation
{
    NSUserDefaults *standartUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *array = [[NSMutableDictionary alloc]init];

    if (![[standartUserDefaults stringForKey:@"URL"] isEqualToString:@""]&& [standartUserDefaults stringForKey:@"URL"] !=nil)
    {
        NSString *StringUrl = [standartUserDefaults stringForKey:@"URL"];
        if ([StringUrl rangeOfString:@"index.htm"].location != NSNotFound)
        {
            StringUrl = [StringUrl substringToIndex:[StringUrl rangeOfString:@"index.htm"].location];
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            NSDate *todayDate = [NSDate date];
            [outputFormatter setDateFormat:@"yyyyMMdd"];
            NSString *date = [outputFormatter stringFromDate:todayDate];
            StringUrl = [StringUrl stringByAppendingString:date];
            StringUrl = [StringUrl stringByAppendingString:@".js"];
            
            NSString *myURLString = StringUrl;
            NSURL *url = [NSURL URLWithString:myURLString]; //[NSURL URLWithString:@"https://pppinki.synology.me:500/SolarView/20150913.js"];
            NSLog(@"Ready for Task");
            // 2
            
            NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
            conf.URLCache = NULL;
            NSURLSession *session = [NSURLSession sessionWithConfiguration:conf];
            NSURLSessionDataTask *downloadTask = [session
                                                  dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                      // 4:
                                                      
                                                      NSString *HTMLCode = [NSString stringWithUTF8String:[data bytes]];//[NSString stringWithContentsOfURL:url encoding: NSUTF8StringEncoding error:&error];
                                                      
                                                      if (HTMLCode != nil&& [HTMLCode rangeOfString:@"wr_kdy=["].location != NSNotFound)
                                                      {
                                                          HTMLCode = [HTMLCode substringFromIndex:[HTMLCode rangeOfString:@"wr_kdy=["].location+8];
                                                          NSString *tagesertrag = [HTMLCode substringToIndex:[HTMLCode rangeOfString:@","].location];
                                                          HTMLCode = [HTMLCode substringFromIndex:[HTMLCode rangeOfString:@"wr_kmt=["].location+8];
                                                          NSString *monatsertrag = [HTMLCode substringToIndex:[HTMLCode rangeOfString:@","].location];
                                                          HTMLCode = [HTMLCode substringFromIndex:[HTMLCode rangeOfString:@"wr_kyr=["].location+8];
                                                          NSString *jahresertrag = [HTMLCode substringToIndex:[HTMLCode rangeOfString:@","].location];
                                                          HTMLCode = [HTMLCode substringFromIndex:[HTMLCode rangeOfString:@"wr_pac=["].location+8];
                                                          NSString *leistung = [HTMLCode substringToIndex:[HTMLCode rangeOfString:@","].location];
                                                          [array setObject:leistung forKey:@"leistung"];
                                                          [array setObject:tagesertrag forKey:@"tag"];
                                                          [array setObject:monatsertrag forKey:@"monat"];
                                                          [array setObject:jahresertrag forKey:@"jahr"];
                                                      }
                                                      else if(HTMLCode != nil)
                                                      {
                                                          [array setObject:@"NO" forKey:@"check"];
                                                      }
                                                      else
                                                      {
                                                          [array setObject:@"NO" forKey:@"online"];
                                                      }
                                                      NSDictionary *Info = array;
                                                      if ([Info[@"online"] isEqualToString:@"NO"])
                                                      {
                                                          [self.LeistungLabel setText:@"Fehler bei der Abfrage."];
                                                      }
                                                      else if ([Info[@"check"] isEqualToString:@"NO"])
                                                      {
                                                          [self.LeistungLabel setText:@"Überprüfe deine Einstellung."];
                                                      }
                                                      else
                                                      {
                                                          NSString *leistung = @"Leistung: ";
                                                          leistung = [leistung stringByAppendingString:Info[@"leistung"]];
                                                          leistung = [leistung stringByAppendingString:@"W"];
                                                          NSString *tag = @"Tagesertrag: ";
                                                          tag = [tag stringByAppendingString:Info[@"tag"]];
                                                          tag = [tag stringByAppendingString:@"kWh"];
                                                          NSString *monat = @"Monatsertrag: ";
                                                          monat = [monat stringByAppendingString:Info[@"monat"]];
                                                          monat = [monat stringByAppendingString:@"kWh"];
                                                          NSString *jahr = @"Jahresertrag: ";
                                                          jahr = [jahr stringByAppendingString:Info[@"jahr"]];
                                                          jahr = [jahr stringByAppendingString:@"kWh"];
                                                          
                                                          [self.LeistungLabel setText:leistung];
                                                          [self.TagLabel setText:tag];
                                                          [self.MonatLabel setText:monat];
                                                          [self.JahrLabel setText:jahr];
                                                          [self.SolarViewLabel setText:@"SolarView"];
                                                          NSLog(@"Daten verarbeitet!");
                                                      }
                                                      NSLog(@"Work Done!");
                                                  }];
            
            // 3
            [downloadTask resume];
            NSLog(@"Waiting...");
            
        }
        else
        {
            NSLog(@"Einstellungen fehlen");
        }
    }
    else
    {
        NSLog(@"Deine Einstellungen sind falsch.");
        [self.SolarViewLabel setText:@"Fehler!"];
    }

}

-(void)sessionWatchStateDidChange:(nonnull WCSession *)session
{
    if(WCSession.isSupported){
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];
        
    }
}
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler
{
    
    if(message){
        
        NSString* command = [message objectForKey:@"adress"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:command forKey:@"URL"];
        //[self.replyLabel setText:command];
        
        //NSString* otherCounter = [message objectForKey:@"counter"];
        
        
        NSDictionary* response = @{@"response" : [NSString stringWithFormat:@"Message received."]} ;
        
        
        if (replyHandler != nil) replyHandler(response);
        
        
    }
    
    
}
-(void)packageAndSendMessage:(NSDictionary*)request
{
    if(WCSession.isSupported){
        
        
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];
        
        if(session.reachable)
        {
            
            [session sendMessage:request
                    replyHandler:
             ^(NSDictionary<NSString *,id> * __nonnull replyMessage) {
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@".....replyHandler called --- %@",replyMessage);
                     
                     NSDictionary* message = replyMessage;
                     
                     NSString* response = message[@"response"];
                     
                     [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeSuccess];
                     

                     
                 });
                 
                 
                 
                 
             }
             
                    errorHandler:^(NSError * __nonnull error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //[self.replyLabel setText:error.localizedDescription];
                        });
                        
                    }
             
             
             ];
        }
        else
        {
           // [self.replyLabel setText:@"Session Not reachable"];
        }
        
    }
    else
    {
        //[self.replyLabel setText:@"Session Not Supported"];
    }
    
    
    
    
    
}




- (IBAction)refresh
{
    [self.SolarViewLabel setText:@"Aktualisieren..."];
    [self getMyInformation];
}
@end



