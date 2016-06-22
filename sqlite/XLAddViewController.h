//
//  XLAddViewController.h
//  sqlite
//
//  Created by 肖乐 on 16/6/17.
//  Copyright © 2016年 Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLAddViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *idNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic, strong) NSString *idNum;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL isChanged;

@end
