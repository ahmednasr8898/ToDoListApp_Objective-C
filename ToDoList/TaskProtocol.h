//
//  TaskProtocol.h
//  ToDoList
//
//  Created by Ahmed Nasr on 28/01/2022.
//

#import <Foundation/Foundation.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TaskProtocol <NSObject>

-(void) transTask: (Task*) myNewTask;

@end

NS_ASSUME_NONNULL_END
