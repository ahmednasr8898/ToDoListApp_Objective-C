//
//  AddNewTaskViewController.m
//  ToDoList
//
//  Created by Ahmed Nasr on 27/01/2022.
//

#import "AddNewTaskViewController.h"
#import "Priority.h"
#import "Task.h"

@interface AddNewTaskViewController (){
    NSMutableArray *priorityArray;
    NSMutableArray<Task*> *tasksArr;
    int indexOfPriority;
    Task *task;
    NSUserDefaults *userDefaults;
    NSData *dataSaved;
    NSSet *setTasks;
    NSData *data;
}

@property (weak, nonatomic) IBOutlet UITableView *priorityMenuTableView;
@property (weak, nonatomic) IBOutlet UIButton *choosePriorityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *choosePriorityImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation AddNewTaskViewController

-(id) initWithCoder:(NSCoder *)coder{
    if(self = [super initWithCoder:coder]){
        tasksArr = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setPriorityArray];
    [self setCurrentDate];
    [self setUtility];
    
}

-(void) setUtility{
    self.priorityMenuTableView.delegate = self;
    self.priorityMenuTableView.dataSource = self;
    self.priorityMenuTableView.hidden = YES;
    self.priorityMenuTableView.backgroundColor = UIColor.grayColor;
    tasksArr = [NSMutableArray new];
    task = [Task new];
    userDefaults = [NSUserDefaults standardUserDefaults];
    _addBtn.layer.cornerRadius = 20;
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
    
    indexOfPriority = 0;
}

-(void) setCurrentDate{
    NSDate* time = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString* dateTime = [dateFormatter stringFromDate:time];
    [self.navigationItem setTitle:dateTime];
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
    cell.detailTextLabel.text = @"";
    cell.imageView.image = [UIImage imageNamed: [priorityArray[indexPath.row] PriorityImg]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.choosePriorityBtn setTitle:[priorityArray[indexPath.row] priorityStr] forState:UIControlStateNormal];
    self.priorityMenuTableView.hidden = YES;
    _choosePriorityImageView.image = [UIImage imageNamed:[priorityArray[indexPath.row] PriorityImg]];
    indexOfPriority = (int)indexPath.row;
}

- (IBAction)choosePriorityDidPressed:(id)sender {
    if(self.priorityMenuTableView.hidden == YES){
        self.priorityMenuTableView.hidden =NO;
    }else{
        self.priorityMenuTableView.hidden = YES;
    }
}

- (IBAction)AddTaskDidPressed:(id)sender {
    
    if([_titleTextField.text isEqual:@""]){
        printf("please enter title for task\n");
        [self showConfirmAlert];
    }else{
        task.titleTask = _titleTextField.text;
        task.descriptionTask = _descriptionTextField.text;
        task.priortyTask = priorityArray[indexOfPriority];
        task.dateTask = self.navigationItem.title;
        [_taskProto transTask:task];
        
        //Save object in userDefuls
        
        //get array in userdefuls
        NSError *error;
        if([userDefaults objectForKey:@"Task"] == nil){
            //handle
            [tasksArr addObject:task];
            data = [NSKeyedArchiver archivedDataWithRootObject:tasksArr requiringSecureCoding:YES error:&error];
            [userDefaults setObject:data forKey:@"Task"];
        }else{
            dataSaved = [userDefaults objectForKey:@"Task"];
            setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
            tasksArr = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
            //add new task in array in userdef
            [tasksArr addObject:task];
            data = [NSKeyedArchiver archivedDataWithRootObject:tasksArr requiringSecureCoding:YES error:&error];
            //pass array agin in user def
            [userDefaults setObject:data forKey:@"Task"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) showConfirmAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warnning!!!" message:@"cannot create task without title" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:NULL];
}


@end
