//
//  AddNewTaskViewController.h
//  ToDoList
//
//  Created by Ahmed Nasr on 27/01/2022.
//

#import <UIKit/UIKit.h>
#import "TaskProtocol.h"
#import <UserNotifications/UserNotifications.h>

@interface AddNewTaskViewController : UIViewController

@property id <TaskProtocol> taskProto;

@end
