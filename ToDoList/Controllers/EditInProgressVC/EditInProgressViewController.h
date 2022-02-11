//
//  EditInProgressViewController.h
//  ToDoList
//
//  Created by Ahmed Nasr on 30/01/2022.
//

#import <UIKit/UIKit.h>
#import "Task.h"
@interface EditInProgressViewController : UIViewController<UITableViewDelegate, UITableViewDelegate>


@property Task *selectedTask;
@property int rowOfSelectedTask;
@property int rowOfPriorty;

@end

