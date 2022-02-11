//
//  DoneTasksViewController.m
//  ToDoList
//
//  Created by Ahmed Nasr on 30/01/2022.
//

#import "DoneTasksViewController.h"
#import "Task.h"
#import "DetailsDoneViewController.h"

@interface DoneTasksViewController (){
    NSMutableArray<Task*> *doneHigh;
    NSMutableArray<Task*> *doneMid;
    NSMutableArray<Task*> *doneLow;
    NSMutableArray<Task*> *doneArray;
    NSUserDefaults *userDefaults;
    NSData *dataSaved;
    NSSet *setDoneTasks;
}

@property (weak, nonatomic) IBOutlet UISearchBar *inProgressSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *inProgressTableView;

@end

@implementation DoneTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    doneHigh = [NSMutableArray new];
    doneMid = [NSMutableArray new];
    doneLow = [NSMutableArray new];
}

-(void) setInProgressTask{
    int idHigh = 0, idMid = 0, idLow = 0;
    dataSaved = [userDefaults objectForKey:@"DoneTasks"];
    NSError *error;
    setDoneTasks = [NSSet setWithArray:@[[NSArray class], [Task class]]];
    doneArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:setDoneTasks fromData:dataSaved error:&error];
    
    for(int i = 0; i < [doneArray count]; i++){
        if([[[doneArray[i] priortyTask] priorityStr] isEqual:@"high"]){
            [doneHigh addObject:doneArray[i]];
            [doneHigh[idHigh] setTaskID:i];
            printf("arr id: %d\n",i);
            printf("high id: %d\n",doneHigh[idHigh].taskID);
            idHigh++;
         }else if([[[doneArray[i] priortyTask] priorityStr] isEqual:@"mid"]){
             [doneMid addObject: doneArray[i]];
             [doneMid[idMid] setTaskID:i];
             printf("arr id: %d\n",i);
             printf("mid id: %d\n",doneMid[idMid].taskID);
             idMid++;
        }else if([[[doneArray[i] priortyTask] priorityStr] isEqual:@"low"]){
            [doneLow addObject:doneArray[i]];
            [doneLow[idLow] setTaskID:i];
            printf("arr id: %d\n",i);
            printf("low id: %d\n",doneLow[idLow].taskID);
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
            numberOfRows = [doneHigh count];
            break;
        case 1:
            numberOfRows = [doneMid count];
            break;
        case 2:
            numberOfRows = [doneLow count];
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = doneHigh[indexPath.row].titleTask;
            cell.detailTextLabel.text = doneHigh[indexPath.row].descriptionTask;
            cell.imageView.image = [UIImage imageNamed:doneHigh[indexPath.row].priortyTask.PriorityImg];
            break;
        case 1:
            cell.textLabel.text = doneMid[indexPath.row].titleTask;
            cell.detailTextLabel.text = doneMid[indexPath.row].descriptionTask;
            cell.imageView.image = [UIImage imageNamed:doneMid[indexPath.row].priortyTask.PriorityImg];
            break;
        case 2:
            cell.textLabel.text = doneLow[indexPath.row].titleTask;
            cell.detailTextLabel.text = doneLow[indexPath.row].descriptionTask;
            cell.imageView.image = [UIImage imageNamed:doneLow[indexPath.row].priortyTask.PriorityImg];;
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *titel = @"";
    switch (section) {
        case 0:
            if([doneHigh count] == 0){
                titel = @"";
            }else{
                titel = @"High Priority";
            }
            break;
        case 1:
            if([doneMid count] == 0){
                titel = @"";
            }else{
                titel = @"Med Priority";
            }
            break;
        case 2:
            if([doneLow count] == 0){
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
    
    DetailsDoneViewController *detailsDoneTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsDoneViewController"];
    
    switch (indexPath.section) {
        case 0:
            for(int i = 0; i < [doneArray count]; i++){
                if(doneArray[i].taskID == doneHigh[indexPath.row].taskID){
                    //[detailsDoneTaskVC set]
                    [detailsDoneTaskVC setSelectedTask:doneHigh[indexPath.row]];
                }
            }
            break;
        case 1:
            for(int i = 0; i < [doneArray count]; i++){
                if(doneArray[i].taskID == doneMid[indexPath.row].taskID){
                    [detailsDoneTaskVC setSelectedTask:doneMid[indexPath.row]];
                }
            }
            break;
        case 2:
            for(int i = 0; i < [doneArray count]; i++){
                if(doneArray[i].taskID == doneLow[indexPath.row].taskID){
                    [detailsDoneTaskVC setSelectedTask:doneLow[indexPath.row]];
                }
            }
            break;
        default:
            break;
    }
    [self presentViewController:detailsDoneTaskVC animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to delet this task" message:@"cannot return again!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL];
        
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            switch (indexPath.section) {
                case 0:
                    for(int i = 0; i < [self->doneArray count]; i++){
                        if(self->doneArray[i].taskID == self->doneHigh[indexPath.row].taskID){
                            [self->doneArray removeObjectAtIndex:i];
                            NSError *error;
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->doneArray requiringSecureCoding:YES error:&error];
                            [self->userDefaults setObject:data forKey:@"DoneTasks"];
                            //[self getTasksArray];
                            //[self setInProgressTask];
                            [self.inProgressTableView reloadData];
                        }
                    }
                    [self->doneHigh removeObjectAtIndex:indexPath.row];
                    [self.inProgressTableView reloadData];
                    break;
                case 1:
                    for(int i = 0; i < [self->doneArray count]; i++){
                        if(self->doneArray[i].taskID == self->doneMid[indexPath.row].taskID){
                            [self->doneArray removeObjectAtIndex:i];
                            NSError *error;
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->doneArray requiringSecureCoding:YES error:&error];
                            [self->userDefaults setObject:data forKey:@"DoneTasks"];
                            //[self getTasksArray];
                            //[self setInProgressTask];
                            [self.inProgressTableView reloadData];
                        }
                    }
                    [self->doneMid removeObjectAtIndex:indexPath.row];
                    [self.inProgressTableView reloadData];
                    break;
                case 2:
                    for(int i = 0; i < [self->doneArray count]; i++){
                        if(self->doneArray[i].taskID == self->doneLow[indexPath.row].taskID){
                            [self->doneArray removeObjectAtIndex:i];
                            NSError *error;
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self->doneArray requiringSecureCoding:YES error:&error];
                            [self->userDefaults setObject:data forKey:@"DoneTasks"];
                            //[self getTasksArray];
                            //[self setInProgressTask];
                            [self.inProgressTableView reloadData];
                        }
                    }
                    [self->doneLow removeObjectAtIndex:indexPath.row];
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
