//
//  SASignInRequest.h
//  Sigma
//
//  Created by 汤轶侬 on 16/8/3.
//  Copyright (c) 2016 sigma. All rights reserved.
//



#import "SARequestBase.h"

@interface SASignInRequest : SARequestBase

+ (void)requestSignInWithUsername:(NSString *)username password:(NSString *)password;

@end