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
    NSString *priorityName;
    NSUserDefaults *userDefaults;
    NSData *dataSaved;
    NSSet *setDoneTasks;
    NSData *data;
}

@property (weak, nonatomic) IBOutlet UISearchBar *doneSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *doneTableView;

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
    _doneTableView.dataSource = self;
    _doneTableView.delegate =  self;
    userDefaults = [NSUserDefaults standardUserDefaults];
}

-(void) setUtility{
    doneHigh = [NSMutableArray new];
    doneMid = [NSMutableArray new];
    doneLow = [NSMutableArray new];
    self.navigationController.navigationBar.tintColor = UIColor.lightGrayColor;
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
            idHigh++;
         }else if([[[doneArray[i] priortyTask] priorityStr] isEqual:@"mid"]){
             [doneMid addObject: doneArray[i]];
             [doneMid[idMid] setTaskID:i];
             idMid++;
        }else if([[[doneArray[i] priortyTask] priorityStr] isEqual:@"low"]){
            [doneLow addObject:doneArray[i]];
            [doneLow[idLow] setTaskID:i];
            idLow++;
        }
    }
    [self.doneTableView reloadData];
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
    
    UIImageView *img = [cell viewWithTag:1];
    UILabel *titleLabel = [cell viewWithTag:2];
    UILabel *descriptionLabel = [cell viewWithTag:3];
    UIView *view = [cell viewWithTag:4];
    
    view.layer.cornerRadius  = 20;
    view.layer.shadowRadius  = 2;
    view.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    view.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowOpacity = 0.9f;
    view.layer.masksToBounds = NO;
    
    switch (indexPath.section) {
        case 0:
            view.backgroundColor = [UIColor colorWithRed:243/256.0 green:197/256.0 blue:197/256.0 alpha:1.0];
            priorityName = doneHigh[indexPath.row].priortyTask.priorityStr;
            img.image = [UIImage imageNamed: priorityName];
            titleLabel.text = doneHigh[indexPath.row].titleTask;
            descriptionLabel.text = doneHigh[indexPath.row].descriptionTask;
            break;
        case 1:
            view.backgroundColor = [UIColor colorWithRed:255/256.0 green:206/256.0 blue:69/256.0 alpha:1.0];
            priorityName = doneMid[indexPath.row].priortyTask.priorityStr;
            img.image = [UIImage imageNamed: priorityName];
            titleLabel.text = doneMid[indexPath.row].titleTask;
            descriptionLabel.text = doneMid[indexPath.row].descriptionTask;
            break;
        case 2:
            view.backgroundColor = [UIColor colorWithRed:192/256.0 green:216/256.0 blue:192/256.0 alpha:1.0];
            priorityName = doneLow[indexPath.row].priortyTask.priorityStr;
            img.image = [UIImage imageNamed: priorityName];
            titleLabel.text = doneLow[indexPath.row].titleTask;
            descriptionLabel.text = doneLow[indexPath.row].descriptionTask;
            break;
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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
                titel = @"Mid Priority";
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
                            self->data = [NSKeyedArchiver archivedDataWithRootObject:self->doneArray requiringSecureCoding:YES error:&error];
                            [self->userDefaults setObject:self->data forKey:@"DoneTasks"];
                            [self.doneTableView reloadData];
                        }
                    }
                    [self->doneHigh removeObjectAtIndex:indexPath.row];
                    [self.doneTableView reloadData];
                    break;
                case 1:
                    for(int i = 0; i < [self->doneArray count]; i++){
                        if(self->doneArray[i].taskID == self->doneMid[indexPath.row].taskID){
                            [self->doneArray removeObjectAtIndex:i];
                            NSError *error;
                            self->data = [NSKeyedArchiver archivedDataWithRootObject:self->doneArray requiringSecureCoding:YES error:&error];
                            [self->userDefaults setObject:self->data forKey:@"DoneTasks"];
                            [self.doneTableView reloadData];
                        }
                    }
                    [self->doneMid removeObjectAtIndex:indexPath.row];
                    [self.doneTableView reloadData];
                    break;
                case 2:
                    for(int i = 0; i < [self->doneArray count]; i++){
                        if(self->doneArray[i].taskID == self->doneLow[indexPath.row].taskID){
                            [self->doneArray removeObjectAtIndex:i];
                            NSError *error;
                            self->data = [NSKeyedArchiver archivedDataWithRootObject:self->doneArray requiringSecureCoding:YES error:&error];
                            [self->userDefaults setObject:self->data forKey:@"DoneTasks"];
                            [self.doneTableView reloadData];
                        }
                    }
                    [self->doneLow removeObjectAtIndex:indexPath.row];
                    [self.doneTableView reloadData];
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
