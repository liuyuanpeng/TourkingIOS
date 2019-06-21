//
//  MonthPickerView.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/13.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MonthPickerView;

@protocol MonthPickerViewDelegate <NSObject>

- (void) monthPickerViewDidChangeDate: (MonthPickerView *)picker year:(NSInteger)year month:(NSInteger)month;

@end

typedef NS_OPTIONS(NSInteger, MonthPickerViewFormat) {
    MonthPickerViewFormatMonth = 1,
    MonthPickerViewFormatYear = 1<<1
};

@interface MonthPickerView : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) id<MonthPickerViewDelegate> monthPickerViewDelegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) MonthPickerViewFormat format;
@property (nonatomic, strong) NSString *monthFormat;
@property (nonatomic, assign) NSRange yearRange;
@property (nonatomic, strong) NSString *yearFormat;

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
