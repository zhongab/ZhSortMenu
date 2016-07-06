//
//  ZhCollectionHeaderView.m
//  ZhSortMenu
//
//  Created by zab on 16/7/5.
//  Copyright © 2016年 zab. All rights reserved.
//

#import "ZhCollectionHeaderView.h"

@implementation ZhCollectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height)];
        _labelTitle.font = [UIFont systemFontOfSize:14.0];
        _labelTitle.textColor = [UIColor blackColor];
        
        [self addSubview:_labelTitle];
        
    }
    
    return self;
    
}
@end
