//
//  TabBarViewController.h
//  Listy
//
//  Created by Silstone on 13/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TabBarViewController : UITabBarController<UITabBarControllerDelegate>
{
    AppDelegate *del;
}

@end
