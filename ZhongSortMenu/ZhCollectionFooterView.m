//
//  ZhCollectionFooterView.m
//  ZhSortMenu
//
//  Created by zab on 16/7/5.
//  Copyright © 2016年 zab. All rights reserved.
//

#import "ZhCollectionFooterView.h"

@implementation ZhCollectionFooterView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 200)/2.0, 20, 200, 40)];
        label.backgroundColor = [UIColor orangeColor];
        label.text = @"底部";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
    }
    
    return self;
    
}
@end
