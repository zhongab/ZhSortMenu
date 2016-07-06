//
//  GJSortCollectionViewCell.m
//  GJPersonal
//
//  Created by zab on 15/6/30.
//  Copyright (c) 2015年 xinyi. All rights reserved.
//

#import "ZhCollectionViewCell.h"

@implementation ZhButton



@end

@implementation ZhCollectionViewCell




-(void)setupButton{
    self.button = [ZhButton buttonWithType:UIButtonTypeCustom];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_button];
    
    [self.contentView addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.button
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.contentView
                              attribute:NSLayoutAttributeLeading
                              multiplier:1
                              constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.button
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeTrailing
                                     multiplier:1
                                     constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.button
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.button
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                     constant:0]];
    
    
    //_button.layer.cornerRadius = 4.0;
    //_button.layer.masksToBounds = YES;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [_button setBackgroundColor:[UIColor redColor]];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [_button setBackgroundColor:[UIColor grayColor]];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
@end
