//
//  AlertView.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/20.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface AlertView : UIView
+(AlertView *) initWithCancelBlock:(btnBlock)cancelBlock okBlock:(btnBlock)okBlock;
@property (nonatomic, copy) btnBlock cancelBlock;
@property (nonatomic, copy) btnBlock okBlock;
@end

NS_ASSUME_NONNULL_END
