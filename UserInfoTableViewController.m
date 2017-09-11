//
//  UserInfoTableViewController.m
//  CoreDataApp
//
//  Created by iStef on 11.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "UserInfoTableViewCell.h"
#import "User+CoreDataClass.h"
#import "User+CoreDataProperties.h"
#import "DataManager.h"
#import "AllUsersTableViewController.h"
#import "Course+CoreDataClass.h"
#import "Course+CoreDataProperties.h"
#import "Teacher+CoreDataClass.h"
#import "Teacher+CoreDataProperties.h"
#import "CourseInfoTableViewController.h"

@interface UserInfoTableViewController ()

@end

@implementation UserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textFields = [NSMutableArray array];
    
    self.navigationItem.title = @"User Information";
    
    self.tableView.allowsSelection = YES;
    
    if (self.user) {
        self.user.firstName = self.firstName;
        self.user.lastName = self.lastName;
        self.user.email = self.email;
        
    }else{
        self.firstName = self.lastName = self.email = @"";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveUserInfoAction:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)saveUserInfoAction:(UIBarButtonItem *)sender
{
    if (self.user) {
        self.user.firstName = self.firstName;
        self.user.lastName = self.lastName;
        self.user.email = self.email;
        
        NSError *currentUserError = nil;
        if (![[DataManager sharedManager].persistentContainer.viewContext save:&currentUserError]) {
            NSLog(@"CURRENT USER SAVING ERROR: %@", currentUserError.localizedDescription);
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
        
        user.firstName = self.firstName;
        user.lastName = self.lastName;
        user.email = self.email;
        
        NSError *error = nil;
        
        if (![[DataManager sharedManager].persistentContainer.viewContext save:&error]) {
            NSLog(@"NEW USER SAVING ERROR: %@", error.localizedDescription);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)backToCourseAction:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textFieldEditingAction:(UITextField *)sender
{
    if (self.user) {
        switch (sender.tag) {
            case 0:
                self.firstName = sender.text;
                break;
            case 1:
                self.lastName = sender.text;
                break;
            case 2:
                self.email = sender.text;
                break;
            default:
                break;
        }
        if (![self.user.firstName isEqualToString:self.firstName] || ![self.user.lastName isEqualToString:self.lastName] || ![self.user.email isEqualToString:self.email]){

            if (self.firstName.length == 0 && self.lastName.length == 0 && self.email.length == 0) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
                
            }else if (self.firstName.length == 0 & self.lastName.length == 0) {
                if (self.email.length != 0) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                }
                
            }else{
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
            
        }else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }else{
        switch (sender.tag) {
            case 0:
                self.firstName = sender.text;
                break;
            case 1:
                self.lastName = sender.text;
                break;
            case 2:
                self.email = sender.text;
                break;
            default:
                break;
        }
        if (self.firstName.length != 0 || self.lastName.length != 0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else if (self.firstName.length == 0 && self.lastName.length == 0 && self.email.length != 0) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0 || textField.tag == 1) {
        [[self.textFields objectAtIndex:textField.tag + 1] becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark - UITableViewDataSource

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Personal Data";
    }else{
        return @"Studied Courses";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UserInfoTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"firstNameCell"];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.firstNameTF.text = self.firstName;
            [self.textFields addObject:cell1.firstNameTF];
            return cell1;
        }else if (indexPath.row == 1) {
            UserInfoTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"lastNameCell"];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.lastNameTF.text = self.lastName;
            [self.textFields addObject:cell2.lastNameTF];
            return cell2;
        }else{
            UserInfoTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"emailCell"];
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            cell3.emailTF.text = self.email;
            [self.textFields addObject:cell3.emailTF];
            return cell3;
        }
    }else{
        static NSString *identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        NSSortDescriptor *nameOfCourseDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameOfCourse" ascending:YES];
        NSSortDescriptor *teacherLastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"teacher.lastName" ascending:YES];
        
        NSArray *userCourses = self.user.courses.allObjects;
        
        NSArray *sortedArray = [userCourses sortedArrayUsingDescriptors:@[nameOfCourseDescriptor, teacherLastNameDescriptor]];
        
        Course *course = [sortedArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = course.nameOfCourse;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", course.teacher.firstName, course.teacher.lastName];
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.user.courses count] != 0) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else{
        return [self.user.courses count];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        NSSortDescriptor *courseNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameOfCourse" ascending:YES];
        NSSortDescriptor *courseTeacherDescriptor = [[NSSortDescriptor alloc] initWithKey:@"teacher.lastName" ascending:YES];
        
        NSArray *currentArray = [[self.user.courses allObjects] sortedArrayUsingDescriptors:@[courseNameDescriptor, courseTeacherDescriptor]];
        
        Course *course = [currentArray objectAtIndex:indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CourseInfoTableViewController *courseInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"CourseInfoTableViewController"];
        courseInfoVC.course = course;
        
        UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:courseInfoVC];
        
        courseInfoVC.tableView.userInteractionEnabled = NO;
        courseInfoVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backToCourseAction:)];
        courseInfoVC.navigationItem.rightBarButtonItem = nil;
        
        courseInfoVC.courseName = course.nameOfCourse;
        courseInfoVC.courseSubject = course.subject;
        courseInfoVC.courseBranch = course.branch;
        courseInfoVC.courseTeacherFullName = [NSString stringWithFormat:@"%@ %@", course.teacher.firstName, course.teacher.lastName];
        
        courseInfoVC.course = course;

        [self presentViewController:navContr animated:YES completion:nil];
    }
}


@end
