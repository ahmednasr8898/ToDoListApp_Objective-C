//
//  DetailsDoneViewController.m
//  ToDoList
//
//  Created by Ahmed Nasr on 30/01/2022.
//

#import "DetailsDoneViewController.h"

@interface DetailsDoneViewController ()
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UITextView *creationDateTextView;
@property (weak, nonatomic) IBOutlet UITextView *deadLineDateTextView;

@end

@implementation DetailsDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    printf("creattio date: %s\n", [_selectedTask.dateTask UTF8String]);
    printf("deadLine date: %s\n", [_selectedTask.deadLineDateTask UTF8String]);
    
    _titleTextView.editable = false;
    _descriptionTextView.editable = false;
    _creationDateTextView.editable = false;
    _descriptionTextView.editable = false;
    
    _titleTextView.text = _selectedTask.titleTask;
    _descriptionTextView.text = _selectedTask.descriptionTask;
    _priorityLabel.text = _selectedTask.priortyTask.priorityStr;
    _creationDateTextView.text = _selectedTask.dateTask;
    _deadLineDateTextView.text = _selectedTask.deadLineDateTask;
}

@end
