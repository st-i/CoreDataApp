//
//  CourseInfoTableViewController.m
//  CoreDataApp
//
//  Created by iStef on 12.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "CourseInfoTableViewController.h"
#import "UserInfoTableViewCell.h"
#import "DataManager.h"
#import "SubscribeNewUsersTableViewController.h"
#import "User+CoreDataClass.h"
#import "User+CoreDataProperties.h"
#import "UserInfoTableViewController.h"
#import "AppointTeacherTVC.h"

@interface CourseInfoTableViewController ()

@property (strong, nonatomic) NSMutableArray *courseTFields;

@end

@implementation CourseInfoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem.title = @" ";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCourseDetailsAction:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.courseTFields = [NSMutableArray array];
    
    self.navigationItem.title = @"Course Information";
    
    if (self.course) {
        self.courseName = self.course.nameOfCourse;
        self.courseSubject = self.course.subject;
        self.courseBranch = self.course.branch;
    }else{
        
        Course *currentCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
        
        self.course = currentCourse;
        
        self.courseName = @"";
        self.courseSubject = @"";
        self.courseBranch = @"";
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.course.teacher == nil) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)saveCourseDetailsAction:(UIBarButtonItem *)item
{
    if (self.course) {
        self.course.nameOfCourse = self.courseName;
        self.course.subject = self.courseSubject;
        self.course.branch = self.courseBranch;
        
        /*NSRange spaceRange = [self.courseTeacherFullName rangeOfString:@" "];
        NSString *firstName = [self.courseTeacherFullName substringToIndex:spaceRange.location];
        NSString *lastName = [self.courseTeacherFullName substringFromIndex:spaceRange.location+1];
        
        self.course.teacher.firstName = firstName;
        self.course.teacher.lastName = lastName;*/
        
        NSError *error = nil;
        if (![[DataManager sharedManager].persistentContainer.viewContext save:&error]) {
            NSLog(@"CURRENT COURSE SAVING ERROR: %@", error.localizedDescription);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        Course *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
        Teacher *teacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:[DataManager sharedManager].persistentContainer.viewContext];
        
        course.nameOfCourse = self.courseName;
        course.subject = self.courseSubject;
        course.branch = self.courseBranch;
        
        /*NSRange spaceRange = [self.courseTeacherFullName rangeOfString:@" "];
        NSString *firstName = [self.courseTeacherFullName substringToIndex:spaceRange.location];
        NSString *lastName = [self.courseTeacherFullName substringFromIndex:spaceRange.location+1];
        
        course.teacher.firstName = firstName;
        course.teacher.lastName = lastName;*/
        
        course.teacher = teacher;
        
        NSError *error = nil;
        if (![[DataManager sharedManager].persistentContainer.viewContext save:&error]) {
            NSLog(@"NEW COURSE SAVING ERROR: %@", error.localizedDescription);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)appointNewCourseTeacherFromSourceView:(UITableView *)tableView andSourceRect:(CGRect)rect
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppointTeacherTVC *allTeachersTVC = [storyboard instantiateViewControllerWithIdentifier:@"AppointTeacherTVC"];
    allTeachersTVC.currentCourse = self.course;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:allTeachersTVC];
    navigationController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:navigationController animated:YES completion:nil];
    
    UIPopoverPresentationController *popoverPC = [allTeachersTVC popoverPresentationController];
    popoverPC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverPC.sourceView = tableView;
    popoverPC.sourceRect = rect;
}

- (IBAction)courseTFieldsAction:(UITextField *)sender
{
    if (self.course) {
        switch (sender.tag) {
            case 0:
                self.courseName = sender.text;
                break;
            case 1:
                self.courseSubject = sender.text;
                break;
            case 2:
                self.courseBranch = sender.text;
                break;
            
            default:
                break;
        }
        if (![self.course.nameOfCourse isEqualToString:self.courseName] ||
            ![self.course.subject isEqualToString:self.courseSubject] ||
            ![self.course.branch isEqualToString:self.courseBranch]){
            
            if (self.courseName.length == 0 || self.courseSubject.length == 0 ||
                self.courseBranch.length == 0) {
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
                self.courseName = sender.text;
                break;
            case 1:
                self.courseSubject = sender.text;
                break;
            case 2:
                self.courseBranch = sender.text;
                break;
            default:
                break;
        }
        if (self.courseName.length != 0 && self.courseSubject.length != 0 && self.courseBranch.length != 0){
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

-(void)backToCourseAction:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    NSFetchedResultsController<User *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[DataManager sharedManager].persistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"USER ERROR: %@, %@", error, [error userInfo]);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        [self appointNewCourseTeacherFromSourceView:tableView andSourceRect:indexPath.accessibilityFrame];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SubscribeNewUsersTableViewController *allUsersTVC = [storyboard instantiateViewControllerWithIdentifier:@"SubscribeNewUsersTableViewController"];
        allUsersTVC.currentCourse = self.course;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:allUsersTVC];
        
        navigationController.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:navigationController animated:YES completion:nil];
        
        UIPopoverPresentationController *popoverPC = [allUsersTVC popoverPresentationController];
        popoverPC.permittedArrowDirections = UIPopoverArrowDirectionUp;
        popoverPC.sourceView = tableView;
        popoverPC.sourceRect = indexPath.accessibilityFrame;
        
    }else if (indexPath.section == 1 && indexPath.row != 0) {
        
        NSSortDescriptor *firstNameDesc = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSSortDescriptor *lastNameDesc = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        
        NSArray *currentArray = [[self.course.users allObjects] sortedArrayUsingDescriptors:@[firstNameDesc, lastNameDesc]];
        
        User *user = [currentArray objectAtIndex:indexPath.row - 1];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UserInfoTableViewController *userInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"UserInfoTableViewController"];
        
        UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:userInfoVC];

        userInfoVC.tableView.userInteractionEnabled = NO;
        userInfoVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backToCourseAction:)];
        userInfoVC.navigationItem.rightBarButtonItem = nil;
        
        userInfoVC.firstName = user.firstName;
        userInfoVC.lastName = user.lastName;
        userInfoVC.email = user.email;
        
        userInfoVC.user = user;
        
        [self presentViewController:navContr animated:YES completion:nil];
    }
}


#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Details";
    }else{
        return @"Subscribed users";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else{
        return [self.course.users count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            UserInfoTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"courseNameCell"];
            firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
            firstCell.courseNameTF.text = self.courseName;
            [self.courseTFields addObject:firstCell.courseNameTF];
            return firstCell;
        }else if (indexPath.row == 1) {
            UserInfoTableViewCell *secondCell = [tableView dequeueReusableCellWithIdentifier:@"courseSubjectCell"];
            secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
            secondCell.courseSubjectTF.text = self.courseSubject;
            [self.courseTFields addObject:secondCell.courseSubjectTF];
            return secondCell;
        }else if (indexPath.row == 2) {
            UserInfoTableViewCell *thirdCell = [tableView dequeueReusableCellWithIdentifier:@"courseBranchCell"];
            thirdCell.selectionStyle = UITableViewCellSelectionStyleNone;
            thirdCell.courseBranchTF.text = self.courseBranch;
            [self.courseTFields addObject:thirdCell.courseBranchTF];
            return thirdCell;
        }else{
            UserInfoTableViewCell *fourthCell = [tableView dequeueReusableCellWithIdentifier:@"courseTeacherCell"];
            fourthCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            if (self.course.teacher == nil) {
                fourthCell.textLabel.text = @"Choose course teacher";
                fourthCell.textLabel.textColor = [UIColor blueColor];
            }else{
                fourthCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.course.teacher.firstName, self.course.teacher.lastName];
                fourthCell.textLabel.textColor = [UIColor blackColor];
            }
            return fourthCell;
        }
    }else{
        if (indexPath.row == 0) {
            static NSString *identifier = @"AddUserCell";
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            cell.textLabel.text = @"Change list of subscribers";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }else{
            static NSString *identifier = @"Cell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            }
            
            NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
            NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
            
            NSArray *courseUsers = self.course.users.allObjects;
            
            NSArray *sortedArray = [courseUsers sortedArrayUsingDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
            
            User *user = [sortedArray objectAtIndex:indexPath.row - 1];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
            cell.detailTextLabel.text = user.email;
            
            return cell;
        }
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0 || textField.tag == 1) {
        return [[self.courseTFields objectAtIndex:textField.tag + 1] becomeFirstResponder];
    }else{
        return [textField resignFirstResponder];
    }
}

@end
