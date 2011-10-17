//
//  Shanghai_WalkerAppDelegate.m
//  Shanghai Walker
//
//  Created by JF on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Shanghai_WalkerAppDelegate.h"
#import "PageController.h"
#import "MainMenuViewController.h"

@implementation Shanghai_WalkerAppDelegate


@synthesize window=_window;
@synthesize navCont;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    //on the first run, we set defaults. "firstRun" is never used again
    if ([prefs valueForKey:@"firstRun"] == 0)
    {
        [prefs setBool:YES forKey:@"metric"];
        [prefs setInteger:1 forKey:@"firstRun"];
        [prefs synchronize];
    }

    MainMenuViewController *m = [[MainMenuViewController alloc]init];
    self.navCont = [[UINavigationController alloc]init];
    [navCont pushViewController:m animated:NO];
    [self.window addSubview:navCont.view];
    
    [m release];

    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [navCont release];
    [super dealloc];
}

@end
