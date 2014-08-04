//
//  BNUtilities.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 1/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNUtilities : NSObject

+ (UIColor *)colorWithHexString:(NSString*)hex;
+ (NSDate *)formatDateString:(NSString *)string withDateFormat:(NSString *)format;
+ (NSString *)formatDateToString:(NSDate *)date withDateFormat:(NSString *)format;
+ (NSArray *)sortFriendInfoArray:(NSArray *)friendInfoArray;

@end
