//
//  InviteFriendsViewController.h
//  Listy
//
//  Created by Silstone on 07/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface InviteFriendsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *inviteTable;
- (IBAction)inviteAllAction:(id)sender;
- (IBAction)skipBtnAction:(id)sender;
@property (strong, nonatomic) NSString *facebookId;
@end
