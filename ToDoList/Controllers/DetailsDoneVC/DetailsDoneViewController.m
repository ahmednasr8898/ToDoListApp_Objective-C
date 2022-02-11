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
@property (weak, nonatomic) IBOutlet UIImageView *PriorityImageView;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DetailsDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _titleTextView.editable = false;
    _descriptionTextView.editable = false;
    _titleTextView.text = _selectedTask.titleTask;
    _descriptionTextView.text = _selectedTask.descriptionTask;
    _priorityLabel.text = _selectedTask.priortyTask.priorityStr;
    _PriorityImageView.image = [UIImage imageNamed:_selectedTask.priortyTask.PriorityImg];
    _dateLabel.text = _selectedTask.dateTask;
}

@end
