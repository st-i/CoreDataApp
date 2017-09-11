//
//  AllTeachersTVC.m
//  CoreDataApp
//
//  Created by iStef on 16.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "AllTeachersTVC.h"
#import "TeacherInfoTVC.h"
#import "Teacher+CoreDataClass.h"
#import "Teacher+CoreDataProperties.h"

@interface AllTeachersTVC ()

@end

@implementation AllTeachersTVC

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTeacherAction:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTeachersAction:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)addTeacherAction:(UIBarButtonItem *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TeacherInfoTVC *teacherInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"TeacherInfoTVC"];
    teacherInfoVC.teacher = nil;
    
    [self.navigationController pushViewController:teacherInfoVC animated:YES];
}

-(void)editTeachersAction:(UIBarButtonItem *)sender
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
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(editTeachersAction:)];
    
    self.navigationItem.leftBarButtonItem = buttonItem;
}


#pragma mark - Fetched Results Controller

-(NSFetchedResultsController<Teacher *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Teacher *> *fetchRequest = Teacher.fetchRequest;
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController<Teacher *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"USER ERROR: %@, %@", error, [error userInfo]);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    
    return _fetchedResultsController;
}

-(void)configureCell:(UITableViewCell *)cell withEvent:(Teacher *)event
{
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", event.firstName, event.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", [event.courses count]];
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
    
    Teacher *teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TeacherInfoTVC *teacherInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"TeacherInfoTVC"];
    
    teacherInfoVC.firstName = teacher.firstName;
    teacherInfoVC.lastName = teacher.lastName;
    
    teacherInfoVC.teacher = teacher;
    
    [self.navigationController pushViewController:teacherInfoVC animated:YES];
}


@end
