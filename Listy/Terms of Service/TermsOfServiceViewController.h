//
//  TermsOfServiceViewController.h
//  Listy
//
//  Created by Silstone on 06/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface TermsOfServiceViewController : UIViewController
@property (strong, nonatomic) IBOutlet WKWebView *webView;
- (IBAction)backBtnAction:(id)sender;
@end
