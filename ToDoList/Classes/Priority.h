//
//  Priority.h
//  ToDoList
//
//  Created by Ahmed Nasr on 27/01/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Priority : NSObject<NSCoding, NSSecureCoding>

@property NSString *priorityStr;
@property NSString *PriorityImg;

-(void) encodeWithCoder:(NSCoder *)coder;

@end

NS_ASSUME_NONNULL_END
