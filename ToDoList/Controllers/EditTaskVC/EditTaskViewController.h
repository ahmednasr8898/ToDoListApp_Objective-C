//
//  EditTaskViewController.h
//  ToDoList
//
//  Created by Ahmed Nasr on 28/01/2022.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface EditTaskViewController : UIViewController<UITableViewDelegate, UITableViewDelegate>

@property Task *selectedTask;
@property int rowOfSelectedTask;
@property int rowOfPriorty;

@end
