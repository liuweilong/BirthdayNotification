//
//  FriendInfo.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 1/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BNAppDelegate.h"


@interface FriendInfo : NSManagedObject

@property (nonatomic, retain) NSMutableDictionary * basicInformation;
@property (nonatomic, retain) NSDecimalNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSMutableDictionary * avatar;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSMutableDictionary * original;

+ (NSManagedObjectContext *)managedObjectContext;
+ (NSString *)entityName;
+ (NSEntityDescription *)entityDescription;

@end
