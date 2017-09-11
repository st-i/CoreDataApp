//
//  AppointTeacherTVC.h
//  CoreDataApp
//
//  Created by iStef on 16.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Course+CoreDataClass.h"
#import "Course+CoreDataProperties.h"

@interface AppointTeacherTVC : CoreDataTableViewController

@property (strong, nonatomic) Course *currentCourse;

@end
