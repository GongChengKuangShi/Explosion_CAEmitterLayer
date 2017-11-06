//
//  ViewController.m
//  TheExplosionButton
//
//  Created by xrh on 2017/11/6.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import "ViewController.h"
#import "BowButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    BowButton *button = [[BowButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 220, 100, 100)];
    [self.view addSubview:button];
}


@end
