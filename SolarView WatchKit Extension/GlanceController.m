//
//  GlanceController.m
//  SolarView Watch WatchKit Extension
//
//  Created by Philipp Pinkernelle on 10.08.15.
//  Copyright (c) 2015 Philipp Pinkernelle. All rights reserved.
//

#import "GlanceController.h"


@interface GlanceController()

@end


@implementation GlanceController

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
    [self.GlanceLabel setText:@"Loading..."];
    if (WCSession.defaultSession.reachable == true)
    {
        NSLog(@"CheckOne");
        [self getMyInformation];
        
    }
    else
    {
        NSLog(@"CheckNO");
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
    NSLog(@"Start...");
    if (![[standartUserDefaults stringForKey:@"adress"] isEqualToString:@""]&& [standartUserDefaults stringForKey:@"URL"] !=nil)
    {
        NSString *StringUrl = [standartUserDefaults stringForKey:@"URL"];
        StringUrl = [StringUrl substringToIndex:[StringUrl rangeOfString:@"index.htm"].location];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        NSDate *todayDate = [NSDate date];
        [outputFormatter setDateFormat:@"yyyyMMdd"];
        NSString *date = [outputFormatter stringFromDate:todayDate];
        StringUrl = [StringUrl stringByAppendingString:date];
        StringUrl = [StringUrl stringByAppendingString:@".js"];
        
        NSString *myURLString = StringUrl;
        NSURL *url = [NSURL URLWithString:myURLString];
        NSLog(@"Ready for Task");
        // 2
        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        conf.URLCache = NULL;
        NSURLSession *session = [NSURLSession sessionWithConfiguration:conf];

        NSURLSessionDataTask *downloadTask = [session
                                              dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                  // 4:
                                                  
                                                  NSString *HTMLCode = [NSString stringWithUTF8String:[data bytes]];//[NSString stringWithContentsOfURL:url encoding: NSUTF8StringEncoding error:&error];
                                                  if (data ==nil)
                                                  {
                                                      [self.TextLabel setText:@"Kommunikationsfehler"];
                                                      NSLog(@"Äh...Fehler: %@", error);
                                                      [self.GlanceLabel setText:@"SolarView"];
                                                  }
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
                                                      [self.TextLabel setText:@"Fehler bei der Abfrage."];
                                                  }
                                                  else if ([Info[@"check"] isEqualToString:@"NO"])
                                                  {
                                                      [self.TextLabel setText:@"Überprüfe deine Einstellung."];
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
                                                      NSString *gesamtString = [[NSString alloc]init];

                                                      
                                                      gesamtString = leistung;
                                                      gesamtString = [gesamtString stringByAppendingString:@"\n\n"];
                                                      gesamtString = [gesamtString stringByAppendingString:tag];
                                                      gesamtString = [gesamtString stringByAppendingString:@"\n\n"];
                                                      gesamtString = [gesamtString stringByAppendingString:monat];
                                                      gesamtString = [gesamtString stringByAppendingString:@"\n\n"];
                                                      gesamtString = [gesamtString stringByAppendingString:jahr];
                                                      [self.TextLabel setText:gesamtString];
                                                      [self.GlanceLabel setText:@"SolarView"];
                                                      
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
    
    
    
    /*
    
    
    
    
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[@"information"] forKeys:@[@"request"]];
    NSLog(@"Gesendet");
    [[WCSession defaultSession] sendMessage:applicationData replyHandler:^(NSDictionary *reply)
    {
        NSLog(@"Empfangen");
        NSString *gesamtString = [[NSString alloc]init];
        NSDictionary *Info = reply[@"information"];
        if ([Info[@"online"] isEqualToString:@"NO"])
        {
            [self.TextLabel setText:@"Fehler bei der Abfrage."];
        }
        else if ([Info[@"check"] isEqualToString:@"NO"])
        {
            [self.TextLabel setText:@"Überprüfe deine Einstellung."];
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
            
                                                       
            gesamtString = leistung;
            gesamtString = [gesamtString stringByAppendingString:@"\n\n"];
            gesamtString = [gesamtString stringByAppendingString:tag];
            gesamtString = [gesamtString stringByAppendingString:@"\n\n"];
            gesamtString = [gesamtString stringByAppendingString:monat];
            gesamtString = [gesamtString stringByAppendingString:@"\n\n"];
            gesamtString = [gesamtString stringByAppendingString:jahr];
            [self.TextLabel setText:gesamtString];
            [self.GlanceLabel setText:@"SolarView"];
        }
    }
                               errorHandler:^(NSError *error)
                                   {
                                       [self.TextLabel setText:@"Kommunikationsfehler"];
                                       NSLog(@"Äh...Fehler: %@", error);
                                       [self.GlanceLabel setText:@"SolarView"];
                                    }];*/
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



@end



