//
//  MainViewController.m
//  PM
//
//  Created by 张浩 on 14-6-9.
//  Copyright (c) 2014年 Huoli. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initViewControllers
    [self initViewControllers];
}

- (void)initViewControllers
{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    ReleaseViewController *releaseVC = [[ReleaseViewController alloc] init];
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
    NearByViewController *nearVC = [[NearByViewController alloc] init];
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    NSArray *views = @[homeVC, releaseVC, userInfoVC, nearVC, moreVC];
    NSArray *names = @[@"首页", @"发布", @"我的", @"发现", @"更多"];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:views.count];
    for (int i=0; i<5; i++) {
        UIViewController *viewVC = [views objectAtIndex:i];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:[names objectAtIndex:i] image:[UIImage imageNamed:@"tabbar_home.png"] tag:i];
        viewVC.tabBarItem = tabItem;
        viewVC.title = [names objectAtIndex:i];
        
        BaseNavigationController *baseNV = [[BaseNavigationController alloc] initWithRootViewController:viewVC];
        [viewControllers addObject:baseNV];
 
    }
    self.viewControllers = viewControllers;
}

#pragma mark -- UINavigationControllerDelgate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
