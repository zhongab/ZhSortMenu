//
//  ZhSortCollectionView.h
//  ZhSortMenu
//
//  Created by zab on 16/7/5.
//  Copyright © 2016年 zab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhCollectionHeaderView.h"
#import "ZhCollectionFooterView.h"
@class ZhSortCollectionView;

static NSString *CollectionheaderIdentifier = @"header";
static NSString *CollectionfooterIdentifier = @"footer";

@protocol ZhSortCollectionViewDataSource <NSObject>

@required
- (NSInteger)numberOfColumnsInMenu:(ZhSortCollectionView *)menu;

- (NSString *)menu:(ZhSortCollectionView *)menu titleForHeaderColumn:(NSInteger)column;

@optional

- (NSInteger)menu:(ZhSortCollectionView *)menu numberOfSectionsinColumn:(NSInteger)column;
- (NSInteger)menu:(ZhSortCollectionView *)menu numberOfItemsInSection:(NSInteger)section inColumn:(NSInteger)column;
- (NSString *)menu:(ZhSortCollectionView *)menu collectionView:(UICollectionView*)collectionView titleForItemAtIndexPath:(NSIndexPath *)indexPath inColumn:(NSInteger)column;
- (ZhCollectionHeaderView *)menu:(ZhSortCollectionView *)menu collectionView:(UICollectionView *)collectionView viewHeaderInSection:(NSIndexPath *)indexPath inColumn:(NSInteger)column;
- (ZhCollectionFooterView *)menu:(ZhSortCollectionView *)menu collectionView:(UICollectionView *)collectionView  viewFooterInSection:(NSIndexPath *)indexPath inColumn:(NSInteger)column;
//header大小
- (CGSize)menu:(ZhSortCollectionView *)menu sizeInSectionHeader:(NSInteger)section inColumn:(NSInteger)column;
- (CGSize)menu:(ZhSortCollectionView *)menu sizeInSectionFooter:(NSInteger)section inColumn:(NSInteger)column;
@end

@protocol ZhSortCollectionViewDelegate <NSObject>

@optional
//点击
- (void)menu:(ZhSortCollectionView *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath column:(NSInteger)column;
- (void)menu:(ZhSortCollectionView *)menu didMutilSelectRowAtIndexPath:(NSArray *)indexPaths column:(NSInteger)column;
- (void)menu:(ZhSortCollectionView *)menu didSelectHeader:(NSInteger)column;
@end


@interface ZhSortCollectionView : UIView
@property(nonatomic,weak)id <ZhSortCollectionViewDataSource> dataSource;
@property(nonatomic,weak)id <ZhSortCollectionViewDelegate> delegate;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) NSNumber *expandHeight;

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height isMutilSelect:(BOOL)isMutilSelect;
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

- (void)selectIndexPath:(NSIndexPath *)indexPath column:(NSInteger)column;
- (void)selectIndexPaths:(NSArray *)indexPaths column:(NSInteger)column;
@end
