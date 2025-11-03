//
//  FeedbackViewController.h
//  Listy
//
//  Created by Silstone on 20/11/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *feedbackView;
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *feedbackBtn;
- (IBAction)sendFeedback:(id)sender;

@end

NS_ASSUME_NONNULL_END
