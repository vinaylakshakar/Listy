//
//  TermsOfServiceViewController.m
//  Listy
//
//  Created by Silstone on 06/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "TermsOfServiceViewController.h"
#import "Listy.pch"

@interface TermsOfServiceViewController ()

@end

@implementation TermsOfServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self  TermsPrivacy];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://trovy.io/terms/"]]];
   [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillDisappear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

#pragma mark-Api methods


-(void)TermsPrivacy
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]TermsPrivacy:^(id object)
     {
         //NSLog(@"%@",object);

         [self.webView loadHTMLString:[object valueForKey:@"TermsPrivacy"] baseURL:nil];
         
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
    
}


- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
