//
//  PBServiceManager.h
//
//  Created by Parth Bhatt on 21/09/15.
//  Copyright (c) 2015 Parth Bhatt. All rights reserved.
//
// This is a webservice manager component which request the web and returns the error and response in completion block.
//

#import <Foundation/Foundation.h>

typedef void (^ResponseCallback)(NSMutableDictionary *dictData, NSError *error);

@interface PBServiceManager : NSObject
{
    
}
/**
 * This method is used to request a web service with type GET. It handles the response using block.
 * @param serviceURL This is the service URL.
 * @param callback It is completion block.
 */
+(void)requestURL:(NSURL *)serviceURL responseCallback:(ResponseCallback)callback;

/**
 * This method is used to request a web service with type POST. It handles the response using block.
 * @param serviceURL This is the service URL.
 * @param dictParmaters It is dictionary of parameters.
 * @param callback It is completion block.
 */
+(void)requestURL:(NSURL *)serviceURL withDict:(NSDictionary *)dictParmaters responseCallback:(ResponseCallback)callback;
@end
