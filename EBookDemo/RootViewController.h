//
//  RootViewController.h
//  EBookDemo
//
//  Created by Zhou Hao on 11/09/14.
//  Copyright (c) 2014年 Zhou Hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
