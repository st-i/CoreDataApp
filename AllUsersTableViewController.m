//
//  AllUsersTableViewController.m
//  CoreDataApp
//
//  Created by iStef on 11.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "AllUsersTableViewController.h"
#import "User+CoreDataClass.h"
#import "User+CoreDataProperties.h"
#import "UserInfoTableViewController.h"
#import "AllCoursesTableViewController.h"
#import "DataManager.h"

@interface AllUsersTableViewController ()

@end

@implementation AllUsersTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //AllCoursesTableViewController *courses = [storyboard instantiateViewControllerWithIdentifier:@"AllCoursesTableViewController"];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Users" image:[UIImage imageNamed:@"Users.png"] tag:0];
    //courses.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Courses" image:[UIImage imageNamed:@"Courses.png"] tag:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUserAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editUsersAction:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)addUserAction:(UIBarButtonItem *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserInfoTableViewController *userInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"UserInfoTableViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
    
    navController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:navController animated:YES completion:nil];
    
    UIPopoverPresentationController *popoverPC = [navController popoverPresentationController];
    popoverPC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverPC.sourceView = sender.customView;
    popoverPC.sourceRect = sender.accessibilityFrame;
    
    userInfoVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToUsersListAction:)];
}

-(void)backToUsersListAction:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)editUsersAction:(UIBarButtonItem *)sender
{
    UIBarButtonSystemItem item = UIBarButtonSystemItemDone;
    
    if (self.tableView.editing) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.tableView setEditing:NO animated:YES];
        item = UIBarButtonSystemItemEdit;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.tableView setEditing:YES animated:YES];
    }
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(editUsersAction:)];
    
    self.navigationItem.leftBarButtonItem = buttonItem;
}


#pragma mark - Fetched Results Controller

-(NSFetchedResultsController<User *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<User *> *fetchRequest = User.fetchRequest;
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];

    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController<User *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"USER ERROR: %@, %@", error, [error userInfo]);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    
    return _fetchedResultsController;
}

-(void)configureCell:(UITableViewCell *)cell withEvent:(User *)event
{
    if ([event.firstName isEqualToString:@""]) {
        cell.textLabel.text = event.lastName;
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", event.firstName, event.lastName];
    }
    
    cell.detailTextLabel.text = event.email;
}

#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"ERROR DURING DELETING: %@", error.localizedDescription);
            abort();
        }
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserInfoTableViewController *userInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"UserInfoTableViewController"];
    
    userInfoVC.firstName = user.firstName;
    userInfoVC.lastName = user.lastName;
    userInfoVC.email = user.email;
    
    userInfoVC.user = user;
    
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

@end
