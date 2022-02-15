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
    NSMutableArray<Task*> *tasksArr;
    Task *task;
    NSUserDefaults *userDefaults;
    NSData *dataSaved;
    NSSet *setTasks;
    NSData *data;
    //Current and DeadLine Date
    NSDate* currentDate;
    NSDate * deadLineDate;
    NSDateFormatter* currentDateFormatter;
    NSDateFormatter* deadLineDateFormatter;
    NSDateFormatter* deadLineTimeFormatter;
    NSString* deadLineDateStr;
    NSString* deadLineTimeStr;
    NSString* currentDateStr;
    //Notification
    BOOL isAllowNotificationAccess;
    UNUserNotificationCenter *notificationCenter;
    UNAuthorizationOptions options;
}

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priortySegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

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
    [self setUpNotificationCenter];
    [self setUtility];
    [self setUpDesign];
    [self setCurrentDateTask];
}

-(void) setUtility{
    tasksArr = [NSMutableArray new];
    task = [Task new];
    userDefaults = [NSUserDefaults standardUserDefaults];
    //set current and deadLine date
    currentDate = [NSDate date];
    currentDateFormatter = [[NSDateFormatter alloc] init];
    deadLineDateFormatter = [[NSDateFormatter alloc] init];
    deadLineTimeFormatter = [[NSDateFormatter alloc] init];
}

-(void) setUpDesign{
    _addBtn.layer.cornerRadius = 25;
    _titleTextField.layer.cornerRadius = 25;
    _descriptionTextView.layer.cornerRadius = 25;
    _containerView.layer.cornerRadius = 25;
    self.navigationController.navigationBar.tintColor = UIColor.lightGrayColor;
}

-(void) setUpNotificationCenter{
    isAllowNotificationAccess = false;
    notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    options = UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    
    [notificationCenter requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        self->isAllowNotificationAccess = granted;
    }];
}

-(void) setCurrentDateTask{
    [currentDateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    currentDateStr = [currentDateFormatter stringFromDate:currentDate];
    [self.navigationItem setTitle:currentDateStr];
}

-(void) setDeadLineDateTask{
    deadLineDate =  _datePickerView.date;
    [deadLineDateFormatter setDateFormat:@"yyyy-MM-dd"];
    [deadLineTimeFormatter setDateFormat:@"hh:mm"];
    deadLineDateStr = [deadLineDateFormatter stringFromDate:deadLineDate];
    deadLineTimeStr = [deadLineTimeFormatter stringFromDate:deadLineDate];
    //printf("date is : %s and time is: %s", [deadLineDateStr UTF8String], [deadLineTimeStr UTF8String]);
}

-(Priority*) getTaskPriority{
    Priority *taskPriority = [Priority new];
    switch (_priortySegment.selectedSegmentIndex) {
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

-(void) setNewTask{
    [self setDeadLineDateTask];
    task.titleTask = _titleTextField.text;
    task.descriptionTask = _descriptionTextView.text;
    task.priortyTask = [self getTaskPriority];
    task.deadLineDateTask = deadLineDateStr;
    task.deadLineTimeTask = deadLineTimeStr;
    task.dateTask = currentDateStr;
    [_taskProto transTask:task];
}

-(void) taskNotFoundInUserDef{
    NSError *error;
    [tasksArr addObject:task];
    data = [NSKeyedArchiver archivedDataWithRootObject:tasksArr requiringSecureCoding:YES error:&error];
    [userDefaults setObject:data forKey:@"Task"];
}

-(void) taskFoundInUserDef{
    NSError *error;
    dataSaved = [userDefaults objectForKey:@"Task"];
    setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    tasksArr = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
    //add new task in array in userdef
    [tasksArr addObject:task];
    data = [NSKeyedArchiver archivedDataWithRootObject:tasksArr requiringSecureCoding:YES error:&error];
    //pass array agin in user def
    [userDefaults setObject:data forKey:@"Task"];
}

-(void) checkTaskIsFoundOrNotInUserDef{
    if([userDefaults objectForKey:@"Task"] == nil){
        [self taskNotFoundInUserDef];
    }else{
        [self taskFoundInUserDef];
    }
}

-(void) checkIsCanAddNewtaskOrNot{
    if([_titleTextField.text isEqual:@""]){
        [self showConfirmAlert];
    }else{
        [self setNewTask];
        [self checkTaskIsFoundOrNotInUserDef];
        [self pushNotificationTask];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)AddTaskDidPressed:(id)sender {
    
    [self checkIsCanAddNewtaskOrNot];
}

-(void) pushNotificationTask{
    if(isAllowNotificationAccess){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc]init];
        notificationContent.title = @"ToDoList App";
        notificationContent.subtitle = task.titleTask;
        notificationContent.body = @"it's time to done this task!!";
        notificationContent.sound = [UNNotificationSound defaultSound];
        
        UNTimeIntervalNotificationTrigger *timeNotification = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval: 10 repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:notificationContent trigger:timeNotification];
        
        [center addNotificationRequest:request withCompletionHandler:nil];
    }
}

-(void) showConfirmAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warnning!!!" message:@"cannot create task without title" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

@end
