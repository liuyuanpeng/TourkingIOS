//
//  UILabel+align.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/12/1.
//  Copyright © 2019 default. All rights reserved.
//

#import "UILabel+align.h"


@implementation UILabel (align)
- (void)alignTop
{
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
    
    

    CGFloat finalHeight = fontSize.height * self.numberOfLines;
    CGFloat finalWidth = self.frame.size.width;    //expected width of label
    
    CGRect theStringRect =  [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil];


    int newLinesToPad = (finalHeight  - theStringRect.size.height) / fontSize.height;

    for(int i=0; i<= newLinesToPad; i++)
    {
        self.text = [self.text stringByAppendingString:@" \n"];
    }
}

- (void)alignBottom
{
       CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
    
    

    CGFloat finalHeight = fontSize.height * self.numberOfLines;
    CGFloat finalWidth = self.frame.size.width;    //expected width of label
    
    CGRect theStringRect =  [self.text boundingRectWithSize:CGSizeMake(finalWidth, finalHeight) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil];


    int newLinesToPad = (finalHeight  - theStringRect.size.height) / fontSize.height;

    for(int i=0; i< newLinesToPad; i++)
    {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    }
}

@end
