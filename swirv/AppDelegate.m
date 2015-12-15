//
//  AppDelegate.m
//  swirv
//
//  Created by Yash sikarvar on 27/11/15.
//  Copyright © 2015 Yash sikarvar. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface AppDelegate ()

{
    UIView * viewMovie;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    viewMovie = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
   
    [self setupAndPlayMovie];
    

  
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];;
}

-(void)stopVideo
{
    [self.moviePlayer stop];
}

-(void)setupBlur {
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = [UIScreen mainScreen].bounds;
    visualEffectView.alpha = 0.5f;
    [viewMovie insertSubview:visualEffectView atIndex: 0];
}
-(void)setupGradient {
    UIView* view = [[UIView alloc] initWithFrame: viewMovie.frame];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    CGFloat alpha = 0.75f;
    UIColor *colorOne = [UIColor colorWithRed:197.0f / 255.0f green:68.0f / 255.0f blue:252.0f / 255.0f alpha:alpha];
    UIColor *colorTwo = [UIColor colorWithRed:108.0f / 255.0f green:68.0f / 255.0f blue:252.0f / 255.0f alpha:alpha];
    gradient.colors =  @[(id)[colorOne CGColor], (id)[colorTwo CGColor]];
    [view.layer insertSublayer:gradient atIndex:0];
    [viewMovie insertSubview: view atIndex: 0];
}
-(void)setupAndPlayMovie {
    
    // [self setupGradient];
    [self setupBlur];
    
    NSURL *movieURL = [[NSBundle mainBundle] URLForResource: @"nyc_traffic.m4v" withExtension:@""];
    
    self.moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
    
    self.moviePlayer.backgroundView.backgroundColor = [UIColor whiteColor];
  
    self.moviePlayer.view.frame = [UIScreen mainScreen].bounds;
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.moviePlayer.shouldAutoplay = YES;
    self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    [viewMovie insertSubview:self.moviePlayer.view atIndex: 0];
    [self.moviePlayer setFullscreen:NO animated:NO];
     [self.window addSubview:viewMovie];
    [self.moviePlayer play];
    
        LoginViewController *controller = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
       self.window.rootViewController=controller;
      [self.window makeKeyAndVisible];
}

-(void) moviePlayBackDidFinish:(NSNotification*)notification {
    
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
    [FBSDKAppEvents activateApp];
}
// This mehthod use for facebook integration
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

// Check network status
+ (BOOL)networkAvailable
{
    
    BOOL checkNetworkStatus = NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        //my web-dependent code
        checkNetworkStatus=YES;
    }
    else {
        //there-is-no-connection warning
        checkNetworkStatus=NO;
    }
    return checkNetworkStatus;
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
