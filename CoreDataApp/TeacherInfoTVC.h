//
//  TeacherInfoTVC.h
//  CoreDataApp
//
//  Created by iStef on 16.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher+CoreDataClass.h"
#import "Teacher+CoreDataProperties.h"

@interface TeacherInfoTVC : UITableViewController

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSMutableArray *textFields;

@property (strong, nonatomic) Teacher *teacher;

- (IBAction)textFieldEditingAction:(UITextField *)sender;



@end
