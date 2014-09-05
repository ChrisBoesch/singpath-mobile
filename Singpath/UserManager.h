//
//  UserManager.h
//  Singpath
//
//  Created by Rishik Bahri on 28/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import "Users.h"
#import "ModelUtil.h"


@interface Users ( Management )

+(Users*)insertUser:(BOOL)sound managedObjectContext:(NSManagedObjectContext*)moc;
+(Users*)insertUser:(BOOL)sound;

+(NSArray *)getAllUsers;


@end