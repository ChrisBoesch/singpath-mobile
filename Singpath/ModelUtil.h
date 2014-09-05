//
//  ModelUtil.h
//  Singpath
//
//  Created by Rishik Bahri on 28/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//

#import <CoreData/CoreData.h>


NSManagedObjectContext *
defaultManagedObjectContext();

BOOL
commitDefaultMOC();

void
rollbackDefaultMOC();

void
deleteManagedObjectFromDefaultMOC(NSManagedObject *managedObject);

NSArray *
fetchManagedObjects(NSString *entityName, NSPredicate *predicate, NSArray *sortDescriptors, NSManagedObjectContext *moc);

NSManagedObject *
fetchManagedObject(NSString *entityName, NSPredicate *predicate, NSArray *sortDescriptors, NSManagedObjectContext *moc);
