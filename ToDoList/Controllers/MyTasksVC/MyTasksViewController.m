//
//  MyTasksViewController.m
//  ToDoList
//
//  Created by Ahmed Nasr on 27/01/2022.
//

#import "MyTasksViewController.h"
#import "AddNewTaskViewController.h"
#import "EditTaskViewController.h"
#import "Task.h"

@interface MyTasksViewController (){
    NSMutableArray<Task *> *tasksArray;
    NSMutableArray<Task *> *inProgoressArray;
    NSMutableArray<Task *> *searchTaskArray;
    NSUserDefaults *userDefaults;
    NSData *dataSaved;
    NSData *data;
    NSSet *setTasks;
    BOOL isSearching;
}

@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UITableView *TasksTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *TaskssearchBar;

@end

@implementation MyTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSearching = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUtility];
    [self getTasksArray];
}

-(void) setUtility{
    _TasksTableView.delegate = self;
    _TasksTableView.dataSource = self;
    _TaskssearchBar.delegate = self;
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    tasksArray = [NSMutableArray new];
    inProgoressArray = [NSMutableArray new];
}

-(void) getTasksArray{
    NSError *error;
    dataSaved = [userDefaults objectForKey:@"Task"];
    setTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setTasks fromData:dataSaved error:&error];
    [_TasksTableView reloadData];
}

//TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isSearching){
        return [searchTaskArray count];
    }else{
        return [tasksArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TasksCell" forIndexPath:indexPath];
    
    if(isSearching){
        NSString *priorityName = searchTaskArray[indexPath.row].priortyTask.priorityStr;
        cell.textLabel.text = searchTaskArray[indexPath.row].titleTask;
        cell.imageView.image = [UIImage imageNamed: priorityName];
        
    }else{
        NSString *priorityName = tasksArray[indexPath.row].priortyTask.priorityStr;
        cell.textLabel.text = tasksArray[indexPath.row].titleTask;
        cell.imageView.image = [UIImage imageNamed: priorityName];
    }
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to delet this task" message:@"cannot return again!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL];
        
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteTaskWithIndexOfRow:indexPath.row];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:confirmAction];
        [self presentViewController:alert animated:YES completion:NULL];
    }
}

-(void) deleteTaskWithIndexOfRow:(NSInteger) row{
    NSError *error;
    [tasksArray removeObjectAtIndex:row];
    data = [NSKeyedArchiver archivedDataWithRootObject:tasksArray requiringSecureCoding:YES error:&error];
    [userDefaults setObject:data forKey:@"Task"];
    [self getTasksArray];
    [self.TasksTableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditTaskViewController *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTaskViewController"];
    
    [editTaskVC setRowOfSelectedTask:(int) indexPath.row];
    if(isSearching){
        [editTaskVC setSelectedTask:searchTaskArray[indexPath.row]];
    }else{
        [editTaskVC setSelectedTask:tasksArray[indexPath.row]];
    }
    [self.navigationController pushViewController:editTaskVC animated:YES];
}

- (IBAction)addNewTaskDidPressed:(id)sender {
    AddNewTaskViewController *addNewTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTaskViewController"];
    [addNewTaskVC setTaskProto:self];
    [self.navigationController pushViewController:addNewTaskVC animated:YES];
}

- (void)transTask:(nonnull Task *)myNewTask {
    //[tasksArray addObject:myNewTask];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        _resultsLabel.hidden = YES;
        _TasksTableView.hidden = NO;
        isSearching = NO;
    }else{
        isSearching = YES;
        searchTaskArray = [NSMutableArray new];
        for(int i = 0; i < [tasksArray count]; i++){
            if([tasksArray[i].titleTask hasPrefix:searchText] || [tasksArray[i].titleTask hasPrefix:[searchText lowercaseString]]){
                [searchTaskArray addObject:tasksArray[i]];
            }
        }
        if([searchTaskArray count] == 0){
            printf("No results\n");
            _resultsLabel.hidden = NO;
            self.TasksTableView.hidden = YES;
        }else{
            _resultsLabel.hidden = YES;
            self.TasksTableView.hidden = NO;
        }
    }
    [self.TasksTableView reloadData];
}

@end
