//
//  SAEInformationCell.h
//  Sigma
//
//  Created by Terence on 16/7/18.
//  Copyright © 2016年 Terence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAEInformationModel.h"
@interface SAEInformationCell : UITableViewCell

-(void)setData:(SAEInformationModel *)data;

-(instancetype)initUI;

@end