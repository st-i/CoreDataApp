//
//  UserInfoTableViewController.h
//  CoreDataApp
//
//  Created by iStef on 11.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+CoreDataClass.h"
#import "User+CoreDataProperties.h"

@interface UserInfoTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSMutableArray *textFields;

@property (strong, nonatomic) User *user;

- (IBAction)textFieldEditingAction:(UITextField *)sender;


@end
