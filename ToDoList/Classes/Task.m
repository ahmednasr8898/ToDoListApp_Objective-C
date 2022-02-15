//
//  Task.m
//  ToDoList
//
//  Created by Ahmed Nasr on 28/01/2022.
//

#import "Task.h"

@implementation Task

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_titleTask forKey:@"titleTask"];
    [coder encodeObject:_descriptionTask forKey:@"descriptionTask"];
    [coder encodeObject:_priortyTask forKey:@"priortyTask"];
    [coder encodeObject:_dateTask forKey:@"dateTask"];
    [coder encodeObject:_deadLineDateTask forKey:@"deadLineDateTask"];
    [coder encodeObject:_deadLineTimeTask forKey:@"deadLineTimeTask"];
    
}

- (id)initWithCoder:(nonnull NSCoder *)coder {
    if((self = [super init])){
        _titleTask = [coder decodeObjectOfClass:[NSString class] forKey:@"titleTask"];
        _descriptionTask = [coder decodeObjectOfClass:[NSString class] forKey:@"descriptionTask"];
        _priortyTask = [coder decodeObjectOfClass:[Priority class] forKey:@"priortyTask"];
        _dateTask = [coder decodeObjectOfClass:[NSString class] forKey:@"dateTask"];
        _deadLineDateTask = [coder decodeObjectOfClass:[NSString class] forKey:@"deadLineDateTask"];
        _deadLineTimeTask = [coder decodeObjectOfClass:[NSString class] forKey:@"deadLineTimeTask"];
    }
    return  self;
}

+(BOOL) supportsSecureCoding{
    return YES;
}

@end
