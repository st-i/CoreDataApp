//
//  AllCoursesTableViewController.m
//  CoreDataApp
//
//  Created by iStef on 12.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "AllCoursesTableViewController.h"
#import "Course+CoreDataClass.h"
#import "Course+CoreDataProperties.h"
#import "DataManager.h"
#import "CourseInfoTableViewController.h"

@interface AllCoursesTableViewController ()

@property (strong, nonatomic) Course *course;

@end

@implementation AllCoursesTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"LOADED!");
    
    //.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Courses" image:[UIImage imageNamed:@"Courses.png"] tag:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCourseAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editUsersAction:)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)addCourseAction:(UIBarButtonItem *)item
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CourseInfoTableViewController *courseInfoTVC = [storyboard instantiateViewControllerWithIdentifier:@"CourseInfoTableViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:courseInfoTVC];
    
    navController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:navController animated:YES completion:nil];
    
    UIPopoverPresentationController *popoverPC = [navController popoverPresentationController];
    popoverPC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverPC.sourceView = item.customView;
    popoverPC.sourceRect = item.accessibilityFrame;
    
    courseInfoTVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToCoursesListAction:)];
    
    Course *currentCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
    
    currentCourse.nameOfCourse = @"";
    currentCourse.subject = @"";
    currentCourse.branch = @"";
    currentCourse.teacher = nil;
    
    self.course = currentCourse;
    courseInfoTVC.course = self.course;
}

-(void)backToCoursesListAction:(UIBarButtonItem *)item
{
    if (self.course.teacher == nil && self.course.users.count == 0) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:self.course];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"ERROR DURING COURSE DELETING: %@", error.localizedDescription);
            abort();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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

-(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *request = [Course fetchRequest];
    
    NSSortDescriptor *nameOfCourseDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameOfCourse" ascending:YES];
    NSSortDescriptor *teacherLastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"teacher.lastName" ascending:YES];
    
    [request setSortDescriptors:@[nameOfCourseDescriptor, teacherLastNameDescriptor]];
    
    [request setFetchBatchSize:20];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"COURSE ERROR: %@", error.localizedDescription);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    
    return _fetchedResultsController;
}

-(void)configureCell:(UITableViewCell *)cell withEvent:(Course *)event
{
    cell.textLabel.text = event.nameOfCourse;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", event.teacher.firstName, event.teacher.lastName];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CourseInfoTableViewController *courseInfoTVC = [storyboard instantiateViewControllerWithIdentifier:@"CourseInfoTableViewController"];
    
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    courseInfoTVC.courseName = course.nameOfCourse;
    courseInfoTVC.courseSubject = course.subject;
    courseInfoTVC.courseBranch = course.branch;
    
    courseInfoTVC.course = course;
        
    [self.navigationController pushViewController:courseInfoTVC animated:YES];
}


@end
