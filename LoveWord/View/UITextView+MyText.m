//
//  UITextView+MyText.m
//  LoveWord
//
//  Created by xiongchao on 16/1/24.
//  Copyright © 2016年 xiongchao. All rights reserved.
//

#import "UITextView+MyText.h"

@implementation UITextView (MyText)

-(NSString *)strToPoint:(CGPoint)point
{
    //根据点击坐标获取点击的文本位置
    UITextPosition* pos = [self closestPositionToPoint:point];
 
    if(pos)
    {
        UITextRange *textRange = [self.tokenizer rangeEnclosingPosition:pos withGranularity:UITextGranularityWord inDirection:UITextWritingDirectionLeftToRight];
        NSRange range = [self NSRangeFromUITextRange:textRange];
        NSString *string = [self.text substringWithRange:range];
        return string;
    }
    else
    {
        return nil;
    }
}

//根据UITextRange转换成 NSRange
- (NSRange)NSRangeFromUITextRange:(UITextRange *)textRange
{
    UITextPosition* selectionStart = textRange.start;
    UITextPosition* selectionEnd = textRange.end;
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    NSRange range = NSMakeRange(location, length);
    return range;
}

@end


