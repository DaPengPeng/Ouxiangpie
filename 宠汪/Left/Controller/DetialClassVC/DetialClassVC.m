//
//  DetialClassVC.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/20.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "DetialClassVC.h"
#import "SellCollectionViewCell.h"
#import "DetailClassHeaderView.h"

@interface DetialClassVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    UICollectionView *_collerctionView;
}

@end

@implementation DetialClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //collectionView
    [self createCollectionView];
    
    
}

- (void)createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenW - 15)/2, (kScreenW - 15)/2+35);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.headerReferenceSize = CGSizeMake(0, 40);
    
    _collerctionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) collectionViewLayout:layout];
    _collerctionView.delegate = self;
    _collerctionView.dataSource = self;
    _collerctionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collerctionView];
    
    [_collerctionView registerNib:[UINib nibWithNibName:@"DetailClassHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DetailClassHeaderView"];
    [_collerctionView registerNib:[UINib nibWithNibName:@"SellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SellCollectionViewCell"];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SellCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    DetailClassHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DetailClassHeaderView" forIndexPath:indexPath];
    
    return headerView;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"mask_navbar"] forBarMetrics:UIBarMetricsDefault];
}
@end
