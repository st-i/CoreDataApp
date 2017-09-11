//
//  AppointTeacherTVC.m
//  CoreDataApp
//
//  Created by iStef on 16.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "AppointTeacherTVC.h"
#import "DataManager.h"
#import "Teacher+CoreDataClass.h"
#import "Teacher+CoreDataProperties.h"

@interface AppointTeacherTVC ()

@property (strong, nonatomic) NSMutableArray<Course *>* currentTeacherCourses;

@property (strong, nonatomic) Teacher *currentTeacher;
@property (strong, nonatomic) Teacher *temporaryCurrentTeacher;

@property (strong, nonatomic) UITableViewCell *selectedCell;


@end

@implementation AppointTeacherTVC

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentTeacher = self.currentCourse.teacher;
    self.temporaryCurrentTeacher = self.currentCourse.teacher;
    
    self.currentTeacherCourses = [NSMutableArray array];
    
    /*NSMutableArray *array;
    
    if ([self.currentTeacher.courses count] == 0) {
        array = [NSMutableArray array];
    }else{
        array = [NSMutableArray arrayWithArray:[self.currentTeacher.courses allObjects]];
    }
    
    NSSortDescriptor *nameOfCourseDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameOfCourse" ascending:YES];
    NSSortDescriptor *teacherLastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"teacher.lastName" ascending:YES];

    [array sortUsingDescriptors:@[nameOfCourseDescriptor, teacherLastNameDescriptor]];
    
    self.currentTeacherCourses = array;*/
    
    self.navigationItem.title = @"Teachers";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToCourseAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveNewCourseTeacher:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)saveNewCourseTeacher:(UIBarButtonItem *)item
{
    self.currentCourse.teacher = self.currentTeacher;
    NSSet<Course *> *set = [NSSet set];
    self.currentTeacher.courses = [set setByAddingObjectsFromArray:self.currentTeacherCourses];
    
    [[DataManager sharedManager] saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)backToCourseAction:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Fetched Results Controller

-(NSFetchedResultsController <Teacher *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest <Teacher *> *teacherRequest = Teacher.fetchRequest;
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [teacherRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:teacherRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"APPOINTING TEACHER PROCESS ERROR: %@", error.localizedDescription);
    }
    
    _fetchedResultsController = aFetchedResultsController;
    
    return _fetchedResultsController;
}

-(void)configureCell:(UITableViewCell *)cell withEvent:(Teacher *)event
{
   
    
    if ([event isEqual:self.currentTeacher]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedCell = cell;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", event.firstName, event.lastName];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    Teacher *teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([cell isEqual:self.selectedCell]) {
        if (self.selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            self.selectedCell.accessoryType = UITableViewCellAccessoryNone;
            
            NSMutableArray *currentArray = [NSMutableArray arrayWithArray:teacher.courses.allObjects];
            [currentArray removeObject:self.currentCourse];
            self.currentTeacherCourses = currentArray;
            
            self.selectedCell = nil;
            self.currentTeacher = nil;
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else{
            self.selectedCell.accessoryType = UITableViewCellAccessoryNone;
            
            NSMutableArray *currentArray = [NSMutableArray arrayWithArray:teacher.courses.allObjects];
            [currentArray addObject:self.currentCourse];
            self.currentTeacherCourses = currentArray;
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.currentTeacher = teacher;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }else{
        self.selectedCell.accessoryType = UITableViewCellAccessoryNone;
        
        NSMutableArray *currentArray = [NSMutableArray arrayWithArray:teacher.courses.allObjects];
        [currentArray addObject:self.currentCourse];
        self.currentTeacherCourses = currentArray;
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentTeacher = teacher;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }

    if ([self.temporaryCurrentTeacher isEqual:teacher] || self.currentTeacher == nil) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    self.selectedCell = cell;
}

@end
