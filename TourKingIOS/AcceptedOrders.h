//
//  AcceptedOrders.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/14.
//  Copyright © 2019 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcceptedOrders : NSObject
+ (AcceptedOrders *)shareInstance;
- (void)getList:(void(^)(BOOL ok))loadingOK;
@property (nonatomic, strong) NSArray *orders;
@end
