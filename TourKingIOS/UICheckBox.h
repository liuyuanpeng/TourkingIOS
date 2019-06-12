//
//  UICheckBox.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/8.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICheckBox : UIButton
/**
 *  复选框选中状态
 */
@property (nonatomic)BOOL isChecked;

/**
 *  用frame初始化checkbox按钮
 */
- (UICheckBox *)initWithFrame:(CGRect)frame;
/**
 *  设置未选中图片
 */
- (void)setNormalImage:(UIImage*)normalImage;
/**
 *  设置选中图片
 */
- (void)setSelectedImage:(UIImage*)selectedImage;
/**
 *  设置选中和未选中图片
 */
- (void)setImage:(UIImage*)normalImage andSelectedImage:(UIImage*)selectedImage;


/**
 *  用字符串设置未选中图片
 */
- (void)setNormalImageWithName:(NSString*)normalImageName;
/**
 *  用字符串设置选中图片
 */
- (void)setSelectedImageWithName:(NSString*)selectedImageName;
/**
 *  用字符串设置图片
 */
- (void)setImageWithName:(NSString*)normalImageName andSelectedName:(NSString*)selectedImageName;
/**
 * 按钮点击事件，点击后取反按钮状态
 */
-(void)checkboxClick;

@end

NS_ASSUME_NONNULL_END
