//
//  Utility.h
//  Keep
//
//  Created by eweba1-pc-69 on 18/08/2015.
//  Copyright (c) 2015 Mnjt-PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(void)showAlertMessage:(NSString *)title message :(NSString *)message;
+(BOOL)emailValidation:(NSString *)emailText;
+(NSMutableURLRequest *)makeMultipartDataForStickerPost:(NSDictionary *)paramDict path:(NSString *)service httpMethod:(NSString *)method;
+ (NSDictionary *)getCountryCodeDictionary;
+(UIImage*)setImage:(NSMutableDictionary*)dict;
+(NSMutableDictionary *)removeNullFromDictionary:(NSMutableDictionary *)dic;
@end
