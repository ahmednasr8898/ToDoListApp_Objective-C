//
//  InProgressViewController.m
//  ToDoList
//
//  Created by Ahmed Nasr on 29/01/2022.
//

#import "InProgressViewController.h"
#import "Task.h"
#import "EditInProgressViewController.h"

@interface InProgressViewController (){
    
    NSMutableArray<Task*> *inProgressHigh;
    NSMutableArray<Task*> *inProgressMid;
    NSMutableArray<Task*> *inProgressLow;
    NSMutableArray<Task*> *inProgressArray;
    NSUserDefaults *userDefaults;
    NSData *dataSaved;
    NSSet *setInProgressTasks;
}

@property (weak, nonatomic) IBOutlet UISearchBar *inProgressSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *inProgressTableView;

@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _inProgressSearchBar.delegate = self;
    [self setUp];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUtility];
    [self setInProgressTask];
}

-(void) setUp{
    _inProgressTableView.dataSource = self;
    _inProgressTableView.delegate =  self;
    userDefaults = [NSUserDefaults standardUserDefaults];
}

-(void) setUtility{
    inProgressHigh = [NSMutableArray new];
    inProgressMid = [NSMutableArray new];
    inProgressLow = [NSMutableArray new];
}

-(void) setInProgressTask{
    int idHigh = 0, idMid = 0, idLow = 0;
    dataSaved = [userDefaults objectForKey:@"InProgressTasks"];
    NSError *error;
    setInProgressTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    inProgressArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setInProgressTasks fromData:dataSaved error:&error];
    
    for(int i = 0; i < [inProgressArray count]; i++){
        if([[[inProgressArray[i] priortyTask] priorityStr] isEqual:@"high"]){
            [inProgressHigh addObject:inProgressArray[i]];
            [inProgressHigh[idHigh] setTaskID:i];
            printf("arr id: %d\n",i);
            printf("high id: %d\n",inProgressHigh[idHigh].taskID);
            idHigh++;
         }else if([[[inProgressArray[i] priortyTask] priorityStr] isEqual:@"mid"]){
             [inProgressMid addObject: inProgressArray[i]];
             [inProgressMid[idMid] setTaskID:i];
             printf("arr id: %d\n",i);
             printf("mid id: %d\n",inProgressMid[idMid].taskID);
             idMid++;
        }else if([[[inProgressArray[i] priortyTask] priorityStr] isEqual:@"low"]){
            [inProgressLow addObject:inProgressArray[i]];
            [inProgressLow[idLow] setTaskID:i];
            printf("arr id: %d\n",i);
            printf("low id: %d\n",inProgressLow[idLow].taskID);
            idLow++;
        }
    }
    [self.inProgressTableView reloadData];
}

//tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = [inProgressHigh count];
            break;
        case 1:
            numberOfRows = [inProgressMid count];
            break;
        case 2:
            numberOfRows = [inProgressLow count];
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InProgressCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = inProgressHigh[indexPath.row].titleTask;
            cell.detailTextLabel.text = inProgressHigh[indexPath.row].descriptionTask;
            cell.imageView.image = [UIImage imageNamed:inProgressHigh[indexPath.row].priortyTask.PriorityImg];
            break;
        case 1:
            cell.textLabel.text = inProgressMid[indexPath.row].titleTask;
            cell.detailTextLabel.text = inProgressMid[indexPath.row].descriptionTask;
            cell.imageView.image = [UIImage imageNamed:inProgressMid[indexPath.row].priortyTask.PriorityImg];
            break;
        case 2:
            cell.textLabel.text = inProgressLow[indexPath.row].titleTask;
            cell.detailTextLabel.text = inProgressLow[indexPath.row].descriptionTask;
            cell.imageView.image = [UIImage imageNamed:inProgressLow[indexPath.row].priortyTask.PriorityImg];
            break;
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *titel = @"";
    switch (section) {
        case 0:
            if([inProgressHigh count] == 0){
                titel = @"";
            }else{
                titel = @"High Priority";
            }
            break;
        case 1:
            if([inProgressMid count] == 0){
                titel = @"";
            }else{
                titel = @"Med Priority";
            }
            break;
        case 2:
            if([inProgressLow count] == 0){
                titel = @"";
            }else{
                titel = @"Low Priority";
            }
            break;
        default:
            break;
    }
    return titel;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditInProgressViewController *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditInProgressViewController"];
    
    switch (indexPath.section) {
        case 0:
            for(int i = 0; i < [inProgressArray count]; i++){
                if(inProgressArray[i].taskID == inProgressHigh[indexPath.row].taskID){
                    [editTaskVC setRowOfSelectedTask: i];
                    [editTaskVC setSelectedTask:inProgressHigh[indexPath.row]];
                }
            }            
            break;
        case 1:
            for(int i = 0; i < [inProgressArray count]; i++){
                if(inProgressArray[i].taskID == inProgressMid[indexPath.row].taskID){
                    [editTaskVC setRowOfSelectedTask: i];
                    [editTaskVC setSelectedTask:inProgressMid[indexPath.row]];
                }
            }
            break;
        case 2:
            for(int i = 0; i < [inProgressArray count]; i++){
                if(inProgressArray[i].taskID == inProgressLow[indexPath.row].taskID){
                    [editTaskVC setRowOfSelectedTask: i];
                    [editTaskVC setSelectedTask:inProgressLow[indexPath.row]];
                }
            }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:editTaskVC animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to delet this task" message:@"cannot return again!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL];
        
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            switch (indexPath.section) {
                  
                case 0:
                    for(int i = 0; i < [self->inProgressArray count]; i++){
                        if(self->inProgressArray[i].taskID == self->inProgressHigh[indexPath.row].taskID){
                            [self->inProgressArray removeObjectAtIndex:i];
                            NSError *error;
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->inProgressArray requiringSecureCoding:YES error:&error];
                            [self->userDefaults setObject:data forKey:@"InProgressTasks"];
                            //[self getTasksArray];
                            //[self setInProgressTask];
                            [self.inProgressTableView reloadData];
                        }
                    }
                    [self->inProgressHigh removeObjectAtIndex:indexPath.row];
                    [self.inProgressTableView reloadData];
                    break;
                case 1:
                    for(int i = 0; i < [self->inProgressArray count]; i++){
                        if(self->inProgressArray[i].taskID == self->inProgressMid[indexPath.row].taskID){
                            [self->inProgressArray removeObjectAtIndex:i];
                            NSError *error;
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->inProgressArray requiringSecureCoding:YES error:&error];
                            [self->userDefaults setObject:data forKey:@"InProgressTasks"];
                            //[self getTasksArray];
                            //[self setInProgressTask];
                            [self.inProgressTableView reloadData];
                        }
                    }
                    [self->inProgressMid removeObjectAtIndex:indexPath.row];
                    [self.inProgressTableView reloadData];
                    break;
                case 2:
                    for(int i = 0; i < [self->inProgressArray count]; i++){
                        if(self->inProgressArray[i].taskID == self->inProgressLow[indexPath.row].taskID){
                            [self->inProgressArray removeObjectAtIndex:i];
                            NSError *error;
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->inProgressArray requiringSecureCoding:YES error:&error];
                            [self->userDefaults setObject:data forKey:@"InProgressTasks"];
                            //[self getTasksArray];
                            //[self setInProgressTask];
                            [self.inProgressTableView reloadData];
                        }
                    }
                    [self->inProgressLow removeObjectAtIndex:indexPath.row];
                    [self.inProgressTableView reloadData];
                    break;
                    
                default:
                    break;
            }
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:confirmAction];
        [self presentViewController:alert animated:YES completion:NULL];
    }
}

@end
