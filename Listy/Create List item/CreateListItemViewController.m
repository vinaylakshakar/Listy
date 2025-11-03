//
//  CreateListItemViewController.m
//  Listy
//
//  Created by Silstone on 23/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "CreateListItemViewController.h"
#import "Listy.pch"

@interface CreateListItemViewController ()

@end

@implementation CreateListItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.createListView.layer.cornerRadius = 4;
    self.createListView.layer.masksToBounds = YES;
    
    self.addImageBtn.layer.cornerRadius = 4;
    self.addImageBtn.layer.masksToBounds = YES;
    
    self.listBtn.layer.cornerRadius = 4;
    self.listBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


- (IBAction)listBtnAction:(id)sender
{
    [self.view  endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideListContainer" object:self userInfo:nil];
}
@end
