//
//  JHButtonMenuView.m
//  zsxc
//
//  Created by hyjt on 2017/8/7.
//  Copyright © 2017年 haoyungroup. All rights reserved.
//

#import "JHButtonMenuView.h"

const static CGFloat space = 5;

@implementation JHButtonMenuView

-(id)initWithFrame:(CGRect)frame withData:(NSArray *)data;
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = space; //列间距
    flowLayout.minimumLineSpacing = space;      //行间距
    flowLayout.sectionInset = UIEdgeInsetsMake(space, space, 0, space);
    flowLayout.itemSize = CGSizeMake((JHSCREENWIDTH-space*4)/3, (JHSCREENWIDTH-space*4)/3);
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.menuData = data?data:[self _creatData];
        //隐藏滑块
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //设置代理
        self.delegate = self;
        self.dataSource = self;
        //设置背景颜色（默认黑色）
        self.backgroundColor = [UIColor clearColor];
        //注册单元格
        [self registerClass:[JHButtonMenuCell class] forCellWithReuseIdentifier:@"JHButtonMenuCell"];
    }
    return self;
}

/**
 创建默认数据
 */
-(NSArray *)_creatData{
    NSArray *titles = @[@"汽车金融",@"保险",@"消息",@"待办事项",@"战报",@"服务"];
    NSArray *imageNames = @[@"home_icon_financial",@"home_icon_Insurance",@"消息icon",@"待办icon",@"战报icon",@"服务icon"];
    NSArray *numbers = @[@"0",@"0",@"99",@"0",@"44",@""];
    NSArray *classNames = @[@"",@"",@"",@"",@"",@""];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (int i = 0; i<titles.count; i++) {
        JHButtonMenuModel *model = [[JHButtonMenuModel alloc] init];
        model.title = titles[i];
        model.imageName = imageNames[i];
        model.number = numbers[i];
        model.className = classNames[i];
        [data addObject:model];
    }
    return data;
}

//创建cell

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *identify = @"JHButtonMenuCell";
    //在这里注册自定义的XIBcell否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:identify bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:identify];
    JHButtonMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify  forIndexPath:indexPath];
    //传递数据
    cell.model = self.menuData[indexPath.item];
    return cell;
    
}
-(NSInteger)numberOfSections{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.menuData.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JHButtonMenuModel *model = self.menuData[indexPath.item];
    NSLog(@"%@",model.title);
    
}
@end
