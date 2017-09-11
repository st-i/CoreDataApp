//
//  Course+CoreDataClass.h
//  CoreDataApp
//
//  Created by iStef on 16.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Teacher, User;

NS_ASSUME_NONNULL_BEGIN

@interface Course : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Course+CoreDataProperties.h"
