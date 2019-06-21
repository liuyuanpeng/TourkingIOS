//
//  NowOrders.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/14.
//  Copyright © 2019 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NowOrdersDelegate <NSObject>
- (void) showModalWithOrder: (NSDictionary *_Nullable)order;
@end

NS_ASSUME_NONNULL_BEGIN

@interface NowOrders : NSObject

+ (NowOrders *)shareInstance;
- (void)insertTrashOrder:(NSString *)OrderId;

- (void)startListen;
- (void)stopListen;
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, weak) id<NowOrdersDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
