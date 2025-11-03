//
//  TutorialViewController.m
//  Listy
//
//  Created by Silstone on 11/03/19.
//  Copyright © 2019 Silstone. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuesture:)];
    tapGuesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGuesture];
    [self setTutorialImage];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)setTutorialImage
{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tapGuesture:(UITapGestureRecognizer*)sender
{
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
                        [self.navigationController popViewControllerAnimated:NO];
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
                        [self.navigationController popViewControllerAnimated:NO];
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
@end
