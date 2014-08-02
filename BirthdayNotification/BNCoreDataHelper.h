//
//  BNCoreDataHelper.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 2/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNCoreDataHelper : NSObject

+ (BOOL)storeFriendInfo:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSArray *)queryFriendInOfEntity:(NSString *)entityName managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (void)clearAnEntity:(NSString *)entityName managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
