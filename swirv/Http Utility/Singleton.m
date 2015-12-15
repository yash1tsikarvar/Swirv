//
//  Singleton.m
//  Tapex
//
//  Created by Rajeev Ranjan Singh on 06/02/15.
//  Copyright (c) 2015 Yash sikarvar. All rights reserved.
//

#import "Singleton.h"
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)

@implementation Singleton

//static Singleton *sharedInstance = nil;

-(id)init{
    
    self=[super init];
    
    if (self) {
      
    }
    return self;
}

+(Singleton*)sharedInstance {
    
    static Singleton *sharedInstance = nil;

    @synchronized(self)
    {
        if (sharedInstance == NULL)
        {
            sharedInstance = [[Singleton alloc] init];
            
        }
        return sharedInstance;
    }

}


@end
