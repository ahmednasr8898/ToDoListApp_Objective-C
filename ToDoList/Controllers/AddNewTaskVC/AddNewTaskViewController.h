//
//  AddNewTaskViewController.h
//  ToDoList
//
//  Created by Ahmed Nasr on 27/01/2022.
//

#import <UIKit/UIKit.h>
#import "TaskProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddNewTaskViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property id <TaskProtocol> taskProto;

@end

NS_ASSUME_NONNULL_END
