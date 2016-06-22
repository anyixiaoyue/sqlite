//
//  XLAddViewController.m
//  sqlite
//
//  Created by 肖乐 on 16/6/17.
//  Copyright © 2016年 Shaw. All rights reserved.
//

#import "XLAddViewController.h"

#import "XLSQLManager.h"

#import "StudentMode.h"

@interface XLAddViewController ()

@end

@implementation XLAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setValueInFieldWithID:_idNum andName:_name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setValueInFieldWithID:(NSString *)Id andName:(NSString *)name {
    
    if (Id) {
    
        self.idNumTextField.text = Id;
    
    }
    
    if (name) {
        
        self.nameTextField.text = name;
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual:@"AddUser"]) {
        
        if (_isChanged) {
            
            _isChanged = NO;
            
            StudentMode *model = [[StudentMode alloc] init];
            
            model.idNum = self.idNumTextField.text;
            
            model.name = self.nameTextField.text;
            
            [[XLSQLManager shareManager] modify:model];

        } else {
        
            StudentMode *model = [[StudentMode alloc] init];
            
            model.idNum = self.idNumTextField.text;
            
            model.name = self.nameTextField.text;
            
            // 写入数据库操作
            [[XLSQLManager shareManager] insert:model];
        
        }
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
