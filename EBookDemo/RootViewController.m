//
//  RootViewController.m
//  EBookDemo
//
//  Created by Zhou Hao on 11/09/14.
//  Copyright (c) 2014年 Zhou Hao. All rights reserved.
//

#import "RootViewController.h"
#import "DataViewController.h"

@interface RootViewController ()

@property (strong, nonatomic) NSArray *pageData;
@property BOOL isLandscape; // because the interfaceOrientation is not changed yet during spineLocationForInterfaceOrientation

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;

    DataViewController *startingViewController = [self viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.pageViewController.dataSource = self;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    pageViewRect = CGRectInset(pageViewRect, 20.0, 40.0);
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

-(void)loadData {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    _pageData = [NSMutableArray arrayWithArray:[[dateFormatter monthSymbols] copy]];
    
    // for testing
    //[_pageData removeLastObject];
    
    self.pageData = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"8.jpg",@"9.jpg",@"10.jpg",@"11.jpg",@"12.jpg",@"13.jpg",@"14.jpg",@"15.jpg"];
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(DataViewController *)viewController
{
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

- (UIViewController *)blankViewController {
    
    UIViewController* vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor clearColor];
    return vc;
}

- (UIViewController *)getCurrentViewController {
    UIViewController *currentViewController = nil;
    if ( self.pageViewController.viewControllers.count == 1 )
        currentViewController = self.pageViewController.viewControllers[0];
    else {
        UIViewController* vc = self.pageViewController.viewControllers[1];
        if ( [vc isKindOfClass:[DataViewController class]] )
            currentViewController = vc;
        else
            currentViewController = self.pageViewController.viewControllers[0];
    }
    return currentViewController;
}

#pragma mark - UIPageViewController delegate methods

/*
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        // In portrait orientation: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        UIViewController *currentViewController = [self getCurrentViewController];
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.pageViewController.doubleSided = NO;
        self.isLandscape = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    self.isLandscape = YES;
    DataViewController *currentViewController = (DataViewController *)[self getCurrentViewController];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self indexOfViewController:currentViewController];
    
    if (indexOfCurrentViewController == 0) {
        viewControllers = @[[self blankViewController],currentViewController];
    }
    else if ( indexOfCurrentViewController % 2 != 0) {
        UIViewController *nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    return UIPageViewControllerSpineLocationMid;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ( ![viewController isKindOfClass:[DataViewController class]] )
        return nil;
    
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ( index == 0 ) {
        if (self.isLandscape) {
            return [self blankViewController];
        }

        return nil;
    } else if ( index == NSNotFound ) {
        
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ( ![viewController isKindOfClass:[DataViewController class]] )
        return nil;
    
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (self.isLandscape) {
        if (index == [self.pageData count] && [self.pageData count] % 2 == 0) {
            return [self blankViewController];
        }
    } else {
        if (index == [self.pageData count]) {
            return nil;
        }
    }
    
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}


@end
