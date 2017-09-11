//
//  Teacher+CoreDataProperties.m
//  CoreDataApp
//
//  Created by iStef on 16.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Teacher"];
}

@dynamic firstName;
@dynamic lastName;
@dynamic courses;

@end
