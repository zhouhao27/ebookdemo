//
//  DataViewController.m
//  EBookDemo
//
//  Created by Zhou Hao on 11/09/14.
//  Copyright (c) 2014年 Zhou Hao. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.dataLabel.text = [self.dataObject description];
    self.imageView.image = [UIImage imageNamed:self.dataObject];
}

@end
