//
//  GJSortCollectionViewCell.h
//  GJPersonal
//
//  Created by zab on 15/6/30.
//  Copyright (c) 2015年 xinyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZhButton : UIButton
@property(nonatomic,strong)NSIndexPath *indexPath;
@end

@interface ZhCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)ZhButton *button;
@end
