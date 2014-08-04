//
//  BNUtilities.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 1/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNUtilities.h"

@implementation BNUtilities

+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (NSDate*)formatDateString:(NSString *)string withDateFormat:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:string];
    
    if (date == nil) {
        NSArray *caseHandledArray = [string componentsSeparatedByString:@"-"];
        NSString *caseHandledString = [NSString stringWithFormat:@"%@-%@", caseHandledArray[1], caseHandledArray[2]];
        [dateFormat setDateFormat:@"M-d"];
        date = [dateFormat dateFromString:caseHandledString];
    }
    
    return date;
}

+ (NSString *)formatDateToString:(NSDate *)date withDateFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSArray *)sortFriendInfoArray:(NSArray *)friendInfoArray {
    return friendInfoArray;
}

@end
