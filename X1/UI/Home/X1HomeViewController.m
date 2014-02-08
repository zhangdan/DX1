//
//  X1HomeViewController.m
//  X1
//
//  Created by zhangdan on 14-2-7.
//  Copyright (c) 2014年 sogou-inc.com. All rights reserved.
//

#import "X1HomeViewController.h"

@interface X1HomeViewController ()

@end

@implementation X1HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UILabel *x1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 50)];
    x1.textColor = [UIColor blackColor];
    x1.font = [UIFont systemFontOfSize:40.0f];
    x1.textAlignment  = NSTextAlignmentCenter;
    x1.text = @"Hello  X1";
    [self.view addSubview:x1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
