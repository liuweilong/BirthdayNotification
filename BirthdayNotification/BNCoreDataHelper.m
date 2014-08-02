//
//  BNCoreDataHelper.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 2/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNCoreDataHelper.h"
#import "FriendInfo.h"

@implementation BNCoreDataHelper

+ (BOOL)storeFriendInfo:(NSDictionary *)dict managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    if ([[dict objectForKey:@"basicInformation"] isEqual: [NSNull null]]) {
        NSLog(@"Basic is null");
        return FALSE;
    }
    
    NSError *error;
    NSManagedObjectContext *context = managedObjectContext;
    FriendInfo *friendInfo = [NSEntityDescription
                              insertNewObjectForEntityForName:@"FriendInfo"
                              inManagedObjectContext:context];
    friendInfo.id = [dict objectForKey:@"id"];
    friendInfo.name = (NSString *)[dict objectForKey:@"name"];
    friendInfo.basicInformation = [dict objectForKey:@"basicInformation"];
    friendInfo.avatar = [dict objectForKey:@"avatar"];
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return FALSE;
    }
    return TRUE;
}

+ (NSArray *)queryFriendInOfEntity:(NSString *)entityName managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSError *error;
    
    //Fetch result
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return result;
}

+ (void)clearAnEntity:(NSString *)entityName managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * result = [managedObjectContext executeFetchRequest:request error:&error];
    
    //error handling goes here
    for (NSManagedObject * object in result) {
        [managedObjectContext deleteObject:object];
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
}

@end
