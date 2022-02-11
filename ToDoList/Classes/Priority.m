//
//  Priority.m
//  ToDoList
//
//  Created by Ahmed Nasr on 27/01/2022.
//

#import "Priority.h"

@implementation Priority

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_priorityStr forKey:@"PriorityStr"];
    [coder encodeObject:_PriorityImg forKey:@"PriorityImg"];
}

- (id)initWithCoder:(nonnull NSCoder *)coder {
    if((self = [super init])){
        _priorityStr = [coder decodeObjectOfClass:[NSString class] forKey:@"PriorityStr"];
        _PriorityImg = [coder decodeObjectOfClass:[NSString class] forKey:@"PriorityImg"];
    }
    return self;
}

+(BOOL)supportsSecureCoding{
    return YES;
}

@end
