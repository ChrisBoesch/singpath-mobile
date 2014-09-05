//
//  ModelUtil.h
//  Singpath
//
//  Created by Rishik Bahri on 28/09/12.
//  Copyright (c) 2012 Rishik. All rights reserved.
//


#import "ModelUtil.h"


NSManagedObjectContext *
defaultManagedObjectContext()
{
	NSManagedObjectContext *moc = nil;
	
	id appDelegate = [[UIApplication sharedApplication] delegate];
	if ([appDelegate respondsToSelector:@selector(managedObjectContext)]) {
		moc = [appDelegate managedObjectContext];
	}
	
	return moc;
}

BOOL
commitDefaultMOC()
{
	NSManagedObjectContext *moc = defaultManagedObjectContext();
	NSError *error = nil;
	if (![moc save:&error]) {
		// Save failed
		NSLog(@"Core Data Save Error: %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

void
rollbackDefaultMOC()
{
	NSManagedObjectContext *moc = defaultManagedObjectContext();
	[moc rollback];
}

void
deleteManagedObjectFromDefaultMOC(NSManagedObject *managedObject)
{
	NSManagedObjectContext *moc = defaultManagedObjectContext();
	[moc deleteObject:managedObject];
}

NSArray *
fetchManagedObjects(NSString *entityName, NSPredicate *predicate, NSArray *sortDescriptors, NSManagedObjectContext *moc)
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:moc]];
	
	// Add a sort descriptor. Mandatory.
	[fetchRequest setSortDescriptors:sortDescriptors];
	fetchRequest.predicate = predicate;
	
	NSError *error;
	NSArray *fetchResults = [moc executeFetchRequest:fetchRequest error:&error];
	
	if (fetchResults == nil) {
		// Handle the error.
		NSLog(@"executeFetchRequest failed with error: %@", [error localizedDescription]);
	}
	
	
	return fetchResults;
}

NSManagedObject *
fetchManagedObject(NSString *entityName, NSPredicate *predicate, NSArray *sortDescriptors, NSManagedObjectContext *moc)
{
	NSArray *fetchResults = fetchManagedObjects(entityName, predicate, sortDescriptors, moc);
	
	NSManagedObject *managedObject = nil;
	
	if (fetchResults && [fetchResults count] > 0) {
		// Found record
		managedObject = [fetchResults objectAtIndex:0];
	}
	
	return managedObject;	
}
