//
//  ViewController.m
//  ZhSortMenu
//
//  Created by zab on 16/7/4.
//  Copyright © 2016年 zab. All rights reserved.
//

#import "ViewController.h"
#import "ZhSortMenuView.h"
#import "CollectionSortViewController.h"

@interface ViewController ()<ZhSortMenuDataSource,ZhSortMenuDelegate>
@property (nonatomic, strong)ZhSortMenuView *menu;

@property (nonatomic, strong) NSArray *array0;
@property (nonatomic, strong) NSArray *array1;
@property (nonatomic, strong) NSArray *array2;
@property (nonatomic, strong) NSArray *array3;
@property (nonatomic, strong) NSArray *array4;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    self.array0 = @[@"array-0", @"array-1", @"array-2", @"array-3", @"array-4", @"array-5"];
    self.array1 = @[@"array1-0", @"array1-1", @"array1-2", @"array1-3", @"array1-4", @"array1-5"];
    self.array2 = @[@"array2-0", @"array2-1", @"array2-2", @"array2-3", @"array2-4", @"array2-5"];
    self.array3 = @[@"array3-0", @"array3-1", @"array3-2", @"array3-3", @"array3-4", @"array3-5"];
   self.array4 = @[@"array4-0", @"array4-1", @"array4-2", @"array4-3", @"array4-4", @"array4-5"];
    
    _menu = [[ZhSortMenuView alloc] initWithOrigin:CGPointMake(0, 20) andHeight:44 leftWidth:150];
    _menu.delegate = self;
    _menu.dataSource = self;

    [self.view addSubview:_menu];
    
    _menu.selectedTextColor = [UIColor redColor];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 400, 150, 100);
    [self.view addSubview:button];
    [button setTitle:@"CollectionViewSort" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor blackColor]];
    
    
    

    
}

- (void)buttonAction{
   //[_menu selectIndexPath:[ZhIndexPath indexPathWithColumn:1 row:3]];
    
    CollectionSortViewController * vc = [[CollectionSortViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (NSInteger)numberOfColumnsInMenu:(ZhSortMenuView *)menu {
    return 3;
}
- (NSInteger)menu:(ZhSortMenuView *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.array0.count;
    }else if(column == 1) {
        return self.array1.count;
    }else {
        return self.array2.count;
    }
}
- (NSString *)menu:(ZhSortMenuView *)menu titleForRowAtIndexPath:(ZhIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return self.array0[indexPath.row];
    }else if(indexPath.column == 1) {
        return self.array1[indexPath.row];
    }else {
        return self.array2[indexPath.row];
    }
}
//- (NSString *)menu:(ZhSortMenuView *)menu imageNameForRowAtIndexPath:(ZhIndexPath *)indexPath {
//    if (indexPath.column == 0 || indexPath.column == 1) {
//        return @"我收藏的商品";
//    }
//    return nil;
//}
//- (NSString *)menu:(ZhSortMenuView *)menu detailTextForRowAtIndexPath:(ZhIndexPath *)indexPath {
//   
//    return [@(arc4random()%1000) stringValue];
//    
//}
//

- (NSInteger)menu:(ZhSortMenuView *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    if (column == 0) {
        return self.array3.count;
    }
    if (column == 1) {
        return self.array4.count;
    }
    return 0;
}
- (NSString *)menu:(ZhSortMenuView *)menu titleForItemsInRowAtIndexPath:(ZhIndexPath *)indexPath {
    //NSInteger row = indexPath.row;
    if (indexPath.column == 0) {
        return self.array3[indexPath.item];
    }
    if (indexPath.column == 1) {
        return self.array4[indexPath.item];
    }
    return nil;
}
//- (NSString *)menu:(ZhSortMenuView *)menu imageForItemsInRowAtIndexPath:(ZhIndexPath *)indexPath {
//    if (indexPath.column == 0 && indexPath.item >= 0) {
//        return @"我收藏的商品";
//    }
//    return nil;
//}
//- (NSString *)menu:(ZhSortMenuView *)menu detailTextForItemsInRowAtIndexPath:(ZhIndexPath *)indexPath {
//    return [@(arc4random()%1000) stringValue];
//}


- (void)menu:(ZhSortMenuView *)menu didSelectRowAtIndexPath:(ZhIndexPath *)indexPath {
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
