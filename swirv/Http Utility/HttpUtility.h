//
//  Webservices.h
//  Couture
//
//  Created by Lakshaya Sachdeva on 03/02/15.
//  Copyright (c) 2015 Lakshaya Sachdeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpUtility : NSObject{
    
    
}

// This method is taking the url string and the parameters or post data which we want to send to the server, it is calling the webservices and returning the response as json.
+(id) makePostConnectionRequestWithURL:(NSString *)urlString andPostData:(NSDictionary *)parameterDictionary withAuthorization:(BOOL) withAuthorization;


+(id) makeGetConnectionRequestWithURL:(NSString *)urlString withAuthorization:(BOOL) withAuthorization;

+(id) makePatchConnectonRequestWithURL:(NSString *)urlString andParameters:(NSDictionary *) parameterDictionary withAuthorization:(BOOL) withAuthorization;


+(id) makePutConnectonRequestWithURL:(NSString *)urlString andParameters:(NSDictionary *) parameterDictionary withAuthorization:(BOOL) withAuthorization;

+(id) makeDeleteConnectionRequestWithURL:(NSString *)urlString withAuthorization:(BOOL) withAuthorization;



@end
