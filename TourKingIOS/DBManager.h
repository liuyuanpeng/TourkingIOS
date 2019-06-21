//
//  DBManager.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/20.
//  Copyright © 2019 default. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject
+ (instancetype)shareInstance;

- (void)createTable;

- (void)insertData:(NSString *)orderId;

- (void)closeDB;

- (void)deleteOrders;

- (BOOL)selectData:(NSString *)orderId;

@end

NS_ASSUME_NONNULL_END
