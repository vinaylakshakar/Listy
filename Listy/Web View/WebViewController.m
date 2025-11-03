//
//  WebViewController.m
//  Listy
//
//  Created by Silstone on 26/09/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "WebViewController.h"
#import "Listy.pch"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSString *urlText = @"https://images.google.com/";
    if (self.isFromSetting)
    {
         [self.navigationController setNavigationBarHidden:NO];
         [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://listyapp.com/faq/"]]];
        
      //  -webkit-user-select: none

    } else
    {
        [self setLayout];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)setLayout
{
    NSString *urlText;
    if ([self.titleListItem isEqualToString:@"Enter item name"]||[self.titleListItem isEqualToString:@"(null)"])
    {
        urlText= [NSString stringWithFormat:@"https://www.google.com/"];
    } else {
        urlText= [NSString stringWithFormat:@"https://www.google.com/search?q=%@",self.titleListItem];
    }
    
    NSString *trimmed1 = [urlText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *trimmedUrl = [trimmed1 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    //NSString *trimmedUrl = [urlText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   // NSString *src = @"Convert special characters like ë,à,é,ä all to e,a,e,a? Objective C";
    NSData *temp = [trimmedUrl dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *dst = [[NSString alloc] initWithData:temp encoding:NSASCIIStringEncoding];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dst]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToPriviousController) name:UIPasteboardChangedNotification object:nil];
    
    [_webView removeGestureRecognizer:self.longPressGestureRecognizer]; // This code will remove the dependency and recover the lost functionality.
    
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    self.longPressGestureRecognizer.numberOfTouchesRequired = 1;
    self.longPressGestureRecognizer.minimumPressDuration =3.0;
    self.longPressGestureRecognizer.delegate = self;
    
    [_webView addGestureRecognizer:self.longPressGestureRecognizer];
    
    if ([USERDEFAULTS valueForKey:showTutorial]==nil)
    {
        [USERDEFAULTS setObject:@"showTutorial" forKey:showTutorial];
        //        TutorialViewController *listTutorial =[self.storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
        //        [self.navigationController pushViewController:listTutorial animated:NO];
        [self.tutorialView setHidden:NO];
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuesture:)];
        tapGuesture.numberOfTapsRequired = 1;
        [self.tutorialView addGestureRecognizer:tapGuesture];
        [self setTutorialImage];
    }else
    {
        [self.navigationController setNavigationBarHidden:NO];
    }
    
}

-(void)backToPriviousController
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)setTutorialImage
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if ((int)[[UIScreen mainScreen] nativeBounds].size.height>=2436)
        {
            [self.listTutorialImage setImage:[UIImage imageNamed:@"tutorial_firstx"]];
            
        }else
        {
            [self.listTutorialImage setImage:[UIImage imageNamed:@"tutorial_first"]];
        }
    }
}

- (void)tapGuesture:(UITapGestureRecognizer*)sender
{
    NSLog(@"tapGuesture web view page called");
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if ((int)[[UIScreen mainScreen] nativeBounds].size.height>=2436)
        {
            if ([self image:self.listTutorialImage.image isEqualTo:[UIImage imageNamed:@"tutorial_firstx"]]) {
                [self.listTutorialImage setImage:[UIImage imageNamed:@"tutorial_secondx"]];
            }else
                if ([self image:self.listTutorialImage.image isEqualTo:[UIImage imageNamed:@"tutorial_secondx"]]) {
                    [self.listTutorialImage setImage:[UIImage imageNamed:@"tutorial_thirdx"]];
                }else
                
                    if ([self image:self.listTutorialImage.image isEqualTo:[UIImage imageNamed:@"tutorial_thirdx"]]) {
                        [self.tutorialView setHidden:YES];
                        [self.navigationController setNavigationBarHidden:NO];
                    }
        }
        else
        {
            if ([self image:self.listTutorialImage.image isEqualTo:[UIImage imageNamed:@"tutorial_first"]]) {
                [self.listTutorialImage setImage:[UIImage imageNamed:@"tutorial_second"]];
            }else
                if ([self image:self.listTutorialImage.image isEqualTo:[UIImage imageNamed:@"tutorial_second"]]) {
                    [self.listTutorialImage setImage:[UIImage imageNamed:@"tutorial_third"]];
                }else
                    if ([self image:self.listTutorialImage.image isEqualTo:[UIImage imageNamed:@"tutorial_third"]]) {
                        [self.tutorialView setHidden:YES];
                        [self.navigationController setNavigationBarHidden:NO];
                    }
        }
        
    }
    
    
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}


- (void)longPress:(UILongPressGestureRecognizer *)sender
{
//    CGPoint touchPoint = [sender locationInView:self.webView];
//    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
//    NSString *urlToSave = [self stringByEvaluatingJavaScriptFromString:js];
//    //Returning an empty string
//    if (urlToSave.length > 0) {
//       // [self performSegueWithIdentifier:@"introToMain" sender:self];
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string = urlToSave;
//    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            
            // Warning: This will break how WKWebView handles selection of text.
            
            [otherGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        }
        CGPoint touchPoint = [self.longPressGestureRecognizer locationInView:self.webView];
        NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
        
        NSString *imageUrl =[self stringByEvaluatingJavaScriptFromString:js];
        //NSLog(@"imageUrl %@",imageUrl);
        if (imageUrl.length > 0) {
            // [self performSegueWithIdentifier:@"introToMain" sender:self];
            dispatch_async(dispatch_get_main_queue(), ^{
                    [kAppDelegate showProgressHUD];
            });
           
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = imageUrl;
            [pasteboard setValue:imageUrl forPasteboardType:UIPasteboardNameGeneral];
            
        }
    }
    
    return YES;
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script {
    __block NSString *resultString = nil;
    __block BOOL finished = NO;
    
    [self.webView evaluateJavaScript:script completionHandler:^(id result, NSError *error) {
        if (error == nil) {
            if (result != nil) {
                resultString = [NSString stringWithFormat:@"%@", result];
            }
        } else {
            //NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
        finished = YES;
    }];
    
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return resultString;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
