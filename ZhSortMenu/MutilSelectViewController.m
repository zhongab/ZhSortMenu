//
//  MutilSelectViewController.m
//  ZhSortMenu
//
//  Created by zab on 16/7/5.
//  Copyright © 2016年 zab. All rights reserved.
//

#import "MutilSelectViewController.h"
#import "ZhSortCollectionView.h"
@interface MutilSelectViewController ()<ZhSortCollectionViewDataSource,ZhSortCollectionViewDelegate>
@property(nonatomic, strong) ZhSortCollectionView *sortView;

@property (nonatomic, strong) NSArray *array0;
@property (nonatomic, strong) NSArray *array1;
@property (nonatomic, strong) NSArray *array2;
@end

@implementation MutilSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.array0 = @[@"array-0", @"array-1", @"array-2", @"array-3", @"array-4", @"array-5"];
    self.array1 = @[@"array1-0", @"array1-1", @"array1-2", @"array1-3", @"array1-4", @"array1-5"];
    self.array2 = @[@"array2-0", @"array2-1", @"array2-2", @"array2-3", @"array2-4", @"array2-5"];
    
    
    _sortView = [[ZhSortCollectionView alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44 isMutilSelect:YES];
    _sortView.dataSource = self;
    _sortView.delegate = self;
    [self.view addSubview:self.sortView];
    
    //默认选中item
    [_sortView selectIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0],[NSIndexPath indexPathForItem:2 inSection:0]] column:0];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark GJSortMenuViewDataSource

- (NSInteger)numberOfColumnsInMenu:(ZhSortCollectionView *)menu{
    return 3;
}

- (NSString *)menu:(ZhSortCollectionView *)menu titleForHeaderColumn:(NSInteger)column{
    if (column == 0) {
        return @"风格";
    } else if (column == 1) {
        return @"类型";
    } else if (column == 2) {
        return @"离我最近";
    }
    return @"";
}
- (NSInteger)menu:(ZhSortCollectionView *)menu numberOfSectionsinColumn:(NSInteger)column{
    return 2;
}
- (NSInteger)menu:(ZhSortCollectionView *)menu numberOfItemsInSection:(NSInteger)section inColumn:(NSInteger)column{
    if (column == 0) {
        return _array0.count;
    }
    if (column == 1) {
        return _array1.count;
    }
    if (column == 2) {
        return _array2.count;
    }
    return 0;
}

- (NSString *)menu:(ZhSortCollectionView *)menu collectionView:(UICollectionView*)collectionView titleForItemAtIndexPath:(NSIndexPath *)indexPath inColumn:(NSInteger)column{
    if (column == 0) {
        return _array0[indexPath.row];
    }
    if (column == 1) {
        return _array1[indexPath.row];
    }
    if (column == 2) {
        return _array2[indexPath.row];
    }
    return @"";
}
- (ZhCollectionHeaderView *)menu:(ZhSortCollectionView *)menu collectionView:(UICollectionView *)collectionView viewHeaderInSection:(NSIndexPath *)indexPath inColumn:(NSInteger)column{
    
     ZhCollectionHeaderView*headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionheaderIdentifier forIndexPath:indexPath];
    
    //这里提供默认的header样式  如果需要自定义 ，可以自己创建UIView  加到 headerView里
    
//    if (column == 0) {
//        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
//        view.backgroundColor = [UIColor blueColor];
//        [headerView addSubview:view];
//       
//        return headerView;
//    }
    
    headerView.labelTitle.text = [NSString stringWithFormat:@"section%ld in column%ld",indexPath.section,column];
    
    return headerView;
    
}

- (ZhCollectionFooterView *)menu:(ZhSortCollectionView *)menu collectionView:(UICollectionView *)collectionView  viewFooterInSection:(NSIndexPath *)indexPath inColumn:(NSInteger)column{
     ZhCollectionFooterView*footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CollectionfooterIdentifier forIndexPath:indexPath];
    return footerView;
}

//header大小
- (CGSize)menu:(ZhSortCollectionView *)menu sizeInSectionHeader:(NSInteger)section inColumn:(NSInteger)column{
    return CGSizeMake(200, 40);
}
- (CGSize)menu:(ZhSortCollectionView *)menu sizeInSectionFooter:(NSInteger)section inColumn:(NSInteger)column{
     return CGSizeMake(200, 80);
}
- (void)menu:(ZhSortCollectionView *)menu didMutilSelectRowAtIndexPath:(NSArray *)indexPaths column:(NSInteger)column{
    
    for (NSIndexPath * indexPath in indexPaths) {
        
        NSLog(@"section:%ld row:%ld column:%ld",indexPath.section,indexPath.row,column);
        
    }
    
}
- (void)menu:(ZhSortCollectionView *)menu didSelectHeader:(NSInteger)column{
    
    if (column == 1) {
        _sortView.expandHeight = @(400);
    }
    if (column == 2) {
        _sortView.expandHeight = @(200);
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
