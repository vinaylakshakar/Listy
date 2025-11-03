//
//  NetworkEngine.h
//  Keep
//
//  Created by Vibha on 30/09/15.
//  Copyright © 2015 Vibha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


typedef void(^completion_block)(id object);
typedef void(^error_block)(NSError *error);
typedef void (^upload_completeBlock)(NSString *url);
@interface NetworkEngine : NSObject

@property(nonatomic,strong)AFHTTPRequestOperationManager *httpManager;
+ (id)sharedNetworkEngine;

// For login purposes
-(void)GetTokenAccess:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)loginUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary*)params;
-(void)DashboardListing:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)RegisterUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetRestaurantDetail:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Newsfeedlist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)CreatePost:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params;
-(void)Deletenewsfeed:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)ForgetPassword:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Categorieslist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)UserOnboarding:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)CreateCategory:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Deletedlists:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Draftlists:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)UserCategories:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)UserCategorylist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)RemoveMultipleList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Createlist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)DeleteList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)CreatelistItem:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)CreateListItem:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params;
-(void)DeletelistItem:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)ListItemReport:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)ListItemSaved:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)ListItemaddlike:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)category_list_detail:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)listaddcomment:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetListComment:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)ListaddLike:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)ListSaved:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)ListReport:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)UserlistItem:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)DeleteFolder:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetUserInfo:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)UpdateUserInfo:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params;
-(void)UserFollowerlist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Userfollowinglist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetFollowerInfo:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Userfollow:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Recoverlist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)list_share:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)EditSetting:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)CloseAccount:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Userlogout:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Sendfeedback:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Notification:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)getWikiDesc:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)TermsPrivacy:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)discover_list:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)UserTopList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)getWikiSearch:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)CreateListWithCover:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params;
-(void)ListCommentsWithUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)CategorizedItems:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
@end



