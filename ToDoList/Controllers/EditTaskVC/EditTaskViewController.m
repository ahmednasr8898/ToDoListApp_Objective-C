//
//  EditTaskViewController.m
//  ToDoList
//
//  Created by Ahmed Nasr on 28/01/2022.
//

#import "EditTaskViewController.h"
#import "Priority.h"

@interface EditTaskViewController (){
    NSMutableArray *tasksArray;
    NSMutableArray *myTasksArray;
    NSMutableArray *InProgressArray;
    Task *taskThatMove;
    NSUserDefaults *userDefaults;
    NSData *dataSaved;
    NSSet *setTasks;
    NSData *data;
    int indexOfSelectedTask;
    
    //selectedDeadLineDate
    NSString *selectedDeadLineDateStr;
    NSDateFormatter *selectedDeadLineFormatter;
    NSDate *selectedDate;
    NSDateFormatter* deadLineDateFormatter;
    NSDateFormatter* deadLineTimeFormatter;
    NSString* deadLineDateStr;
    NSString* deadLineTimeStr;
    NSDate * deadLineDate;
}

@property (weak, nonatomic) IBOutlet UITextField *titleTaskTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *deadLineDatePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UIButton *addInProgressBtn;
@property (weak, nonatomic) IBOutlet UIButton *addDoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDesign];
    [self setUtility];
    [self setTask];
}

-(void) setUtility{
    userDefaults = [NSUserDefaults standardUserDefaults];
    tasksArray = [NSMutableArray new];
    myTasksArray = [NSMutableArray new];
    InProgressArray = [NSMutableArray new];
    indexOfSelectedTask = _rowOfSelectedTask;
    selectedDeadLineDateStr = [NSString new];
    selectedDeadLineFormatter = [[NSDateFormatter alloc] init];
    deadLineDateFormatter = [[NSDateFormatter alloc] init];
    deadLineTimeFormatter = [[NSDateFormatter alloc] init];
    taskThatMove = [Task new];
}

-(void) setUpDesign{
    _addDoneBtn.layer.cornerRadius = 20;
    _addInProgressBtn.layer.cornerRadius = 15;
    _editBtn.layer.shadowColor = UIColor.blackColor.CGColor;
    _editBtn.layer.shadowOffset = CGSizeMake(5, 5);
    _editBtn.layer.shadowOpacity = 1;
    _editBtn.layer.shadowRadius = 5;
    _editBtn.layer.cornerRadius = 50;
    self.navigationController.navigationBar.tintColor = UIColor.darkGrayColor;
}

-(void) setTask{
    _titleTaskTextField.text = _selectedTask.titleTask;
    _descriptionTextView.text = _selectedTask.descriptionTask;
    [self setPriortyTask];
    [self setDeadLineDateTask];
}

-(void) setPriortyTask{
    if([_selectedTask.priortyTask.priorityStr isEqual:@"high"]){
        _prioritySegment.selectedSegmentIndex = 0;
    }else if([_selectedTask.priortyTask.priorityStr isEqual:@"mid"]){
        _prioritySegment.selectedSegmentIndex = 1;
    }else if([_selectedTask.priortyTask.priorityStr isEqual:@"low"]){
        _prioritySegment.selectedSegmentIndex = 2;
    }
}

-(void) setDeadLineDateTask{
    selectedDeadLineDateStr = [_selectedTask.deadLineDateTask stringByAppendingString:@" "];
    selectedDeadLineDateStr = [selectedDeadLineDateStr stringByAppendingString:_selectedTask.deadLineTimeTask];
    [selectedDeadLineFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    [selectedDeadLineFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Egypt/Cairo"]];
    selectedDate = [selectedDeadLineFormatter dateFromString:selectedDeadLineDateStr];
    _deadLineDatePicker.date = selectedDate;
}

- (IBAction)EditTaskDidPressed:(id)sender {
    [self showConfirmEditTaskAlert];
}

-(void) showConfirmEditTaskAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to edit this task" message:@"confirm edit task!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //edit task
        [self editSelectedTask];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void) editSelectedTask{
    [self getArrayFromUserDef];
    [self taskSelected];
    [self passArrayAgainToUserDef];
}

-(void) getArrayFromUserDef{
    NSError *error;
    dataSaved = [userDefaults objectForKey:@"Task"];
    setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
}

-(void) passArrayAgainToUserDef{
    NSError *error;
    data = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:&error];
    [userDefaults setObject:data forKey:@"Task"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) taskSelected{
    [self getDeadLineDateTask];
    [tasksArray[indexOfSelectedTask] setTitleTask: _titleTaskTextField.text];
    [tasksArray[indexOfSelectedTask] setDescriptionTask: _descriptionTextView.text];
    [tasksArray[indexOfSelectedTask] setPriortyTask: [self getTaskPriority]];
    [tasksArray[indexOfSelectedTask] setDeadLineDateTask:deadLineDateStr];
    [tasksArray[indexOfSelectedTask] setDeadLineTimeTask: deadLineTimeStr];
}

- (IBAction)adTaskToInProgressDidPressed:(id)sender {
    [self showConfirmAlertToInProgress];
}

-(void) showConfirmAlertToInProgress{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to move this task to in progress" message:@"cannot return again!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //move task to inProgress section
        [self addTaskToInProgress];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void) addTaskToInProgress{
    [self myTaskSelected];
    [self checkTaskThatMovedFoundInUserDef:@"InProgressTasks"];
    [self deleteTaskThatMovedFromTasksList];
}

- (IBAction)addToDoneTasksDidPressed:(id)sender {
    [self showConfirmAlertToDone];
}

-(void) showConfirmAlertToDone{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to move this task to Done" message:@"cannot return again!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addTaskToDone];
    }];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void) addTaskToDone{
    [self myTaskSelected];
    [self checkTaskThatMovedFoundInUserDef:@"DoneTasks"];
    [self deleteTaskThatMovedFromTasksList];
}

-(void) checkTaskThatMovedFoundInUserDef: (NSString*) keyIndetifier{
    if([userDefaults objectForKey:keyIndetifier] == nil){
        [self taskIsNotFoundInUserDef:keyIndetifier];
    }else{
        [self taskIsFoundInUserDef:keyIndetifier];
    }
}

-(void) taskIsNotFoundInUserDef: (NSString*) keyIndetifier{
    NSError *error;
    [myTasksArray addObject:taskThatMove];
    data = [NSKeyedArchiver archivedDataWithRootObject:myTasksArray requiringSecureCoding:YES error:&error];
    [userDefaults setObject:data forKey:keyIndetifier];
}

-(void) taskIsFoundInUserDef: (NSString*) keyIndetifier{
    NSError *error;
    dataSaved = [userDefaults objectForKey:keyIndetifier];
    setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    myTasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
    //add new task in array in userdef
    [myTasksArray addObject:taskThatMove];
    data = [NSKeyedArchiver archivedDataWithRootObject:myTasksArray requiringSecureCoding:YES error:&error];
    //pass array agin in user def
    [userDefaults setObject:data forKey:keyIndetifier];
}

-(void) myTaskSelected{
    [self getDeadLineDateTask];
    [taskThatMove setTitleTask:_titleTaskTextField.text];
    [taskThatMove setDescriptionTask: _descriptionTextView.text];
    [taskThatMove setPriortyTask: [self getTaskPriority]];
    [taskThatMove setDeadLineDateTask:deadLineDateStr];
    [taskThatMove setDeadLineTimeTask: deadLineTimeStr];
    [taskThatMove setDateTask:_selectedTask.dateTask];
}

-(void) deleteTaskThatMovedFromTasksList{
    NSError *error;
    dataSaved = [userDefaults objectForKey:@"Task"];
    setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
    [tasksArray removeObjectAtIndex:_rowOfSelectedTask];
    data = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:&error];
    [userDefaults setObject:data forKey:@"Task"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(Priority*) getTaskPriority{
    Priority *taskPriority = [Priority new];
    switch (_prioritySegment.selectedSegmentIndex) {
        case 0:
            //high priorty
            taskPriority.priorityStr = @"high";
            taskPriority.PriorityImg = @"high";
            break;
        case 1:
            //mid priorty
            taskPriority.priorityStr = @"mid";
            taskPriority.PriorityImg = @"mid";
            break;
        case 2:
            //low priorty
            taskPriority.priorityStr = @"low";
            taskPriority.PriorityImg = @"low";
            break;
        default:
            break;
    }
    return taskPriority;
}

-(void) getDeadLineDateTask{
    deadLineDate =  _deadLineDatePicker.date;
    [deadLineDateFormatter setDateFormat:@"yyyy-MM-dd"];
    [deadLineTimeFormatter setDateFormat:@"hh:mm"];
    deadLineDateStr = [deadLineDateFormatter stringFromDate:deadLineDate];
    deadLineTimeStr = [deadLineTimeFormatter stringFromDate:deadLineDate];
    //printf("date is : %s and time is: %s", [deadLineDateStr UTF8String], [deadLineTimeStr UTF8String]);
}

@end
