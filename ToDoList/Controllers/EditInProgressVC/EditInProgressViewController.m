//
//  EditInProgressViewController.m
//  ToDoList
//
//  Created by Ahmed Nasr on 30/01/2022.
//

#import "EditInProgressViewController.h"
#import "Priority.h"
#import "Task.h"

@interface EditInProgressViewController (){
    NSMutableArray *priorityArray;
    NSMutableArray *tasksArray;
    NSMutableArray *InProgressArray;
    NSMutableArray *doneTaskArray;
    NSUserDefaults *userDefaults;
    NSData *dataSaved;
    NSSet *setTasks;
    NSData *data;
    int indexOfSelectedTask;
    Priority *selectedPriority;
    NSString *priorityStr1;
    NSString *priorityImg1;
}
 

@property (weak, nonatomic) IBOutlet UITextField *titleTaskTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTaskTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateTaskLabel;
@property (weak, nonatomic) IBOutlet UIImageView *priortyImageView;
@property (weak, nonatomic) IBOutlet UIButton *choosePriortyButton;
@property (weak, nonatomic) IBOutlet UITableView *priortyTableView;
@property (weak, nonatomic) IBOutlet UIButton *addDoneBtn;

@end

@implementation EditInProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUtility];
    [self setTask];
    [self setPriorityArray];
}

-(void) setUtility{
    _priortyTableView.delegate = self;
    _priortyTableView.dataSource = self;
    self.priortyTableView.hidden = YES;
    userDefaults = [NSUserDefaults standardUserDefaults];
    tasksArray = [NSMutableArray new];
    InProgressArray = [NSMutableArray new];
    indexOfSelectedTask = _rowOfSelectedTask;
    priorityStr1 = _selectedTask.priortyTask.priorityStr;
    priorityImg1 = _selectedTask.priortyTask.PriorityImg;
    selectedPriority = [Priority new];
    doneTaskArray = [NSMutableArray new];
    _addDoneBtn.layer.cornerRadius = 15;
}

-(void) setTask{
    _titleTaskTextField.text = _selectedTask.titleTask;
    _descriptionTaskTextField.text = _selectedTask.descriptionTask;
    [_choosePriortyButton setTitle:_selectedTask.priortyTask.priorityStr forState:UIControlStateNormal];
    _priortyImageView.image = [UIImage imageNamed:_selectedTask.priortyTask.PriorityImg];
    _dateTaskLabel.text = _selectedTask.dateTask;
}

-(void) setPriorityArray{
    priorityArray =[NSMutableArray new];
    Priority *high = [Priority new];
    [high setPriorityStr:@"high"];
    [high setPriorityImg:@"high"];
    
    Priority *mid = [Priority new];
    [mid setPriorityStr:@"mid"];
    [mid setPriorityImg:@"mid"];
    
    Priority *low = [Priority new];
    [low setPriorityStr:@"low"];
    [low setPriorityImg:@"low"];
    
    [priorityArray addObject:high];
    [priorityArray addObject:mid];
    [priorityArray addObject:low];
}

- (IBAction)choosePriortyDidPressed:(id)sender {
    if(self.priortyTableView.hidden == YES){
        self.priortyTableView.hidden =NO;
    }else{
        self.priortyTableView.hidden = YES;
    }
}

- (IBAction)addToDoneDidPressed:(id)sender {
    [self showConfirmAlertToDone];
    
}

- (IBAction)editInProgressTaskDidPressed:(id)sender {
    [self showConfirmAlert];
}

//TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [priorityArray count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //make tableView for priorty menu
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InProgressMenuCell" forIndexPath:indexPath];
    cell.textLabel.text = [priorityArray[indexPath.row] priorityStr];
    cell.imageView.image = [UIImage imageNamed: [priorityArray[indexPath.row] PriorityImg]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.choosePriortyButton setTitle:[priorityArray[indexPath.row] priorityStr] forState:UIControlStateNormal];
    self.priortyTableView.hidden = YES;
    _priortyImageView.image = [UIImage imageNamed:[priorityArray[indexPath.row] PriorityImg]];
    priorityStr1 = [priorityArray[indexPath.row] priorityStr];
    priorityImg1 = [priorityArray[indexPath.row] PriorityImg];
}

-(void) showConfirmAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to edit this task" message:@"confirm edit task!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL];
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //edit task
       [self editSelectedTask];
        printf("edit");
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:NULL];
}
-(void) editSelectedTask{
    //get array from userdef
    NSError *error;
    dataSaved = [userDefaults objectForKey:@"InProgressTasks"];
    setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
    
    //edit in selected task
    [tasksArray[indexOfSelectedTask] setTitleTask: _titleTaskTextField.text];
    [tasksArray[indexOfSelectedTask] setDescriptionTask: _descriptionTaskTextField.text];
    [tasksArray[indexOfSelectedTask] setDateTask: _dateTaskLabel.text];
    [selectedPriority setPriorityStr:priorityStr1];
    [selectedPriority setPriorityImg:priorityImg1];
    [tasksArray[indexOfSelectedTask] setPriortyTask:selectedPriority];
    
    //pass array agin in user def
    data = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:&error];
    [userDefaults setObject:data forKey:@"InProgressTasks"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) showConfirmAlertToDone{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to move this task to Done" message:@"cannot return again!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL];
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self addToDoneTasks];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void) addToDoneTasks{
    Task *t = [Task new];
    [t setTitleTask:_titleTaskTextField.text];
    [t setDescriptionTask: _descriptionTaskTextField.text];
    [t setDateTask: _dateTaskLabel.text];
    [selectedPriority setPriorityStr:priorityStr1];
    [selectedPriority setPriorityImg:priorityImg1];
    [t setPriortyTask:selectedPriority];
    
    NSError *error;
    if([userDefaults objectForKey:@"DoneTasks"] == nil){
        //handle
        [doneTaskArray addObject:t];
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:doneTaskArray requiringSecureCoding:YES error:&error];
        [userDefaults setObject:data forKey:@"DoneTasks"];
    }else{
       NSData *dataSaved = [userDefaults objectForKey:@"DoneTasks"];
        NSSet *setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
        doneTaskArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
        //add new task in array in userdef
        [doneTaskArray addObject:t];
        data = [NSKeyedArchiver archivedDataWithRootObject:doneTaskArray requiringSecureCoding:YES error:&error];
        //pass array agin in user def
        [userDefaults setObject:data forKey:@"DoneTasks"];
    }
    //delete task from to do list
    dataSaved = [userDefaults objectForKey:@"InProgressTasks"];
    setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
    [tasksArray removeObjectAtIndex:_rowOfSelectedTask];
    data = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:&error];
    [userDefaults setObject:data forKey:@"InProgressTasks"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
