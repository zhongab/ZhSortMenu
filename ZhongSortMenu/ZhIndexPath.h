//
//  ZhIndexPath.h
//  ZhSortMenu
//
//  Created by zab on 16/7/4.
//  Copyright © 2016年 zab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhIndexPath : NSObject
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger item;


- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row item:(NSInteger)item;
+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row;
+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row item:(NSInteger)item;
@end
