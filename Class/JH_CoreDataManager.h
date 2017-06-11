//
//  JH_ChatMessageManager.h
//  note_ios_app
//
//  Created by 江弘 on 2017/2/15.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JH_CoreDataManager : NSObject
@property (nonatomic, strong, readonly)NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (JH_CoreDataManager *)sharedInstance;

- (void)saveContext;
@end
