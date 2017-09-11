//
//  UserInfoTableViewCell.h
//  CoreDataApp
//
//  Created by iStef on 11.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *firstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (weak, nonatomic) IBOutlet UITextField *courseNameTF;
@property (weak, nonatomic) IBOutlet UITextField *courseSubjectTF;
@property (weak, nonatomic) IBOutlet UITextField *courseBranchTF;

@property (weak, nonatomic) IBOutlet UITextField *teacherFirstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *teacherLastNameTF;


@end
