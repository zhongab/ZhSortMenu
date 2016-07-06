//
//  ZhSortMenuView.h
//  ZhSortMenu
//
//  Created by zab on 16/7/4.
//  Copyright © 2016年 zab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhIndexPath.h"


@class ZhSortMenuView;
@protocol ZhSortMenuDataSource <NSObject>
@required
//每个column有多少行
- (NSInteger)menu:(ZhSortMenuView *)menu numberOfRowsInColumn:(NSInteger)column;
//每个column中每行的title
- (NSString *)menu:(ZhSortMenuView *)menu titleForRowAtIndexPath:(ZhIndexPath *)indexPath;

@optional

- (NSInteger)numberOfColumnsInMenu:(ZhSortMenuView *)menu;
//某列的某行item的数量，如果有，则说明有二级菜单，反之亦然
- (NSInteger)menu:(ZhSortMenuView *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column;
//第column列，没行的image
- (NSString *)menu:(ZhSortMenuView *)menu imageNameForRowAtIndexPath:(ZhIndexPath *)indexPath;
//detail text
- (NSString *)menu:(ZhSortMenuView *)menu detailTextForRowAtIndexPath:(ZhIndexPath *)indexPath;
//如果有二级菜单，则实现下列协议
//二级菜单的标题
- (NSString *)menu:(ZhSortMenuView *)menu titleForItemsInRowAtIndexPath:(ZhIndexPath *)indexPath;
//二级菜单的image
- (NSString *)menu:(ZhSortMenuView *)menu imageForItemsInRowAtIndexPath:(ZhIndexPath *)indexPath;
//二级菜单的detail text
- (NSString *)menu:(ZhSortMenuView *)menu detailTextForItemsInRowAtIndexPath:(ZhIndexPath *)indexPath;
@end

#pragma mark - delegate
@protocol ZhSortMenuDelegate <NSObject>

@optional
//点击
- (void)menu:(ZhSortMenuView *)menu didSelectRowAtIndexPath:(ZhIndexPath *)indexPath;

@end


@interface ZhSortMenuView : UIView

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *detailTextColor;
@property (nonatomic, strong) UIFont *detailTextFont;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, assign) BOOL isShowCellArrow;

@property(nonatomic,weak) id<ZhSortMenuDataSource> dataSource;
@property(nonatomic,weak) id<ZhSortMenuDelegate> delegate;

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height leftWidth:(CGFloat)leftWidth;
- (void)selectDeafultIndexPath;
- (void)selectIndexPath:(ZhIndexPath *)indexPath;
@end
