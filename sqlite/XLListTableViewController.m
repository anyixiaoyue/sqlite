//
//  XLListTableViewController.m
//  sqlite
//
//  Created by 肖乐 on 16/6/17.
//  Copyright © 2016年 Shaw. All rights reserved.
//

#import "XLListTableViewController.h"

#import "XLAddViewController.h"

#import "StudentMode.h"

#import "XLSQLManager.h"

@interface XLListTableViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchTextFiled;

@property (strong, nonatomic) NSMutableArray *studentArray; // 数据源 - 模型

@property (nonatomic, strong) StudentMode *selectedMode;

@property (nonatomic, assign) BOOL isChanged;

@end

@implementation XLListTableViewController

#define ListCellIdentifier (@"StudentCell")

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.studentArray = [[NSMutableArray alloc] init];
    
    self.studentArray = [NSMutableArray arrayWithArray:[[XLSQLManager shareManager] searchAllModel]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _studentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (self.studentArray.count > 0) {
        
        StudentMode *model = [self.studentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.idNum;
        cell.detailTextLabel.text = model.name;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectedMode = [_studentArray objectAtIndex:indexPath.row];
    
    _isChanged = YES;
    
    [self performSegueWithIdentifier:@"GoDetail" sender:self];
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [[XLSQLManager shareManager] remove:[_studentArray objectAtIndex:indexPath.row]];
        
        [_studentArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
}


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



- (IBAction)AddUser:(UIStoryboardSegue *)sender {
    
    StudentMode *model = [[StudentMode alloc] init];
    
    model.idNum = @"100";
    
//    StudentMode *result = [[XLSQLManager shareManager] searchWithIdNum:model];
    
    _studentArray = [NSMutableArray arrayWithArray:[[XLSQLManager shareManager] searchAllModel]];
    
//    if (result) {
//        
//    [_studentArray addObject:result];
//    
//    }
    
    [self.tableView reloadData];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"begingEditing!");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange");
    
    StudentMode *model = [[StudentMode alloc] init];
    
    model.idNum = searchText;
    
    self.studentArray = [NSMutableArray arrayWithArray:[[XLSQLManager shareManager] searchWithIdNum:model]];
    
    [self.tableView reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.studentArray = [NSMutableArray arrayWithArray:[[XLSQLManager shareManager] searchAllModel]];

    [self.tableView reloadData];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    self.studentArray = [NSMutableArray arrayWithArray:[[XLSQLManager shareManager] searchAllModel]];
    
    [self.tableView reloadData];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"GoDetail"]) {
        
        XLAddViewController *recive = (XLAddViewController *)[segue.destinationViewController.childViewControllers objectAtIndex:0];
        
        recive.idNum = _selectedMode.idNum;
        
        recive.name = _selectedMode.name;
        
        if (_isChanged) {
            
            recive.isChanged = YES;

            _isChanged = NO;
        }
    }
}


@end
