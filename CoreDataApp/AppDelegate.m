//
//  AppDelegate.m
//  CoreDataApp
//
//  Created by iStef on 09.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "AppDelegate.h"
#import "User+CoreDataClass.h"
#import "User+CoreDataProperties.h"
#import "AllUsersTableViewController.h"
#import "Course+CoreDataClass.h"
#import "Course+CoreDataProperties.h"
#import "Teacher+CoreDataClass.h"
#import "Teacher+CoreDataProperties.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
    // Override point for customization after application launch.
    
    /*NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSError *error = nil;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
    [request setEntity:entityDescription];
    
    NSArray *teachers = [[DataManager sharedManager].persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    
    if (error) {
        NSLog(@"TEACHERS ERROR: %@", error.localizedDescription);
    }
    
    for (Teacher *teacher in teachers) {
        NSLog(@"%@ %@", teacher.firstName, teacher.lastName);
    }*/
    
    /*
    Course *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
    course.nameOfCourse = @"Finances";
    course.subject = @"Corporate finance";
    course.branch = @"Economics";
    
    NSError *error = nil;
    
    if (![[DataManager sharedManager].persistentContainer.viewContext save:&error]) {
        NSLog(@"ERROR: %@", error.localizedDescription);
    }
    */
    /*NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSError *error = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
    [request setEntity:entity];
    
    NSArray *array = [[DataManager sharedManager].persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"ERROR 1: %@", error.localizedDescription);
    }
    
    for (Course *course in array) {
        NSLog(@"%lu", [course.users count]);
    }*/
    
    //NSLog(@"%@", [self.managedObjectModel entities]);
    //NSLog(@"%@", [[DataManager sharedManager].persistentContainer.managedObjectModel entities]);
    /*
    NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
    [user setValue:@"Ann" forKey:@"firstName"];
    [user setValue:@"Bardo" forKey:@"lastName"];
    [user setValue:@"bardo@bk.ru" forKey:@"email"];

    NSError *error = nil;
    if (![[DataManager sharedManager].persistentContainer.viewContext save:&error]) {
        NSLog(@"ERROR: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
    
    [request setEntity:entityDescription];
    //[request setResultType:NSDictionaryResultType];
    
    NSError *requestError = nil;
    
    NSArray *resultArray = [[DataManager sharedManager].persistentContainer.viewContext executeFetchRequest:request error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    //NSLog(@"%@", resultArray);
    
    for (User *user in resultArray) {
        NSLog(@"%@ %@: %@", [user firstName], user.lastName, user.email);
        //NSLog(@"%@", user);
    }*/
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

/*-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}*/
/*
#pragma mark - Core Data stack

-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL
                           ];
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataApp.sqlite"];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    return _persistentStoreCoordinator;
}*/

#pragma mark - Core Data Saving support

/*- (void)saveContext {
    //NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}*/

@end
