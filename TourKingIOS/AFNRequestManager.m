//
//  AFNRequestManager.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/3.
//  Copyright © 2019 default. All rights reserved.
//

#import "AFNRequestManager.h"
#import "AppDelegate.h"
#import <Toast/UIView+Toast.h>

@implementation SessionManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static SessionManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [self manager];
        // 10秒超时
        instance.requestSerializer.timeoutInterval = 10;
        // return type
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // 请求方式 json
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    });
    return instance;
}

@end

@implementation AFNRequestManager
+ (AFNRequestManager *)sharedUtil {
    static dispatch_once_t onceToken;
    static AFNRequestManager *setSharedInstance;
    dispatch_once(&onceToken, ^{
        setSharedInstance = [[AFNRequestManager alloc] init];
    });
    return setSharedInstance;
}

+ (void)requestAFURL:(NSString *)urlString httpMethod:(NSInteger)method params:(id)params data:(id)data succeed:(void (^)(NSDictionary *ret))succeed failure:(void (^)(NSError * error))failure {
    // set api addresss
    urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    // add query string...
    NSString *query = params ? AFQueryStringFromParameters(params) : nil;
    if (query && query.length) {
        urlString = [urlString stringByAppendingFormat:@"?%@", query];
    }

    SessionManager *manager = [SessionManager defaultManager];
    // 设置登录后的请求头
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"TOKEN"];
    
    // method
    switch (method) {
        case METHOD_GET:
        {
            [manager GET:urlString parameters:nil                                                                   progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *response = [AFNRequestManager dictionaryWithJsonString:responseStr];
                
                if ([[response objectForKey:@"code"] compare:@"SUCCESS"] != NSOrderedSame) {
                    [AFNRequestManager showError:[response objectForKey:@"message"]];
                    succeed(nil);
                    if ([[response objectForKey:@"code"] compare:@"TOKEN_SESSION_NOT_FOUND"] == NSOrderedSame) {
                        // token过期处理
                        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [delegate logout];
                    }
                    return;
                }
                succeed(response);
            }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure != nil) {
                    failure(error);
                }
                [AFNRequestManager showError:@"网络连接失败!"];
            }];
        }
            break;
        case METHOD_POST:
        {
            [manager POST:urlString parameters:data progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *response = [AFNRequestManager dictionaryWithJsonString:responseStr];
                if ([[response objectForKey:@"code"] compare:@"SUCCESS"] != NSOrderedSame) {
                    [AFNRequestManager showError:[response objectForKey:@"message"]];
                    succeed(nil);
                    return;
                }
                succeed(response);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure != nil) {
                    failure(error);
                }
                [AFNRequestManager showError:@"网络连接失败!"];
            }];
        }
            
        default:
            break;
    }
    
}

+ (void)requestAFURL:(NSString *)urlString params:(id)params data:(id)data imageData:(NSData *)imageData succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure {
    // set api addresss
    urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    // add query string...
    NSString *query = params ? AFQueryStringFromParameters(params) : nil;
    if (query && query.length) {
        urlString = [urlString stringByAppendingFormat:@"?%@", query];
    }

    // create request manager
    SessionManager *manager = [SessionManager defaultManager];
    
    // 设置登录后的请求头
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"TOKEN"];
    
    [manager POST:urlString parameters:data constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary *response = [AFNRequestManager dictionaryWithJsonString:responseStr];

        if ([[response objectForKey:@"code"] compare:@"SUCCESS"] != NSOrderedSame) {
            [AFNRequestManager showError:[response objectForKey:@"message"]];
            succeed(nil);
            return;
        }
        succeed(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure != nil) {
            failure(error);
        }
        [AFNRequestManager showError:@"网络连接失败!"];
    }];
    
}

+ (void)requestAFURL:(NSString *)urlString params:(id)params imageDataArray:(NSArray *)imageDataArray succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure {
    // set api addresss
    urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    // create request manager
    SessionManager *manager = [SessionManager defaultManager];
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageDataArray.count; i++) {
            NSData *imageData = imageDataArray[i];
            // rename file
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSString *name = [NSString stringWithFormat:@"image_%d.png", i];
            
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        succeed([AFNRequestManager dictionaryWithJsonString:responseStr]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


+ (void)requestAFURL:(NSString *)urlString params:(id)params fileData:(NSData *)fileData succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure {
    // set api addresss
    urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    SessionManager *manager = [SessionManager defaultManager];
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:@"audio.MP3" mimeType:@"audio/MP3"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        succeed([AFNRequestManager dictionaryWithJsonString:responseStr]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"convert to json dictionary failure: %@", error);
        return nil;
    }
    return dict;
}

+ (NSString *)URLEncryOrDecryString:(NSDictionary *)paramDict isHead:(BOOL)_type {
    NSArray *keyAll = [paramDict allKeys];
    NSString *encryString = @"";
    for (NSString *key in keyAll) {
        NSString *keyValue = [paramDict valueForKey:key];
        encryString = [encryString stringByAppendingFormat:@"&"];
        encryString = [encryString stringByAppendingFormat:@"%@", key];
        encryString = [encryString stringByAppendingFormat:@""];
        encryString = [encryString stringByAppendingFormat:@"%@", keyValue];
    }
    return encryString;
}

+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

+ (void)showError:(NSString *)error {
    if ([error isEqual:[NSNull null]]) {
        return;
    }
    UIApplication *ap = [UIApplication sharedApplication];
    [ap.keyWindow makeToast:error duration:2.0 position:CSToastPositionCenter];
}

@end

