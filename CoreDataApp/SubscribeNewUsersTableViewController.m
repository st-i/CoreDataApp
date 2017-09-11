//
//  SubscribedUsersTableViewController.m
//  CoreDataApp
//
//  Created by iStef on 14.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "SubscribeNewUsersTableViewController.h"
#import "AllCoursesTableViewController.h"
#import "User+CoreDataClass.h"
#import "User+CoreDataProperties.h"
#import "DataManager.h"

@interface SubscribeNewUsersTableViewController ()

@property (strong, nonatomic) NSMutableArray<User *>* currentUsers;
@property (strong, nonatomic) NSMutableArray<User *>* secondaryCurrentUsersList;

@property (strong, nonatomic) NSMutableDictionary *coursesOfUsers;

@end

@implementation SubscribeNewUsersTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUsers = nil;
    self.currentUsers = [NSMutableArray arrayWithArray:[self.currentCourse.users allObjects]];
    
    self.secondaryCurrentUsersList = nil;
    self.secondaryCurrentUsersList = [NSMutableArray array];
    
    NSSortDescriptor *firstNameDesc = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDesc = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.currentUsers];
    
    [array sortUsingDescriptors:@[firstNameDesc, lastNameDesc]];
    
    self.secondaryCurrentUsersList = array;
    
    self.coursesOfUsers = nil;
    self.coursesOfUsers = [NSMutableDictionary dictionary];
    
    //NSLog(@"LOADED!");
    //NSLog(@"Table VC course: %@", self.currentCourse.nameOfCourse);
    
    self.navigationItem.title = @"Users";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToCourseAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveNewSubscribers:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)saveNewSubscribers:(UIBarButtonItem *)item
{
    for (User *user in self.currentUsers) {
        NSArray *userCourses = [self.coursesOfUsers objectForKey:user.email];
        user.courses = nil;
        NSSet<Course *> *aSet = [NSSet set];
        [user addCourses:[aSet setByAddingObjectsFromArray:userCourses]];
    }
    
    NSSet<User *> *set = [NSSet set];
    self.currentCourse.users = nil;
    [self.currentCourse addUsers:[set setByAddingObjectsFromArray:self.currentUsers]];
    
    /*NSError *error = nil;
    if (![[DataManager sharedManager].persistentContainer.viewContext save:&error]) {
        NSLog(@"ERROR DURING SAVING NEW SUBSCRIBED USERS: %@", error.localizedDescription);
    }*/
    
    [[DataManager sharedManager] saveContext];
    
    //NSLog(@"SUBSCRIBED USERS: %lu", [self.currentCourse.users count]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)backToCourseAction:(UIBarButtonItem *)item
{
    self.currentUsers = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Fetched Results Controller

-(NSFetchedResultsController <User *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest <User *> *userRequest = User.fetchRequest;
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [userRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:userRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"SUBSCRIBING USER PROCESS ERROR: %@", error.localizedDescription);
    }
    
    _fetchedResultsController = aFetchedResultsController;
    
    return _fetchedResultsController;
}

-(void)configureCell:(UITableViewCell *)cell withEvent:(User *)event
{
    if ([self.currentUsers containsObject:event]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([event.firstName isEqualToString:@""]) {
        cell.textLabel.text = event.lastName;
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", event.firstName, event.lastName];
    }
    
    cell.detailTextLabel.text = event.email;
    
    if ([event.courses count] == 0) {
        NSMutableArray *courses = [NSMutableArray array];
        [self.coursesOfUsers setObject:courses forKey:event.email];
    }else{
        NSArray *courses = event.courses.allObjects;
        [self.coursesOfUsers setObject:courses forKey:event.email];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        [self.currentUsers addObject:user];
        
        NSMutableArray *courses = [NSMutableArray arrayWithArray:[self.coursesOfUsers objectForKey:user.email]];
        [courses addObject:self.currentCourse];
        [self.coursesOfUsers setObject:courses forKey:user.email];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        [self.currentUsers removeObject:user];
        
        NSMutableArray *userCourses = [NSMutableArray arrayWithArray:[self.coursesOfUsers objectForKey:user.email]];
        [userCourses removeObject:self.currentCourse];
        //[self.coursesOfUsers removeObjectForKey:user.email];
        [self.coursesOfUsers setObject:userCourses forKey:user.email];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSSortDescriptor *firstNameDesc = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDesc = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [self.currentUsers sortUsingDescriptors:@[firstNameDesc, lastNameDesc]];
    
    if ([self.secondaryCurrentUsersList isEqual:self.currentUsers]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}


@end
