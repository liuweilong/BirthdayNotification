//
//  FriendInfo.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 31/7/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FriendInfo : NSManagedObject

@property (nonatomic, retain) NSString * basicInformation;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;

@end
