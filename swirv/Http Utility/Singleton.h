//
//  Singleton.h
//  Tapex
//
//  Created by Rajeev Ranjan Singh on 06/02/15.
//  Copyright (c) 2015 Yash sikarvar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Singleton : NSObject
@property (strong, nonatomic)NSString *TeamId1;
@property (strong, nonatomic)NSString *TeamId2;

+(Singleton*)sharedInstance;

@end
