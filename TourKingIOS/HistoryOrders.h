//
//  HistoryOrders.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/14.
//  Copyright © 2019 default. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryOrders : NSObject
+ (HistoryOrders *)shareInstance;
- (void)getList:(void(^)(BOOL ok))loadingOK;
- (void)loadMore:(void(^)(BOOL ok))loadingOK;
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL noMore;
@end

NS_ASSUME_NONNULL_END
