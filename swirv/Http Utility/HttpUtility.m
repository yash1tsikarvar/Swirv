//
//  Webservices.m
//  Couture
//
//  Created by Lakshaya Sachdeva on 03/02/15.
//  Copyright (c) 2015 Lakshaya Sachdeva. All rights reserved.
///////////////////////

#import "HttpUtility.h"

@implementation HttpUtility


#pragma mark -

// This method is taking the url string and the parameters or post data which we want to send to the server, it is calling the webservices and returning the response as json.

+(id) makePostConnectionRequestWithURL:(NSString *)urlString andPostData:(NSDictionary *)parameterDictionary withAuthorization:(BOOL) withAuthorization{
    // Initializing the instance of the NSData.
    NSData * postData = [NSMutableData new];
    
    // Initializing the error instance and making its reference  nil.
    NSError * error = nil;
    
    // Here checking if dictionary of parameters comes with some values then we are converting the dictionary into json data, to send them as the body of the http request.
    // To send parameters as the http request body we need to convert dictionary into json data.
    if (parameterDictionary != nil) {
        
        // Converting dictionary of parameters into json data.
        postData = [NSJSONSerialization dataWithJSONObject:parameterDictionary
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    }
    
 //   //NSLog(@"json data is %@", postData);
    
    // Making the NSMutableRequest on the basis of the url passed as a parameter.
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:200];
    
    // Here we are taking the length of the parameters.
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    // Setting the content length in http header field.
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // Setting the http body as our parameters.
    [request setHTTPBody:postData];
    
    // Setting the http method as "POST" since we are using only post method of the http request.
    [request setHTTPMethod:@"POST"];
    
    // Since we are using json format for the webservices so here setting the content type in the header field.
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    if (withAuthorization) {
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [request setValue:[dic valueForKey:@"auth_token"]forHTTPHeaderField:@"Authorization:Token token"];

    }
    
    //NSLog(@"final request is %@", [request allHTTPHeaderFields]);
    
    
    // Making the refernce of the NSURLResponse class.
    NSURLResponse * response = nil;
    
    // Here making the synchronous request with the NSMutableRequest we have formed.
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    // Now, here checking whether we are getting an error as a reponse?
    if (error) {
        
        //NSLog(@"Error = %@",error);
       // return nil;
        NSDictionary *userInfo = [error userInfo];
        NSString *errorString = [[userInfo objectForKey:NSUnderlyingErrorKey] localizedDescription];
        //NSLog(@"Error description =--= %@",errorString);
//         [[[UIAlertView alloc] initWithTitle:@"Error HTTP" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
    // If the response data is coming as nil then we are returning nil as a response data.
    if (responseData == nil) {
        
        //NSLog(@"Nil Data Response");
        return nil;
        
    }
    
    // Converting the reponse into the json format.
    id parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    // Whether the parsed data is of dictionary type.
    if ([parseData isKindOfClass:[NSDictionary class]]) {
        
        //NSLog(@"Dictionary");
        
    }
    
    // If it is of array type.
    else if ([parseData isKindOfClass:[NSArray class]]){
        
        //NSLog(@"Array");
        
    }
    
    // If it is of string type.
    else if ([parseData isKindOfClass:[NSString class]]){
        
        //NSLog(@"String");
        
    }
    
    // Unknown format.
    else{
        
        //NSLog(@"Unknown kind response");
        
    }
    
    // Returning the parsed data.
    return parseData;
    
}





+(id) makeGetConnectionRequestWithURL:(NSString *)urlString withAuthorization:(BOOL) withAuthorization{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:20];
    
    [request setHTTPMethod: @"GET"];
    
    if (withAuthorization) {
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
        [request setValue:[dic valueForKey:@"auth_token"]forHTTPHeaderField:@"Authorization:Token token"];
        
    }

    NSError *error = nil;
    
    // Making the refernce of the NSURLResponse class.
    NSURLResponse * response = nil;
    
    // Here making the synchronous request with the NSMutableRequest we have formed.
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Now, here checking whether we are getting an error as a reponse?
    if (error) {
        
        //NSLog(@"Error = %@",error);
        // return nil;
        
    }
    
    // If the response data is coming as nil then we are returning nil as a response data.
    if (responseData == nil) {
        
        //NSLog(@"Nil Data Response");
        return nil;
        
    }
    
    // Converting the reponse into the json format.
    id parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    //NSLog(@"response is %@", parseData);
    
    // Whether the parsed data is of dictionary type.
    if ([parseData isKindOfClass:[NSDictionary class]]) {
        
        //NSLog(@"Dictionary");
        
    }
    
    // If it is of array type.
    else if ([parseData isKindOfClass:[NSArray class]]){
        
        //NSLog(@"Array");
        
    }
    
    // If it is of string type.
    else if ([parseData isKindOfClass:[NSString class]]){
        
        //NSLog(@"String");
        
    }
    
    // Unknown format.
    else{
        
        //NSLog(@"Unknown kind response");
        
    }
    
    // Returning the parsed data.
    return parseData;

}




+(id) makePatchConnectonRequestWithURL:(NSString *)urlString andParameters:(NSDictionary *) parameterDictionary withAuthorization:(BOOL) withAuthorization{
    
    // Initializing the instance of the NSData.
    NSData * postData = [NSMutableData new];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:20];
    
    NSError * error = nil;

    
    // Here checking if dictionary of parameters comes with some values then we are converting the dictionary into json data, to send them as the body of the http request.
    // To send parameters as the http request body we need to convert dictionary into json data.
    if (parameterDictionary != nil) {
        
        // Converting dictionary of parameters into json data.
        postData = [NSJSONSerialization dataWithJSONObject:parameterDictionary
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    }

    // Here we are taking the length of the parameters.
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    // Setting the content length in http header field.
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // Setting the http body as our parameters.
    [request setHTTPBody:postData];
    
    // Setting the http method as "POST" since we are using only post method of the http request.
    [request setHTTPMethod:@"PATCH"];
    
    // Since we are using json format for the webservices so here setting the content type in the header field.
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    if (withAuthorization) {
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [request setValue:[dic valueForKey:@"auth_token"]forHTTPHeaderField:@"Authorization:Token token"];
        //[request setValue:@"1234" forKey:@"yash"];
        
    }
    
    
    // Making the refernce of the NSURLResponse class.
    NSURLResponse * response = nil;
    
    // Here making the synchronous request with the NSMutableRequest we have formed.
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    // Now, here checking whether we are getting an error as a reponse?
    if (error) {
        
        //NSLog(@"Error = %@",error);
        // return nil;
        
    }
    
    // If the response data is coming as nil then we are returning nil as a response data.
    if (responseData == nil) {
        
        //NSLog(@"Nil Data Response");
        return nil;
        
    }
    
    // Converting the reponse into the json format.
    id parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    //NSLog(@"response is %@", parseData);
    
    // Whether the parsed data is of dictionary type.
    if ([parseData isKindOfClass:[NSDictionary class]]) {
        
        //NSLog(@"Dictionary");
        
    }
    
    // If it is of array type.
    else if ([parseData isKindOfClass:[NSArray class]]){
        
        //NSLog(@"Array");
        
    }
    
    // If it is of string type.
    else if ([parseData isKindOfClass:[NSString class]]){
        
        //NSLog(@"String");
        
    }
    
    // Unknown format.
    else{
        
        //NSLog(@"Unknown kind response");
        
    }
    
    // Returning the parsed data.
    return parseData;

    
}



+(id) makePutConnectonRequestWithURL:(NSString *)urlString andParameters:(NSDictionary *)parameterDictionary withAuthorization:(BOOL)withAuthorization{
    
    
    // Initializing the instance of the NSData.
    NSData * postData = [NSMutableData new];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:20];
    
    NSError * error = nil;
    
    
    // Here checking if dictionary of parameters comes with some values then we are converting the dictionary into json data, to send them as the body of the http request.
    // To send parameters as the http request body we need to convert dictionary into json data.
    if (parameterDictionary != nil) {
        
        // Converting dictionary of parameters into json data.
        postData = [NSJSONSerialization dataWithJSONObject:parameterDictionary
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    }
    
    // Here we are taking the length of the parameters.
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    // Setting the content length in http header field.
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // Setting the http body as our parameters.
    [request setHTTPBody:postData];
    
    // Setting the http method as "POST" since we are using only post method of the http request.
    [request setHTTPMethod:@"PUT"];
    
    // Since we are using json format for the webservices so here setting the content type in the header field.
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    if (withAuthorization) {
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [request setValue:[dic valueForKey:@"auth_token"]forHTTPHeaderField:@"Authorization:Token token"];
        
    }
    
    
    // Making the refernce of the NSURLResponse class.
    NSURLResponse * response = nil;
    
    // Here making the synchronous request with the NSMutableRequest we have formed.
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    // Now, here checking whether we are getting an error as a reponse?
    if (error) {
        
        //NSLog(@"Error = %@",error);
        // return nil;
        
    }
    
    // If the response data is coming as nil then we are returning nil as a response data.
    if (responseData == nil) {
        
        //NSLog(@"Nil Data Response");
        return nil;
        
    }
    
    // Converting the reponse into the json format.
    id parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    //NSLog(@"response is %@", parseData);
    
    // Whether the parsed data is of dictionary type.
    if ([parseData isKindOfClass:[NSDictionary class]]) {
        
        //NSLog(@"Dictionary");
        
    }
    
    // If it is of array type.
    else if ([parseData isKindOfClass:[NSArray class]]){
        
        //NSLog(@"Array");
        
    }
    
    // If it is of string type.
    else if ([parseData isKindOfClass:[NSString class]]){
        
        //NSLog(@"String");
        
    }
    
    // Unknown format.
    else{
        
        //NSLog(@"Unknown kind response");
        
    }
    
    // Returning the parsed data.
    return parseData;
    
}



+(id) makeDeleteConnectionRequestWithURL:(NSString *)urlString withAuthorization:(BOOL) withAuthorization{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:20];
    
    [request setHTTPMethod: @"DELETE"];
    
    if (withAuthorization) {
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [request setValue:[dic valueForKey:@"auth_token"]forHTTPHeaderField:@"Authorization:Token token"];
        
    }
    
    NSError *error = nil;
    
    // Making the refernce of the NSURLResponse class.
    NSURLResponse * response = nil;
    
    // Here making the synchronous request with the NSMutableRequest we have formed.
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Now, here checking whether we are getting an error as a reponse?
    if (error) {
        
        //NSLog(@"Error = %@",error);
        // return nil;
        
    }
    
    // If the response data is coming as nil then we are returning nil as a response data.
    if (responseData == nil) {
        
        //NSLog(@"Nil Data Response");
        return nil;
        
    }
    
    // Converting the reponse into the json format.
    id parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    //NSLog(@"response is %@", parseData);
    
    // Whether the parsed data is of dictionary type.
    if ([parseData isKindOfClass:[NSDictionary class]]) {
        
        //NSLog(@"Dictionary");
        
    }
    
    // If it is of array type.
    else if ([parseData isKindOfClass:[NSArray class]]){
        
        //NSLog(@"Array");
        
    }
    
    // If it is of string type.
    else if ([parseData isKindOfClass:[NSString class]]){
        
        //NSLog(@"String");
        
    }
    
    // Unknown format.
    else{
        
        //NSLog(@"Unknown kind response");
        
    }
    
    // Returning the parsed data.
    return parseData;
    
}


@end
