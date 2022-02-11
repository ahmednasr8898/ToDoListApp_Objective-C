//
//  EditTaskViewController.m
//  ToDoList
//
//  Created by Ahmed Nasr on 28/01/2022.
//

#import "EditTaskViewController.h"
#import "Priority.h"

@interface EditTaskViewController (){
    NSMutableArray *priorityArray;
    NSMutableArray *tasksArray;
    NSMutableArray *InProgressArray;
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
@property (weak, nonatomic) IBOutlet UIButton *addInProgressBtn;
@property (weak, nonatomic) IBOutlet UIButton *addDoneBtn;

@end

@implementation EditTaskViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    _addInProgressBtn.layer.cornerRadius = 18;
    _addDoneBtn.layer.cornerRadius = 18;
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

- (IBAction)EditTaskDidPressed:(id)sender {
    [self showConfirmAlert];
    
}

- (IBAction)choosePriortyDidPressed:(id)sender {
    if(self.priortyTableView.hidden == YES){
        self.priortyTableView.hidden =NO;
    }else{
        self.priortyTableView.hidden = YES;
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriorityMenuCell" forIndexPath:indexPath];
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
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void) editSelectedTask{
    //get array from userdef
    NSError *error;
    dataSaved = [userDefaults objectForKey:@"Task"];
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
    [userDefaults setObject:data forKey:@"Task"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)adTaskToInProgressDidPressed:(id)sender {
    printf("asasa");
    [self showConfirmAlertToInProgress];
}

-(void) showConfirmAlertToInProgress{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to move this task to in progress" message:@"cannot return again!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL];
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self addToInProgress];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void) addToInProgress{
    Task *t = [Task new];
    [t setTitleTask:_titleTaskTextField.text];
    [t setDescriptionTask: _descriptionTaskTextField.text];
    [t setDateTask: _dateTaskLabel.text];
    [selectedPriority setPriorityStr:priorityStr1];
    [selectedPriority setPriorityImg:priorityImg1];
    [t setPriortyTask:selectedPriority];
    
    NSError *error;
    if([userDefaults objectForKey:@"InProgressTasks"] == nil){
        //handle
        [InProgressArray addObject:t];
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:InProgressArray requiringSecureCoding:YES error:&error];
        [userDefaults setObject:data forKey:@"InProgressTasks"];
    }else{
       NSData *dataSaved = [userDefaults objectForKey:@"InProgressTasks"];
        NSSet *setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
        InProgressArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
        //add new task in array in userdef
        [InProgressArray addObject:t];
        data = [NSKeyedArchiver archivedDataWithRootObject:InProgressArray requiringSecureCoding:YES error:&error];
        //pass array agin in user def
        [userDefaults setObject:data forKey:@"InProgressTasks"];
    }
    //delete task from to do list
    dataSaved = [userDefaults objectForKey:@"Task"];
    setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
    [tasksArray removeObjectAtIndex:_rowOfSelectedTask];
    data = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:&error];
    [userDefaults setObject:data forKey:@"Task"];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)addToDoneTasksDidPressed:(id)sender {
    printf("sdedsdsdsdsds");
    [self showConfirmAlertToDone];
}

-(void) showConfirmAlertToDone{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to move this task to Done" message:@"cannot return again!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL];
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self addToDone];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void) addToDone{
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
        [InProgressArray addObject:t];
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:InProgressArray requiringSecureCoding:YES error:&error];
        [userDefaults setObject:data forKey:@"DoneTasks"];
    }else{
       NSData *dataSaved = [userDefaults objectForKey:@"DoneTasks"];
        NSSet *setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
        InProgressArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
        //add new task in array in userdef
        [InProgressArray addObject:t];
        data = [NSKeyedArchiver archivedDataWithRootObject:InProgressArray requiringSecureCoding:YES error:&error];
        //pass array agin in user def
        [userDefaults setObject:data forKey:@"DoneTasks"];
    }
    //delete task from to do list
    dataSaved = [userDefaults objectForKey:@"Task"];
    setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
    [tasksArray removeObjectAtIndex:_rowOfSelectedTask];
    data = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:&error];
    [userDefaults setObject:data forKey:@"Task"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
