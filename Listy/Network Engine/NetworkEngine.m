  //
//  NetworkEngine.m
//  Keep
//
//  Created by Eweb-A1-iOS on 30/09/15.
//  Copyright © 2015 Mnjt-PC. All rights reserved.
//

#import "NetworkEngine.h"
//#import "Utility.h"
//#import <Stripe/Stripe.h>
#import "AppDelegate.h"
#import "Listy.pch"
//#import "Constants.h"
//#define kBaseURL @"http://192.168.1.253/chowze/webservice/"
//#define kBaseURL @"http://a1professionals.net/showtimebroker/webservices/"
#define compressVal 0.5
static NetworkEngine *sharedNetworkEngine = nil;
@implementation NetworkEngine
@synthesize httpManager;

+(id)sharedNetworkEngine{
 if(sharedNetworkEngine == nil)
 {
  sharedNetworkEngine = [[NetworkEngine alloc]init];
 }
 return sharedNetworkEngine;
}

-(id)init {
 self = [super init];
 if(self) {
  self.httpManager = [AFHTTPRequestOperationManager manager];
  
  //self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/javascript",@"text/plain", nil];
      self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/javascript", nil];
  
  [self.httpManager.requestSerializer setAuthorizationHeaderFieldWithUsername:nil password:nil];

 }
 return self;
}

-(void)loginUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"Login?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)ForgetPassword:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"ForgetPassword?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)DashboardListing:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
   // [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:@"Bearer J1nM9P4CYI6DZyeuTe_YKTigJBf0kA8gBRTkrl9rXXGwGZcCRKq6s8tN0HcuZTs2A49Gx57PdlMobCuFk0VjhtobFtTa-YNUhlfoo7Q_xmwHTkfT78xJ2L23DfU5W3Yx" forHTTPHeaderField:@"Authorization"];
    
    [self.httpManager GET:@"https://api.yelp.com/v3/businesses/search?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)GetRestaurantDetail:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:@"Bearer J1nM9P4CYI6DZyeuTe_YKTigJBf0kA8gBRTkrl9rXXGwGZcCRKq6s8tN0HcuZTs2A49Gx57PdlMobCuFk0VjhtobFtTa-YNUhlfoo7Q_xmwHTkfT78xJ2L23DfU5W3Yx" forHTTPHeaderField:@"Authorization"];
    
    NSString *url  =[NSString stringWithFormat:@"https://api.yelp.com/v3/businesses/%@",[params valueForKey:@"id"]];
    
    [self.httpManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}


-(void)RegisterUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
//    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
//    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"Registration?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"]];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetTokenAccess:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
   // [kAppDelegate showProgressHUD];
    
    //    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager GET:kBaseURL@"Token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)Newsfeedlist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    ; [kAppDelegate showProgressHUD];
    
    //NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];

    [self.httpManager GET:kBaseURL@"Newsfeedlist?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)CreatePost:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //NSLog(@"params %@",params);
    NSData *data = UIImageJPEGRepresentation(imageName, 0.5);
    //self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    [self.httpManager POST:kBaseURL@"CreatePost" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:data name:@"RestaurantImage" fileName:filePath mimeType:@"image/jpeg"];
     }
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         completionBlock(responseObject);
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
     }];
}


-(void)Deletenewsfeed:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    [self.httpManager DELETE:kBaseURL@"Deletenewsfeed" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)Categorieslist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"Keyword?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)UserOnboarding:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"UserOnboarding?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)CreateCategory:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"CreateCategory?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)Deletedlists:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"Deletedlist?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)Draftlists:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"Draftlists?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)UserCategories:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"UserCategories?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)UserCategorylist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"UserCategorylist?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)RemoveMultipleList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"RemoveMultipleList?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}


-(void)Createlist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"Createlist?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)DeleteList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"DeleteList?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)DeletelistItem:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    //[kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"DeletelistItem?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)CreateListWithCover:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //NSLog(@"params %@",params);
    NSData *data = UIImageJPEGRepresentation(imageName, compressVal);
    //self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"Createlist?" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:data name:@"ImageUrl" fileName:filePath mimeType:@"image/jpeg"];
     }
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         completionBlock(responseObject);
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
     }];
}


-(void)CreateListItem:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //NSLog(@"params %@",params);
    NSData *data = UIImageJPEGRepresentation(imageName, compressVal);
    //self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"CreatelistItem" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:data name:@"ImageUrl" fileName:filePath mimeType:@"image/jpeg"];
     }
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         completionBlock(responseObject);
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
     }];
}

-(void)ListItemReport:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"ListItemReport?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)ListItemSaved:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"ListItemSaved?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)ListItemaddlike:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    //[kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"ListItemaddlike?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)category_list_detail:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    //[kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"Userlist?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)listaddcomment:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"listaddcomment?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetListComment:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
   // [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"ListComment?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)ListCommentsWithUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    // [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"ListCommentsWithUser?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}


-(void)ListaddLike:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
   // [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"ListaddLike?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)ListSaved:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"ListSaved?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)ListReport:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"ListReport?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)UserlistItem:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
   // [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"UserlistItem?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)DeleteFolder:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"DeleteFolder?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)GetUserInfo:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"GetUserInfo?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)UpdateUserInfo:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //NSLog(@"params %@",params);
    
        NSData *data = UIImageJPEGRepresentation(imageName, 0.5);
        //self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        //    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
        
        [self.httpManager POST:kBaseURL@"UpdateUserInfo?" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             [formData appendPartWithFileData:data name:@"image" fileName:filePath mimeType:@"image/jpeg"];
         }
                       success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             completionBlock(responseObject);
         }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [kAppDelegate hideProgressHUD];
             errorBlock(error);
         }];

}

-(void)UserFollowerlist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"UserFollowerlist?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)Userfollowinglist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"Userfollowinglist?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)GetFollowerInfo:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"GetFollowerInfo?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)Userfollow:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"Userfollow?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)Recoverlist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"Recoverlist?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)list_share:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"listshare?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)EditSetting:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"EditSetting?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}


-(void)CloseAccount:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"CloseAccount?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)Userlogout:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"Userlogout?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)Sendfeedback:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    //    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    //    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"Sendfeedback?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)Notification:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
   // [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"Notification?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
           // [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)getWikiDesc:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:@"https://en.wikipedia.org/w/api.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)getWikiSearch:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    //[kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:@"https://en.wikipedia.org/w/api.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        if([responseObject valueForKey:@"status"])
//        {
//            
//            completionBlock(responseObject);
//        }
//        else
        {
            completionBlock(responseObject);
           // [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)TermsPrivacy:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"TermsPrivacy?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)discover_list:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    //[kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    [self.httpManager GET:kBaseURL@"DiscoverList?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)UserTopList:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    //[kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    [self.httpManager GET:kBaseURL@"UserTopList?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)CategorizedItems:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    //[kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    //[self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"CategorizedItems?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"status"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

//-------------------------------
//- (void)createCustomerKeyWithAPIVersion:(NSString *)apiVersion completion:(STPJSONResponseCompletionBlock)completion {
//    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"ephemeral_keys"];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:@"" parameters:@{@"api_version": apiVersion} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//         completion(responseObject, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         completion(nil, error);
//    }];
//}

@end
