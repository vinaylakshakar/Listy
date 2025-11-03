//
//  TabBarViewController.m
//  Listy
//
//  Created by Silstone on 13/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "TabBarViewController.h"
#import "Listy.pch"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    [UITabBar appearance].layer.borderWidth = 0.0f;
    [UITabBar appearance].clipsToBounds = true;
    self.delegate = self;
    
    [USERDEFAULTS setBool:YES forKey:kalreadyLoggedIn];
    [USERDEFAULTS synchronize];
    [self setSelectedIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    self.tabBarController.selectedIndex = 1;
//    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [theTabBarController.viewControllers indexOfObject:viewController];
    //NSLog(@"Tab index = %u (%u)", (int)indexOfTab);
    if (indexOfTab==1)
    {
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverList" object:self userInfo:nil];
    }
    if (indexOfTab==3)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
       
    }
    if(indexOfTab!=2)
    {
        del.folderCategoryID = @"";
         del.folderCategoryName = @"";
    }
}

@end
