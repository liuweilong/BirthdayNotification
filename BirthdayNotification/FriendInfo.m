//
//  FriendInfo.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 1/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "FriendInfo.h"


@implementation FriendInfo

@dynamic basicInformation;
@dynamic id;
@dynamic name;
@dynamic avatar;
@dynamic birthday;
@dynamic original;

+ (NSManagedObjectContext *)managedObjectContext {
    return [[BNAppDelegate sharedDelegate] managedObjectContext];
}

+ (NSString *)entityName {
    return @"FriendInfo";
}

+ (NSEntityDescription *)entityDescription {
    return [NSEntityDescription entityForName:[FriendInfo entityName] inManagedObjectContext:[FriendInfo managedObjectContext]];
}

@end
