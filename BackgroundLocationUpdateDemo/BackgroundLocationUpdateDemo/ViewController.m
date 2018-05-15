//
//  ViewController.m
//  BackgroundLocationUpdateDemo
//
//  Created by Edward on 2018/5/14.
//  Copyright © 2018年 coolpeng. All rights reserved.
//

#import "ViewController.h"
#import "PljLocationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor orangeColor];
    [self startUpdatingLocation];
}

- (void)startUpdatingLocation {
    PljLocationManager *manager = [PljLocationManager sharedManager];
    [manager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
