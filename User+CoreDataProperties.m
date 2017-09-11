//
//  User+CoreDataProperties.m
//  CoreDataApp
//
//  Created by iStef on 16.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic email;
@dynamic firstName;
@dynamic lastName;
@dynamic courses;

@end
