//
//  Course+CoreDataProperties.h
//  CoreDataApp
//
//  Created by iStef on 16.08.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "Course+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

+ (NSFetchRequest<Course *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *branch;
@property (nullable, nonatomic, copy) NSString *nameOfCourse;
@property (nullable, nonatomic, copy) NSString *subject;
@property (nullable, nonatomic, retain) Teacher *teacher;
@property (nullable, nonatomic, retain) NSSet<User *> *users;

@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet<User *> *)values;
- (void)removeUsers:(NSSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END
