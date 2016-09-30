//
//  MainViewController.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/12.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "MainViewController.h"
#import "ButtonsView.h"
#import "XRCarouselView.h"
#import "SellCollectionViewCell.h"
#import "MainHeaderView2.h"
#import "ShoppingCartVC.h"
#import "SearchVC.h"

#import "PlayerView.h"
#import "MainTableViewCell.h"

#import "FirstInterfaceHeaderCell.h"
#import "NewGoodCell.h"
#import "DigitalProdectCell.h"

@interface MainViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate, UIWebViewDelegate, SwipeTableViewDelegate, SwipeTableViewDataSource>{
        
    UICollectionView *_mainCollectionView;
    
    UIButton *_sorButton;
    
    NSArray *_titleArray;
    
    UIScrollView *_headScrollView;
    
    NSMutableArray *_collectioinViews;
    
    ButtonsView *_buttonsView;
}
@end


@implementation MainViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"store"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"store_on"];
        self.tabBarItem.title = @"商店";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewTop) name:kStatusBarTap object:nil];
    
    //tableView
    [self setupUI];
    
    [self createTableView];

    //buttons
    [self createButtons];

    //检索
    [self createSorButton];

    //状态栏填充
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

- (void)setupUI {
    _swipeTableView = [[SwipeTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"MainHeaderView" owner:nil options:nil] firstObject];
    _headerView.frame = CGRectMake(0, 20, kScreenW, 44);
    _swipeTableView.swipeHeaderView = _headerView;
    
    _buttonsView = [[ButtonsView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    _buttonsView.titleArray = @[@"首页", @"每日上新", @"好货秒杀", @"包邮区", @"好店推荐", @"狗狗", @"狗狗", @"狗狗", @"狗狗", @"狗狗", @"狗狗", @"狗狗",];
    __weak typeof(_sorButton) weakSorButton = _sorButton;
    __weak typeof (self) weakSelf = self;
    __weak typeof (_swipeTableView) weakSwipeTableView = _swipeTableView;
    _buttonsView.buttonBlock = ^(NSInteger index){
        [weakSwipeTableView scrollToItemAtIndex:index animated:YES];
        if (index == 0) {
            weakSorButton.hidden = YES;
            for (int i = 0; i < 4; i++) {
                UIButton *button = (UIButton *)[weakSelf.view viewWithTag:2000 + i];
                button.hidden = YES;
            }
        }else {
            weakSorButton.hidden = NO;
            for (int i = 0; i < 4; i++) {
                UIButton *button = (UIButton *)[weakSelf.view viewWithTag:2000 + i];
                button.hidden = NO;
                button.center = weakSorButton.center;
                weakSorButton.selected = NO;
            }
        }
    };
    _swipeTableView.swipeHeaderBar = _buttonsView;
    _swipeTableView.swipeHeaderTopInset = 20.0f;
    
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    [self.view addSubview:_swipeTableView];
}
- (void)scrollViewTop {
    UIScrollView *scrollView = [self.view viewWithTag:self.headerView.buttonsView.currentIndex+1000];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)createTableView {
    
    _titleArray = @[@"", @"每日新款发售", @"特卖会", @"热门店铺", @"数码神器", @"享瘦潮流", @"明星同款",  @"好店推荐"];
    _collectioinViews = [NSMutableArray array];
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.itemSize = CGSizeMake((kScreenW - 15)/2, (kScreenW - 15)/2+40);
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-69) collectionViewLayout:mainLayout];
    _mainCollectionView.dataSource = self;
    _mainCollectionView.delegate = self;
    _mainCollectionView.tag = 1000;
    _mainCollectionView.backgroundColor = [UIColor whiteColor];
    _mainCollectionView.bounces = NO;
    [_collectioinViews addObject:_mainCollectionView];
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"SellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SellCollectionViewCell"];
    
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenW - 15)/2, (kScreenW - 15)/2+40);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    for (int i = 1; i < _buttonsView.titleArray.count; i++) {
        
        //创建
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-69) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.tag = 1000+i;
        collectionView.bounces = NO;

        [_collectioinViews addObject:collectionView];
        
        //注册
        [collectionView registerNib:[UINib nibWithNibName:@"SellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SellCollectionViewCell"];
    }
}


- (void)createButtons {

    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(8, kScreenH-45, 140, 40)];
    buttonView.backgroundColor = [UIColor grayColor];
    buttonView.layer.cornerRadius = 5;
    buttonView.layer.backgroundColor = [UIColor blackColor].CGColor;
    NSArray *imageArray = @[@"name_on", @"searchicon", @"shoppingcart2"];
    for (int i = 0; i  < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50*i, 0, 40, 40);
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [buttonView addSubview:button];
        [self.view addSubview:buttonView];
    }

}

- (void)buttonAction:(UIButton *)button {
    
    if (button.tag == 100) {
    }else if (button.tag == 102) {
        ShoppingCartVC *shoppingCartVC = [[ShoppingCartVC alloc] init];
        [self.navigationController pushViewController:shoppingCartVC animated:YES];
        
    }else {
        SearchVC *searchVC = [[SearchVC alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}

- (void)createSorButton {
    _sorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sorButton.frame = CGRectMake(kScreenW-45, kScreenH-94, 40, 40);
    _sorButton.layer.cornerRadius = 20;
    _sorButton.clipsToBounds = YES;
    _sorButton.layer.masksToBounds = YES;
    //筛选功能按钮
    for (int i = 0; i < 4; i++) {
        
        UIButton *detailSorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        detailSorBtn.frame = CGRectMake(0, 0, 36, 36);
        detailSorBtn.center = _sorButton.center;
        detailSorBtn.layer.cornerRadius = 18;
        detailSorBtn.layer.masksToBounds = YES;
        detailSorBtn.clipsToBounds = YES;
        detailSorBtn.tag = 2000 + i;
        detailSorBtn.hidden = YES;
        detailSorBtn.backgroundColor = [UIColor greenColor];
        [self.view addSubview:detailSorBtn];
    }
    
    [self.view addSubview:_sorButton];
    [_sorButton addTarget:self action:@selector(sorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _sorButton.backgroundColor = [UIColor redColor];
    [_sorButton setTitle:@"销量检索" forState:UIControlStateNormal];
    _sorButton.hidden = YES;
    _sorButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _sorButton.titleLabel.numberOfLines = 0;
    
}

- (void)sorButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = 0; i < 4; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:2000 + i];
                button.center = CGPointMake(_sorButton.center.x - 80*sin(M_PI_2/3*i), _sorButton.center.y - 80*cos(M_PI_2/3*i));
            }
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            for (int i = 0; i < 4; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:2000 + i];
                button.center = _sorButton.center;
            }
        }];
    }
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - UICollectionViewDataSource
//单元格的个数的返回
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (collectionView.tag) {
        case 1000:
            switch (section) {
                case 0:
                    return 1;
                    break;
                case 1:
                    return 2;
                    break;
                case 4:
                    return 1;
                    break;
                default:
                    return 3;
                    break;
            }
            
        default:
            
            return 12;
            break;
    }
}
//单元格的返回
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 1000) {
        
        
        if (indexPath.section == 0) {
            [collectionView registerNib:[UINib nibWithNibName:@"FirstInterfaceHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"FirstInterfaceHeaderCell"];
            FirstInterfaceHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstInterfaceHeaderCell" forIndexPath:indexPath];
            return cell;
        }else if (indexPath.section == 1) {
            [collectionView registerNib:[UINib nibWithNibName:@"NewGoodCell" bundle:nil] forCellWithReuseIdentifier:@"NewGoodCell"];
            NewGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewGoodCell" forIndexPath:indexPath];
            return cell;
        }else if (indexPath.section == 4) {
            [collectionView registerNib:[UINib nibWithNibName:@"DigitalProdectCell" bundle:nil] forCellWithReuseIdentifier:@"DigitalProdectCell"];
            DigitalProdectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DigitalProdectCell" forIndexPath:indexPath];
            return cell;
        }else {
            
            SellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SellCollectionViewCell" forIndexPath:indexPath];
            return cell;
        }
        return nil;
    } else {
        
        SellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SellCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}
//组数的返回
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    switch (collectionView.tag) {
        case 1000:
            return 8;
            break;
            
        default:
            return 1;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (collectionView.tag) {
        case 1000:
            if (indexPath.section == 0) {
                return CGSizeMake(kScreenW, kScreenH*0.65);
            } else if (indexPath.section == 1) {
                return CGSizeMake(kScreenW, kScreenW+3);
            } else if (indexPath.section == 4) {
                return CGSizeMake(kScreenW, 380);
            }
            return CGSizeMake((kScreenW - 15)/2, (kScreenW - 15)/2+40);
            break;
            
        default:
            return CGSizeMake((kScreenW - 15)/2, (kScreenW - 15)/2+40);
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (collectionView.tag) {
        case 1000:
            if (section == 0) {
                return CGSizeZero;
            }if (section == 2) {
                return CGSizeMake(0, 80);
            }
            return CGSizeMake(0, 40);
            break;
            
        default:
            
            return CGSizeZero;
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1000) {
        if (kind == UICollectionElementKindSectionHeader) {
            
            
            if (indexPath.section == 2){
                
                [collectionView registerNib:[UINib nibWithNibName:@"DiscountHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DiscountHeader"];
                
                UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DiscountHeader" forIndexPath:indexPath];
                return view;
            }else {
                [collectionView registerNib:[UINib nibWithNibName:@"MainHeaderView2" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MainHeaderView2"];
                MainHeaderView2 *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MainHeaderView2" forIndexPath:indexPath];
                headerView.titleLabel.text = _titleArray[indexPath.section];
                return headerView;
            }
        }
    }
    return nil;
}

#pragma mark - SwipeTableViewDelegate
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    
    return _buttonsView.titleArray.count;
}
- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    UICollectionView *collectionView = [_collectioinViews objectAtIndex:index];
    return collectionView;
}

- (void)swipeTableViewDidEndDecelerating:(SwipeTableView *)swipeView {
    //发送通知
    NSInteger index = swipeView.currentItemIndex;
    [[NSNotificationCenter defaultCenter] postNotificationName:kIdenxChange object:nil userInfo:@{@"index":@(index)}];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
