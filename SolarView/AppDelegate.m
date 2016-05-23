//
//  AppDelegate.m
//  SolarView Watch
//
//  Created by Philipp Pinkernelle on 10.08.15.
//  Copyright (c) 2015 Philipp Pinkernelle. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end



@implementation AppDelegate
NSMutableURLRequest *Datarequest;
UIWebView *webView;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary*)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler
{
 
    NSLog(@"Check");
    __block UIBackgroundTaskIdentifier watchKitHandler;
    watchKitHandler = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"backgroundTask"
                                                                   expirationHandler:^{
                                                                       watchKitHandler = UIBackgroundTaskInvalid;
                                                                   }];
    
    if ( [[message objectForKey:@"request"] isEqualToString:@"information"] )
    {
        NSDictionary *dicct = [self getInfo];
        
        replyHandler( dicct );
    }
    
    dispatch_after( dispatch_time( DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC * 1 ), dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^{
        [[UIApplication sharedApplication] endBackgroundTask:watchKitHandler];
    } );
    
}

-(void) application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    
    //reply(@{@"information": dict});
    __block UIBackgroundTaskIdentifier watchKitHandler;
    watchKitHandler = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"backgroundTask"
                                                                   expirationHandler:^{
                                                                       watchKitHandler = UIBackgroundTaskInvalid;
                                                                   }];
    
    if ( [[userInfo objectForKey:@"request"] isEqualToString:@"information"] )
    {
        NSDictionary *dicct = [self getInfo];
        
        reply( dicct );
    }
    
    dispatch_after( dispatch_time( DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC * 1 ), dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^{
        [[UIApplication sharedApplication] endBackgroundTask:watchKitHandler];
    } );
}

- (NSDictionary*) getInfo
{
    NSMutableDictionary *array = [[NSMutableDictionary alloc]init];
    NSUserDefaults *standartUserDefaults = [NSUserDefaults standardUserDefaults];
    if (![[standartUserDefaults stringForKey:@"adress"] isEqualToString:@""])
    {
        NSString *StringUrl = [standartUserDefaults stringForKey:@"adress"];
        StringUrl = [StringUrl substringToIndex:[StringUrl rangeOfString:@"index.htm"].location];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        NSDate *todayDate = [NSDate date];
        [outputFormatter setDateFormat:@"yyyyMMdd"];
        NSString *date = [outputFormatter stringFromDate:todayDate];
        StringUrl = [StringUrl stringByAppendingString:date];
        StringUrl = [StringUrl stringByAppendingString:@".js"];

        NSString *myURLString = StringUrl;
        NSURL *myURL = [NSURL URLWithString:myURLString];
        
        NSError *error = nil;
        NSString *myHTMLString = [NSString stringWithContentsOfURL:myURL encoding: NSUTF8StringEncoding error:&error];
        
        if (error != nil)
        {
            NSLog(@"Error : %@", error);
        }
        else
        {
            NSLog(@"HTML : %@", myHTMLString);
        }
        NSString *HTMLCode = myHTMLString;
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

            }
    else
    {
        [array setObject:@"NO" forKey:@"check"];
    
    }
    return @{@"information":array};
}


@end
