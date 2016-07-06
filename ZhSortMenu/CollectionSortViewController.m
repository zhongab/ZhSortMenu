//
//  CollectionSortViewController.m
//  ZhSortMenu
//
//  Created by zab on 16/7/4.
//  Copyright © 2016年 zab. All rights reserved.
//

#import "CollectionSortViewController.h"
#import "ZhSortCollectionView.h"
#import "MutilSelectViewController.h"


@interface CollectionSortViewController ()<ZhSortCollectionViewDataSource,ZhSortCollectionViewDelegate>
@property(nonatomic, strong) ZhSortCollectionView *sortView;

@property (nonatomic, strong) NSArray *array0;
@property (nonatomic, strong) NSArray *array1;
@property (nonatomic, strong) NSArray *array2;

@end

@implementation CollectionSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.array0 = @[@"array-0", @"array-1", @"array-2", @"array-3", @"array-4", @"array-5"];
    self.array1 = @[@"array1-0", @"array1-1", @"array1-2", @"array1-3", @"array1-4", @"array1-5"];
    self.array2 = @[@"array2-0", @"array2-1", @"array2-2", @"array2-3", @"array2-4", @"array2-5"];
    
    
    _sortView = [[ZhSortCollectionView alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    _sortView.dataSource = self;
    _sortView.delegate = self;
    
    [self.view addSubview:self.sortView];
    
    
     [_sortView selectIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] column:0];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 400, 150, 100);
    [self.view addSubview:button];
    [button setTitle:@"mutil" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor blackColor]];
    
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonAction{
    //[_menu selectIndexPath:[ZhIndexPath indexPathWithColumn:1 row:3]];
    
    MutilSelectViewController * vc = [[MutilSelectViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    return 1;
}
- (NSInteger)menu:(ZhSortCollectionView *)menu numberOfItemsInSection:(NSInteger)section inColumn:(NSInteger)column{
    return _array0.count;
}

- (NSString *)menu:(ZhSortCollectionView *)menu collectionView:(UICollectionView*)collectionView titleForItemAtIndexPath:(NSIndexPath *)indexPath inColumn:(NSInteger)column{
    return _array0[indexPath.row];
}


- (void)menu:(ZhSortCollectionView *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath column:(NSInteger)column{
    
    NSLog(@"section:%ld row:%ld column:%ld",indexPath.section,indexPath.row,column);
    
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
