//
//  CourseInfoTableViewController.h
//  CoreDataApp
//
//  Created by iStef on 12.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course+CoreDataClass.h"
#import "Course+CoreDataProperties.h"
#import "Teacher+CoreDataClass.h"
#import "Teacher+CoreDataProperties.h"

@interface CourseInfoTableViewController : UITableViewController <UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *courseSubject;
@property (strong, nonatomic) NSString *courseBranch;
@property (strong, nonatomic) NSString *courseTeacherFullName;
@property (strong, nonatomic) NSString *globalFullName;

@property (strong, nonatomic) Course *course;

- (IBAction)courseTFieldsAction:(UITextField *)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
