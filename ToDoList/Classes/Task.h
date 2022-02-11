//
//  Task.h
//  ToDoList
//
//  Created by Ahmed Nasr on 28/01/2022.
//

#import <Foundation/Foundation.h>
#import "Priority.h"

@interface Task : NSObject<NSCoding, NSSecureCoding>

@property int taskID;
@property NSString *titleTask;
@property NSString *descriptionTask;
@property Priority *priortyTask;
@property NSString *dateTask;

-(void) encodeWithCoder:(NSCoder *)coder;

@end
