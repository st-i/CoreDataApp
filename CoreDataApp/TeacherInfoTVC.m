//
//  TeacherInfoTVC.m
//  CoreDataApp
//
//  Created by iStef on 16.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "TeacherInfoTVC.h"
#import "DataManager.h"
#import "UserInfoTableViewCell.h"
#import "Course+CoreDataClass.h"
#import "Course+CoreDataProperties.h"
#import "CourseInfoTableViewController.h"

@interface TeacherInfoTVC ()

@end

@implementation TeacherInfoTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textFields = [NSMutableArray array];
    
    self.navigationItem.title = @"Teacher Information";
    
    self.tableView.allowsSelection = YES;
    
    if (self.teacher) {
        self.teacher.firstName = self.firstName;
        self.teacher.lastName = self.lastName;
        
    }else{
        self.firstName = self.lastName = @"";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTeacherInfoAction:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)saveTeacherInfoAction:(UIBarButtonItem *)sender
{
    if (self.teacher) {
        self.teacher.firstName = self.firstName;
        self.teacher.lastName = self.lastName;
        
        NSError *currentTeacherError = nil;
        if (![[DataManager sharedManager].persistentContainer.viewContext save:&currentTeacherError]) {
            NSLog(@"CURRENT USER SAVING ERROR: %@", currentTeacherError.localizedDescription);
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        Teacher *teacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
        
        teacher.firstName = self.firstName;
        teacher.lastName = self.lastName;
        
        NSError *error = nil;
        
        if (![[DataManager sharedManager].persistentContainer.viewContext save:&error]) {
            NSLog(@"NEW TEACHER SAVING ERROR: %@", error.localizedDescription);
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

-(void)backToCourseAction:(UIBarButtonItem *)item
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)textFieldEditingAction:(UITextField *)sender
{
    if (self.teacher) {
        switch (sender.tag) {
            case 0:
                self.firstName = sender.text;
                break;
            case 1:
                self.lastName = sender.text;
                break;
            default:
                break;
        }
        if (![self.teacher.firstName isEqualToString:self.firstName] || ![self.teacher.lastName isEqualToString:self.lastName]){
            
            if (self.firstName.length == 0 && self.lastName.length == 0) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
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
            default:
                break;
        }
        if (self.firstName.length != 0 && self.lastName.length != 0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0) {
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
        return @"Taught Courses";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UserInfoTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"teacherFirstNameCell"];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.teacherFirstNameTF.text = self.firstName;
            [self.textFields addObject:cell1.teacherFirstNameTF];
            return cell1;
        }else {
            UserInfoTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"teacherLastNameCell"];
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            cell2.teacherLastNameTF.text = self.lastName;
            [self.textFields addObject:cell2.teacherLastNameTF];
            return cell2;
        }
    }else{
        static NSString *identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        NSSortDescriptor *nameOfCourseDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameOfCourse" ascending:YES];
        NSSortDescriptor *courseSubjectDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subject" ascending:YES];
        
        NSArray *teacherCourses = self.teacher.courses.allObjects;
        
        NSArray *sortedArray = [teacherCourses sortedArrayUsingDescriptors:@[nameOfCourseDescriptor, courseSubjectDescriptor]];
        
        Course *course = [sortedArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = course.nameOfCourse;
        cell.detailTextLabel.text = course.subject;
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.teacher.courses count] != 0) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
        return [self.teacher.courses count];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        NSSortDescriptor *nameOfCourseDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameOfCourse" ascending:YES];
        NSSortDescriptor *courseSubjectDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subject" ascending:YES];
        
        NSArray *currentArray = [[self.teacher.courses allObjects] sortedArrayUsingDescriptors:@[nameOfCourseDescriptor, courseSubjectDescriptor]];
        
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
