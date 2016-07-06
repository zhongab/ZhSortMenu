//
//  ZhIndexPath.m
//  ZhSortMenu
//
//  Created by zab on 16/7/4.
//  Copyright © 2016年 zab. All rights reserved.
//

#import "ZhIndexPath.h"

@implementation ZhIndexPath
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row {
    if (self = [super init]) {
        _column = column;
        _row = row;
        _item = -1;
    }
    return self;
}

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row item:(NSInteger)item {
    self = [self initWithColumn:column row:row];
    if (self) {
        _item = item;
    }
    return self;
}

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row {
    ZhIndexPath *path = [[self alloc] initWithColumn:column row:row];
    return path;
}

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row item:(NSInteger)item {
    return [[self alloc] initWithColumn:column row:row item:item];
}
@end
