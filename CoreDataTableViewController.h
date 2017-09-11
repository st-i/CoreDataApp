//
//  CoreDataTableViewController.h
//  CoreDataApp
//
//  Created by iStef on 11.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)configureCell:(UITableViewCell *)cell withEvent:(NSManagedObject *)event;

@end
