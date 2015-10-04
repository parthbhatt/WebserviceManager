//
//  PBServiceManager.m
//
//  Created by Parth Bhatt on 21/09/15.
//  Copyright (c) 2015 Parth Bhatt. All rights reserved.
//
// This is a webservice manager component which request the web and returns the error and response in completion block.
//

#import "PBServiceManager.h"

@implementation PBServiceManager

+(void)requestURL:(NSURL *)serviceURL responseCallback:(ResponseCallback)callback
{
    ResponseCallback completionHandler = callback;
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:serviceURL];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.timeoutIntervalForRequest  = 60;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if(!error)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
            NSInteger responseCode = httpResponse.statusCode;
            
            if(responseCode == 200)
            {
                NSError *jsonError = nil;
                NSMutableDictionary *jsonResponseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                completionHandler(jsonResponseDict,jsonError);
            }
            else
            {
                NSError *error = [[NSError alloc] initWithDomain:@"Invalid Response Status Code" code:201 userInfo:@{response.description:@"ErrorDescription"}];
                //Error completion handler
                completionHandler(nil,error);
            }
        }
        else
        {
            //Error completion handler
            completionHandler(nil,error);
        }
    }];
    [dataTask resume];
}

+(void)requestURL:(NSURL *)serviceURL withDict:(NSDictionary *)dictParmaters responseCallback:(ResponseCallback)callback
{
    NSData *jsonRequestBody = [NSJSONSerialization dataWithJSONObject:dictParmaters options:0 error:nil];
    
    ResponseCallback completionHandler = callback;
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:serviceURL];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:[NSString stringWithFormat:@"%lu",(unsigned long)jsonRequestBody.length] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody:jsonRequestBody];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.timeoutIntervalForRequest  = 60;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if(!error)
                                          {
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
                                              NSInteger responseCode = httpResponse.statusCode;
                                              
                                              if(responseCode == 200)
                                              {
                                                  NSError *jsonError = nil;
                                                  NSMutableDictionary *jsonResponseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                                                  completionHandler(jsonResponseDict,jsonError);
                                              }
                                              else
                                              {
                                                  NSError *error = [[NSError alloc] initWithDomain:@"Invalid Response Status Code" code:201 userInfo:@{response.description:@"ErrorDescription"}];
                                                  //Error completion handler
                                                  completionHandler(nil,error);
                                              }
                                          }
                                          else
                                          {
                                              //Error completion handler
                                              completionHandler(nil,error);
                                          }
                                      }];
    [dataTask resume];
}

@end
