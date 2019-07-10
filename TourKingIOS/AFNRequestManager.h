//
//  AFNRequestManager.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/3.
//  Copyright © 2019 default. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

// server product
#define BASE_URL @"https://apis.kingtrip.vip/v5"
// image server
#define IMG_URL @"https://apis.kingtrip.vip/v5"

#pragma mark - networking request type
enum HTTP_METHOD {
    METHOD_GET = 0,
    METHOD_POST = 1
};
@interface SessionManager : AFHTTPSessionManager

+ (instancetype)defaultManager;

@end


@interface AFNRequestManager : NSObject

/**
 class function
 
 @return AFNReequestManager instance
 */
+ (AFNRequestManager *)sharedUtil;

/**
 AFNetworking request
 
 @param urlString server
 @param method get or post
 @param params querys...
 @param data body
 @param succeed block
 @param failure block
 */
+ (void)requestAFURL:(NSString *)urlString httpMethod:(NSInteger)method params:(id)params data:(id)data succeed:(void(^)(NSDictionary *ret))succeed failure:(void(^)(NSError* error))failure;


/**
 upload a single image
 
 @param urlString server
 @param params parameters
 @param imageData image data
 @param succeed block
 @param failure block
 */
+ (void)requestAFURL:(NSString *)urlString params:(id)params data:(id)data imageData:(NSData *)imageData succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure;


/**
 update multiple images
 
 @param urlString server
 @param params parameters
 @param imageDataArray image data array
 @param succeed block
 @param failure block
 */
+ (void)requestAFURL:(NSString *)urlString params:(id)params imageDataArray:(NSArray *)imageDataArray succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure;

/**
 upload a single file
 
 @param urlString server
 @param params parameters
 @param fileData file data
 @param succeed block
 @param failure block
 */
+ (void)requestAFURL:(NSString *)urlString params:(id)params fileData:(NSData *)fileData succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure;

/**
 convert json string to NSDictionary
 
 @param jsonString json string
 @return json dictionary
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**
 convert json dictioinary to json string
 
 @param paramDict json dictionary
 @param _type <#_type description#>
 @return json string
 */
+ (NSString *)URLEncryOrDecryString:(NSDictionary *)paramDict isHead:(BOOL)_type;


/**
 convert object to json string
 
 @param infoDict oc-objecdt
 @return json string
 */

+ (NSString*)convertToJSONData:(id)infoDict;

+ (void)showError:(NSString *)error;
@end
