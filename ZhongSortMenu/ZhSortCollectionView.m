//
//  ZhSortCollectionView.m
//  ZhSortMenu
//
//  Created by zab on 16/7/5.
//  Copyright © 2016年 zab. All rights reserved.
//

#import "ZhSortCollectionView.h"
#import "ZhCollectionViewCell.h"
#import "ZhCollectionHeaderView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#define kSeparatorColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define kTextSelectColor [UIColor colorWithRed:246/255.0 green:79/255.0 blue:0/255.0 alpha:1]

#define kItemHeight 32

typedef void(^complete)();
static NSString *CellIdentifier = @"cell";


@interface ZhSortCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    struct {
        unsigned int numberOfRowsInColumn :1;
        unsigned int titleForHeader :1;
        unsigned int numberOfSectionsinColumn :1;
        unsigned int numberOfItemsInSection :1;
        unsigned int titleForItemAtIndexPath :1;
        unsigned int viewHeaderInSection :1;
        unsigned int sizeInSectionHeader :1;
        unsigned int viewFooterInSection :1;
        unsigned int sizeInSectionFooter :1;
    }_dataSourceFlag;
    
}
@property (nonatomic, assign) CGPoint origin;  //原点
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isSelectMutiItem;
@property (nonatomic, assign) NSInteger currentSelectedColumn;  //当前选中列
@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic, strong) UICollectionView *collectionView;  //一级列表
@property (nonatomic, strong) UIView *bottomLine;  //底部的线条
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) NSInteger numberOfColumn;  //列数

@property (nonatomic, strong) NSMutableDictionary *itemSelectDict;

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;
@end

@implementation ZhSortCollectionView
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height isMutilSelect:(BOOL)isMutilSelect{
    _isSelectMutiItem = isMutilSelect;
    
    return [self initWithOrigin:origin andHeight:height];
}

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height{
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, SCREEN_WIDTH, height)];
    if (self) {
        _origin = origin;
        _height = height;

        _currentSelectedColumn = 0;

        _textColor = kTextColor;
         _separatorColor = kSeparatorColor;
        _selectedTextColor = kTextSelectColor;
        _fontSize = 14;
        _expandHeight = @(200.0);
        
        
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, origin.y + self.frame.size.height,SCREEN_WIDTH, 0)  collectionViewLayout:flowLayout];
        
        self.collectionView.backgroundColor=[UIColor whiteColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZhCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        
        [_collectionView registerClass:[ZhCollectionHeaderView class]
         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionheaderIdentifier];
        [_collectionView registerClass:[ZhCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CollectionfooterIdentifier];
        
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tap];
        
        _backGroundView = [[UIView alloc] init];
        _backGroundView.frame = CGRectMake(origin.x, origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapped:)];
        [_backGroundView addGestureRecognizer:backTap];
        
        //底部线条
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, SCREEN_WIDTH, 0.5)];
        _bottomLine.backgroundColor = kSeparatorColor;
        _bottomLine.hidden = YES;
        [self addSubview:_bottomLine];
        
    }
    return self;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}
- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = [UIColor blackColor];
    }
    return _separatorColor;
}
- (NSNumber *)expandHeight {
    if (!_expandHeight) {
        _expandHeight = @(200);
    }
    return _expandHeight;
}


#pragma mark  设置datasource

- (void)setDataSource:(id<ZhSortCollectionViewDataSource>)dataSource{
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numberOfColumn = [_dataSource numberOfColumnsInMenu:self];
    }else{
        _numberOfColumn = 1;
    }
    
    _itemSelectDict = [[NSMutableDictionary alloc] initWithCapacity:_numberOfColumn];
    for (int i=0; i<_numberOfColumn; i++) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //[dict setObject:[NSIndexPath indexPathForItem:0 inSection:0] forKey:[self sectionKey:0]];
        [_itemSelectDict setObject:dict forKey:[self columnKey:i]];
    }
    
    
//    //判断是否响应了某方法
    _dataSourceFlag.titleForHeader = [_dataSource respondsToSelector:@selector(menu:titleForHeaderColumn:)];
    _dataSourceFlag.numberOfSectionsinColumn = [_dataSource respondsToSelector:@selector(menu:numberOfSectionsinColumn:)];
    _dataSourceFlag.numberOfItemsInSection = [_dataSource respondsToSelector:@selector(menu:numberOfItemsInSection:inColumn:)];
    _dataSourceFlag.titleForItemAtIndexPath = [_dataSource respondsToSelector:@selector(menu:collectionView:titleForItemAtIndexPath:inColumn:)];
    _dataSourceFlag.viewHeaderInSection = [_dataSource respondsToSelector:@selector(menu:collectionView:viewHeaderInSection:inColumn:)];
    _dataSourceFlag.sizeInSectionHeader = [_dataSource respondsToSelector:@selector(menu:sizeInSectionHeader:inColumn:)];
    _dataSourceFlag.viewFooterInSection = [_dataSource respondsToSelector:@selector(menu:collectionView:viewFooterInSection:inColumn:)];
    _dataSourceFlag.sizeInSectionFooter = [_dataSource respondsToSelector:@selector(menu:sizeInSectionFooter:inColumn:)];
 
    
    CGFloat numberOfLine = SCREEN_WIDTH / self.numberOfColumn;
    CGFloat numberOfBackground = SCREEN_WIDTH / self.numberOfColumn;
    CGFloat numberOfTextLayer = SCREEN_WIDTH / (self.numberOfColumn * 2);
    
    //底部的line显示
    _bottomLine.hidden = NO;
    
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numberOfColumn];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numberOfColumn];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numberOfColumn];
    
    //画出菜单
    for (int i = 0; i < _numberOfColumn; i++) {
        //backgrounLayer
        CGPoint positionForBackgroundLayer = CGPointMake((i + 0.5) * numberOfBackground, self.height / 2);
        CALayer *bgLayer = [self createBackgroundLayerWithPosition:positionForBackgroundLayer color:[UIColor whiteColor]];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        
        //titleLayer
        NSString *titleString = nil;
        if (_dataSourceFlag.titleForHeader) {
            titleString = [_dataSource menu:self titleForHeaderColumn:i];
        }
        CGPoint positionForTitle = CGPointMake(( i * 2 + 1) * numberOfTextLayer, self.height / 2);
        CATextLayer *textLayer = [self createTitleLayerWithString:titleString position:positionForTitle color:self.textColor];
        [self.layer addSublayer:textLayer];
        [tempTitles addObject:textLayer];
        
        //indicatorLayer
        CGPoint indicatorPosition = CGPointMake((i + 1) * numberOfLine - 10, self.height / 2);
        CAShapeLayer *sharpLayer = [self createIndicatorWithPosition:indicatorPosition color:[UIColor blackColor]];
        [self.layer addSublayer:sharpLayer];
        [tempIndicators addObject:sharpLayer];
        
        //separatorLayer
        if (i != self.numberOfColumn - 1) {
            CGPoint separatorPosition = CGPointMake(ceilf((i + 1) * numberOfLine - 1), self.height / 2);
            CAShapeLayer *separatorLayer = [self createSeparatorWithPosition:separatorPosition color:self.separatorColor];
            [self.layer addSublayer:separatorLayer];
        }
    }
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
    
    
    if (_dataSourceFlag.viewHeaderInSection) {
        
    }
}
//背景
- (CALayer *)createBackgroundLayerWithPosition:(CGPoint)position color:(UIColor *)color {
    CALayer *layer = [CALayer layer];
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, SCREEN_WIDTH / self.numberOfColumn, self.height - 1);
    layer.backgroundColor = color.CGColor;
    return layer;
}
//标题
- (CATextLayer *)createTitleLayerWithString:(NSString *)string position:(CGPoint)position color:(UIColor *)color {
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numberOfColumn) - 25) ? size.width : self.frame.size.width / _numberOfColumn - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = _fontSize;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.truncationMode = kCATruncationEnd;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = position;
    
    return layer;
}
//计算String的宽度
- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    //CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:_fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return CGSizeMake(ceilf(size.width)+2, size.height);
}
//指示器
- (CAShapeLayer *)createIndicatorWithPosition:(CGPoint)position color:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.8;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = position;
    
    return layer;
}
//分隔线
- (CAShapeLayer *)createSeparatorWithPosition:(CGPoint)position color:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 20)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = position;
    return layer;
}

#pragma mark - 动画
- (void)animateIndicator:(CAShapeLayer *)indicator reverse:(BOOL)reverse complete:(complete)complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = reverse ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    if (reverse) {
        indicator.fillColor = self.selectedTextColor.CGColor;
    }else {
        indicator.fillColor = self.textColor.CGColor;
    }
    complete();
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(complete)complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            if (finished) {
                [view removeFromSuperview];
            }
        }];
    }
    complete();
}
- (void)animateCollectionView:(UICollectionView *)collectionview show:(BOOL)show complete:(complete)complete
{
    if (show) {
        _collectionView.frame = CGRectMake(self.origin.x, self.origin.y + self.height, SCREEN_WIDTH, 0);
        [self.superview addSubview:_collectionView];
        CGFloat collectionViewHeight = _expandHeight.floatValue;
        [UIView animateWithDuration:0.2 animations:^{
           
            _collectionView.frame = CGRectMake(self.origin.x, self.origin.y + self.height, SCREEN_WIDTH, collectionViewHeight);
            
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            
            _collectionView.frame = CGRectMake(self.origin.x, self.origin.y + self.height, SCREEN_WIDTH, 0);
            
        } completion:^(BOOL finished) {
            
            [_collectionView removeFromSuperview];
        }];
    }
    
    complete();
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(complete)complete {
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numberOfColumn) - 25) ? size.width : self.frame.size.width / _numberOfColumn - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    if (!show) {
        title.foregroundColor = _textColor.CGColor;
    } else {
        title.foregroundColor = _selectedTextColor.CGColor;
    }
    complete();
}

- (void)animateIndicator:(CAShapeLayer *)indicator background:(UIView *)background collectionView:(UICollectionView *)collectionview title:(CATextLayer *)title reverse:(BOOL)reverse complecte:(void(^)())complete {
    [self animateIndicator:indicator reverse:reverse complete:^{
        [self animateTitle:title show:reverse complete:^{
            [self animateBackGroundView:background show:reverse complete:^{
                [self animateCollectionView:collectionview show:reverse complete:^{
                    
                }];
            }];
        }];
    }];
    complete();
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(_dataSourceFlag.numberOfSectionsinColumn){
        return [_dataSource menu:self numberOfSectionsinColumn:_currentSelectedColumn];
    }
    return 1;
}
// 返回在一个给定section里的cell数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_dataSourceFlag.numberOfItemsInSection) {
        return [self.dataSource menu:self numberOfItemsInSection:section inColumn:_currentSelectedColumn];
    } else {
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ZhCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *title=[self.dataSource menu:self collectionView:collectionView titleForItemAtIndexPath:indexPath inColumn:_currentSelectedColumn];
    cell.button.indexPath = indexPath;
    cell.button.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
    [cell.button setTitle:title forState:UIControlStateNormal];

    
    NSDictionary *dict = [_itemSelectDict objectForKey:[self columnKey:_currentSelectedColumn]];
    
    NSString *sectionKey = [self sectionKey:indexPath.section row:indexPath.row];
    
    if ([[dict allKeys] containsObject:sectionKey]) {
        NSIndexPath *selected_indexPath = [dict objectForKey:sectionKey];
        
        if (selected_indexPath.row == indexPath.row ) {
            [cell setSelected:YES];
        }
        
    }else{
        [cell setSelected:NO];
    }
    
    
    [cell.button addTarget:self action:@selector(itemdidSelected:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (_dataSourceFlag.viewHeaderInSection) {
            return  [_dataSource menu:self collectionView:_collectionView viewHeaderInSection:indexPath inColumn:_currentSelectedColumn];
        }
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if (_dataSourceFlag.viewFooterInSection) {
            BOOL isShowFooter = NO;
            if (_dataSourceFlag.numberOfSectionsinColumn) {
                
                
                NSInteger count = [_dataSource menu:self numberOfSectionsinColumn:_currentSelectedColumn];
                if (indexPath.section == count - 1) {
                    isShowFooter = YES;
                }
                
            }else{
                isShowFooter = YES;
            }
           
            if (isShowFooter) {
                ZhCollectionFooterView *footerView = [_dataSource menu:self collectionView:_collectionView viewFooterInSection:indexPath inColumn:_currentSelectedColumn];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerViewTap:)];
                [footerView addGestureRecognizer:tap];
                return footerView;
            }
            
           
        }
    }
    
    return nil;
    
   
}


-(void)itemdidSelected:(ZhButton *)button{
    
    if (_isSelectMutiItem) {
        NSMutableDictionary *dict = [_itemSelectDict objectForKey:[self columnKey:_currentSelectedColumn]];
        NSString *itemKey = [self sectionKey:button.indexPath.section row:button.indexPath.row];
        
        
        
        if ([[dict allKeys] containsObject:itemKey]) {
            [dict removeObjectForKey:itemKey];

            [self setItemNormalStyle:button.indexPath];
            
        }else{
            [dict setObject:button.indexPath forKey:itemKey];
            
            [self setItemSelectedStyle:button.indexPath];
        }
        [_itemSelectDict setObject:dict forKey:[self columnKey:_currentSelectedColumn]];
        
    }else{
        NSMutableDictionary *dict = [_itemSelectDict objectForKey:[self columnKey:_currentSelectedColumn]];
        [dict removeAllObjects];
        [dict setObject:button.indexPath forKey:[self sectionKey:button.indexPath.section row:button.indexPath.row]];
        [_itemSelectDict setObject:dict forKey:[self columnKey:_currentSelectedColumn]];
        [self setMenuWithSelectedItem:button.indexPath];
        if (_delegate && [_delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:column:)]) {
            [_delegate menu:self didSelectRowAtIndexPath:button.indexPath column:_currentSelectedColumn];
        }
    }
}

#pragma mark 底部视图点击
- (void)footerViewTap:(UITapGestureRecognizer *)gesture{
    NSMutableDictionary *dict = [_itemSelectDict objectForKey:[self columnKey:_currentSelectedColumn]];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (NSString *key in dict.allKeys ) {
        NSIndexPath *indexPath = [dict objectForKey:key];
        
        [indexPaths addObject:indexPath];
    }
    
    [self animateIndicator:_indicators[_currentSelectedColumn] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedColumn] reverse:NO complecte:^{
        _isShow = NO;
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(menu:didMutilSelectRowAtIndexPath:column:)]) {
        [_delegate menu:self didMutilSelectRowAtIndexPath:indexPaths column:_currentSelectedColumn];
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout
//距离左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.frame.size.width-15*4)/3.0, 32);
}
// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (_dataSourceFlag.sizeInSectionFooter) {
        BOOL isShowFooter = NO;
        if (_dataSourceFlag.numberOfSectionsinColumn) {
            NSInteger count = [_dataSource menu:self numberOfSectionsinColumn:_currentSelectedColumn];
            if (section == count - 1) {
                isShowFooter = YES;
            }
            
        }else{
            isShowFooter = YES;
        }
        
        if (isShowFooter) {
            CGSize size = [_dataSource menu:self sizeInSectionFooter:section inColumn:_currentSelectedColumn];
            return CGSizeMake(SCREEN_WIDTH, size.height);
 
        }
    }
    
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (_dataSourceFlag.sizeInSectionHeader) {
        CGSize size = [_dataSource menu:self sizeInSectionHeader:section inColumn:_currentSelectedColumn];
        return CGSizeMake(SCREEN_WIDTH, size.height);
    }
    return CGSizeZero;
    
}

- (void)setItemSelectedStyle:(NSIndexPath *)indexPath{
    ZhCollectionViewCell *cell = (ZhCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:YES];
}
- (void)setItemNormalStyle:(NSIndexPath *)indexPath{
    ZhCollectionViewCell *cell = (ZhCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:NO];
}
- (void)setMenuWithSelectedItem:(NSIndexPath *)indexPath {
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedColumn];
    title.string = [_dataSource menu:self collectionView:_collectionView titleForItemAtIndexPath:indexPath inColumn:_currentSelectedColumn];
    
    [self animateIndicator:_indicators[_currentSelectedColumn] background:_backGroundView collectionView:_collectionView title:title reverse:NO complecte:^{
        _isShow = NO;
    }];
}
- (NSString *)columnKey:(NSInteger)column{
    return [NSString stringWithFormat:@"column-%ld",column];
}
- (NSString *)sectionKey:(NSInteger)section row:(NSInteger)row{
     return [NSString stringWithFormat:@"section-%ld-row-%ld",section,row];
}

- (void)menuTapped:(UITapGestureRecognizer *)gesture {
    if (_dataSource == nil) {
        return;
    }
   
    //触摸的地方的index
    CGPoint touchPoint = [gesture locationInView:self];
    NSInteger touchIndex = touchPoint.x / (SCREEN_WIDTH / self.numberOfColumn);
    
    if ([_delegate respondsToSelector:@selector(menu:didSelectHeader:)]) {
        [_delegate menu:self didSelectHeader:touchIndex];
    }
    
    
    
    //将当前点击的column之外的column给收回
    for (int i=0; i<_numberOfColumn; i++) {
        if (i != touchIndex) {
            [self animateIndicator:_indicators[i] reverse:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                    
                }];
            }];
        }
    }
    
    if (touchIndex == _currentSelectedColumn && _isShow) {
        //收回menu
        [self animateIndicator:_indicators[touchIndex] background:_backGroundView collectionView:_collectionView title:_titles[touchIndex] reverse:NO complecte:^{
            _currentSelectedColumn = touchIndex;
            _isShow = NO;
        }];
        
    }else {
        //弹出menu
        _currentSelectedColumn = touchIndex;
        [_collectionView reloadData];
        [self animateIndicator:_indicators[touchIndex] background:_backGroundView collectionView:_collectionView title:_titles[touchIndex] reverse:YES complecte:^{
            _isShow = YES;
        }];
    }
    
}
- (void)backTapped:(UITapGestureRecognizer *)gesture {
    [self animateIndicator:_indicators[_currentSelectedColumn] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedColumn] reverse:NO complecte:^{
        _isShow = NO;
    }];
    
}

//菜单切换
- (void)selectIndexPath:(NSIndexPath *)indexPath column:(NSInteger)column {
    if (!_dataSource) {
        return;
    }
    if ([_dataSource numberOfColumnsInMenu:self] <= column || [_dataSource menu:self numberOfSectionsinColumn:column] <= indexPath.section || [_dataSource menu:self numberOfItemsInSection:indexPath.section inColumn:column] <= indexPath.row) {
        return;
    }
    
    NSString *columnKey = [self columnKey:column];
    NSString *itemKey = [self sectionKey:indexPath.section row:indexPath.row];
    NSMutableDictionary *dict = [_itemSelectDict objectForKey:columnKey];
    [dict setObject:indexPath forKey:itemKey];
    
}
- (void)selectIndexPaths:(NSArray *)indexPaths column:(NSInteger)column{
    if (_isSelectMutiItem) {
        
        for (NSIndexPath *indexPath in indexPaths) {
            [self selectIndexPath:indexPath column:column];
        }
    }
}
@end
