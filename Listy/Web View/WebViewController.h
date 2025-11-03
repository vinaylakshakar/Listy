//
//  WebViewController.h
//  Listy
//
//  Created by Silstone on 26/09/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController<UIGestureRecognizerDelegate,WKNavigationDelegate>
@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) NSString *titleListItem;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIImageView *listTutorialImage;
@property (strong, nonatomic) IBOutlet UIView *tutorialView;
@property BOOL isFromSetting;

@end
