//
//  SAPolularClassCell.m
//  Sigma
//
//  Created by Terence on 16/7/15.
//  Copyright © 2016年 Terence. All rights reserved.
//

#import "SAPopularClassCell.h"
#import "SAPopularModel.h"
#import "TextEnhance.h"

#define AVATAIMG_WIDTH 30
#define AVATAIMG_HEIGHT 30

@interface SAPopularClassCell ()

@property(nonatomic, strong) UIImageView* avataImage;
@property(nonatomic, strong) UIView* categoryView;
@property(nonatomic, strong) UIImageView* cellBackgroundImg;
@property(nonatomic, strong) UIImageView* quesVoiceImg;
@property(nonatomic, strong) UILabel* nickNameLabel;
@property(nonatomic, strong) UILabel* titleLabel;
@property(nonatomic, strong) UILabel* descLabel;
@property(nonatomic, strong) UILabel* numberLabel;
@property(nonatomic, strong) SAPopularModel* data;


@end

@implementation SAPopularClassCell

/**
 *  重写InitWithStyle
 *
 *  @param style           <#style description#>
 *  @param reuseIdentifier <#reuseIdentifier description#>
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)setData:(SAPopularModel *)data{
    _data = data;
}

-(instancetype)initUI{
    [self addSubview:self.cellBackgroundImg];
//    [self addSubview:self.categoryView];
    [self.cellBackgroundImg addSubview:self.avataImage];
    [self.cellBackgroundImg addSubview:self.nickNameLabel];
    [self.cellBackgroundImg addSubview:self.titleLabel];
    [self.cellBackgroundImg addSubview:self.descLabel];
    [self.cellBackgroundImg addSubview:self.numberLabel];
    //    [self.cellBackgroundImg addSubview:self.quesVoiceImg];
    return self;
}

/**
 *  类别的View这里是热门课程 ---- 该部分已经转到headerForSection中，可以删除
 *
 *  @return <#return value description#>
 */
-(UIView*)categoryView{
    if (!_categoryView) {
        _categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        //        _categoryView.backgroundColor = [UIColor purpleColor];
        
        UILabel *categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 0, 200, 45)];
        [categoryTitle setText:@"热门课程"];
        [categoryTitle setFont:[UIFont systemFontOfSize:15.f]];
        categoryTitle.textAlignment = NSTextAlignmentCenter;
        //        categoryTitle.backgroundColor = [UIColor yellowColor];
        
        UIView* leftLine = [[UIView alloc] initWithFrame:CGRectMake(30, categoryTitle.frame.size.height/2, 20, 1)];
        leftLine.backgroundColor = [UIColor blackColor];
        
        UIView* rightLine = [[UIView alloc] initWithFrame:CGRectMake(150, categoryTitle.frame.size.height/2, 20, 1)];
        rightLine.backgroundColor = [UIColor blackColor];
        
        
        UIButton* MoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, (categoryTitle.frame.size.height-20)/2, 50, 20)];
        //        [MoreBtn setTitle:@"More" forState:UIControlStateNormal];
        [MoreBtn setImage:[UIImage imageNamed:@"morebtn.png"] forState:UIControlStateNormal];
        
        [MoreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [categoryTitle addSubview:leftLine];
        [categoryTitle addSubview:rightLine];
        [_categoryView addSubview:categoryTitle];
        [_categoryView addSubview:MoreBtn];
    }
    
    return _categoryView;
}
/**
 *  more按钮的点击事件
 *
 *  @param sender <#sender description#>
 */
-(void)moreBtnClicked:(id)sender{
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        NSLog(@"more clicked");
    }
}

/**
 *  cell的背景图
 *
 *  @return <#return value description#>
 */
-(UIImageView*)cellBackgroundImg{
    if (!_cellBackgroundImg) {
        _cellBackgroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.data.cellBackgroundImgName]];
        _cellBackgroundImg.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, _cellBackgroundImg.image.size.height/2);
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, _cellBackgroundImg.image.size.height/2)];
        
        view.backgroundColor = COLOR_RGBA(0, 0, 0, 0.4);
        [_cellBackgroundImg addSubview:view];

        
    }
    
    return _cellBackgroundImg;
}

/**
 *  个人头像图片
 *
 *  @return <#return value description#>
 */
-(UIImageView*)avataImage{
    if (!_avataImage) {
        _avataImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, AVATAIMG_WIDTH, AVATAIMG_HEIGHT)];
        [_avataImage setImage:[UIImage imageNamed:self.data.AvataImgName]];
        
        // img显示为圆形
        _avataImage.layer.cornerRadius = _avataImage.frame.size.width/2;
        _avataImage.layer.masksToBounds=YES;
    }
    return _avataImage;
}


/**
 *  昵称label
 *
 *  @return <#return value description#>
 */
-(UILabel*)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 250, 30)];
        _nickNameLabel.textColor = [UIColor whiteColor];
        [_nickNameLabel setFont:[UIFont systemFontOfSize:12.f]];
        [_nickNameLabel setText:self.data.nickName];
        
    }
    return _nickNameLabel;
}


/**
 *  标题label
 *
 *  @return <#return value description#>
 */
-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.cellBackgroundImg.frame.size.width, 30)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setText:self.data.title];
    }
    
    return _titleLabel;
}

/**
 *  描述label
 *
 *  @return <#return value description#>
 */
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.cellBackgroundImg.frame.size.width-275)/2, (CGFloat)((self.data.cellHeight-40)/2)+45, 275, 40)];
        _descLabel.text = self.data.desc;
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.numberOfLines = 2;
        _descLabel.font = [UIFont systemFontOfSize:13];
    }
    
    return _descLabel;
}

/**
 *  图标
 *
 *  @return <#return value description#>
 */
-(UIImageView*)quesVoiceImg{
    if (!_quesVoiceImg) {
        _quesVoiceImg = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 100, 200, 30)];
        [_quesVoiceImg setImage:[UIImage imageNamed:@"voice.png"]];
    }
    
    return _quesVoiceImg;
}

/**
 *  数字label，显示多少人学习
 *
 *  @return
 */
-(UILabel*)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 80, 30)];
        //        _joinLabel.text = [NSString stringWithFormat:@"%d人参与讨论", self.data.comments];
        _numberLabel.text = [NSString stringWithFormat:@"%d人学习",self.data.number];
        _numberLabel.textColor = [UIColor whiteColor];
        [_numberLabel setFont:[UIFont systemFontOfSize:12.f]];
        
        [TextEnhance resizeUILabelWidth:_numberLabel];
        CGRect rect = _numberLabel.frame;
        //        rect.origin.x = (SCREEN_WIDTH-_numberLabel.frame.size.width)/2;
        rect.origin.x = SCREEN_WIDTH-_numberLabel.frame.size.width-60;
        _numberLabel.frame = rect;
    }
    
    return _numberLabel;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
