//
//  BriefIntroductionModel.h
//  Sigma
//
//  Created by 韩佳成 on 16/8/8.
//  Copyright © 2016年 韩佳成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BriefIntroductionModel : NSObject

@property(nonatomic,copy)NSString* courseName;

@property(nonatomic,copy)NSString* courseDescription;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

+(instancetype)categoryModelWithDict:(NSDictionary*)dic;

@end