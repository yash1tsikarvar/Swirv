//
//  AppDelegate.h
//  swirv
//
//  Created by Yash sikarvar on 27/11/15.
//  Copyright © 2015 Yash sikarvar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

+ (BOOL)networkAvailable;

-(void)stopVideo;
@end

