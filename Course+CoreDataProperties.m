//
//  Course+CoreDataProperties.m
//  CoreDataApp
//
//  Created by iStef on 16.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "Course+CoreDataProperties.h"

@implementation Course (CoreDataProperties)

+ (NSFetchRequest<Course *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Course"];
}

@dynamic branch;
@dynamic nameOfCourse;
@dynamic subject;
@dynamic teacher;
@dynamic users;

@end
