//
//  KKAlbumImageShowCollectionBar.m
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImageShowCollectionBar.h"
#import "KKMediaPickerDefine.h"

@interface KKAlbumImageShowCollectionBar ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UICollectionView *mainCollectionView;
@property (nonatomic , strong) KKAlbumAssetModel *selectModel;

@end


@implementation KKAlbumImageShowCollectionBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.75;
        backgroundView.userInteractionEnabled = YES;
        [self addSubview:backgroundView];

        //主图片
        CGRect collectionViewFrame= CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.mainCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
        self.mainCollectionView.showsVerticalScrollIndicator = NO;
        self.mainCollectionView.showsHorizontalScrollIndicator = NO;
        self.mainCollectionView.backgroundColor = [UIColor clearColor];
        self.mainCollectionView.dataSource = self;
        self.mainCollectionView.delegate = self;
        self.mainCollectionView.bounces = YES;
        self.mainCollectionView.alwaysBounceHorizontal = YES;
        self.mainCollectionView.alwaysBounceVertical = NO;
        [self.mainCollectionView registerClass:[KKAlbumImageShowCollectionBarItem class] forCellWithReuseIdentifier:KKAlbumImageShowCollectionBarItem_ID];
        [self addSubview:self.mainCollectionView];

        if ([[KKAlbumImagePickerManager defaultManager].allSource count]==0) {
            self.hidden = YES;
        }
        else{
            self.hidden = NO;
        }

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumImagePickerSelectModel:) name:NotificationName_KKAlbumImagePickerSelectModel object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumImagePickerUnSelectModel:) name:NotificationName_KKAlbumImagePickerUnSelectModel object:nil];

        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
        line.backgroundColor = KKMediaPicker_Clolor_DEDEDE;
        [self addSubview:line];
    }
    return self;
}

- (void)selectModel:(KKAlbumAssetModel*)aSelectModel{
    self.selectModel = aSelectModel;
    [self.mainCollectionView reloadData];
    
    if ([[KKAlbumImagePickerManager defaultManager] isSelectAssetModel:aSelectModel]) {
        NSInteger index = [[KKAlbumImagePickerManager defaultManager].allSource indexOfObject:aSelectModel];
        [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}


#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
- (void)Notification_KKAlbumImagePickerSelectModel:(NSNotification*)notice{
    [self.mainCollectionView reloadData];
    if ([[KKAlbumImagePickerManager defaultManager].allSource count]==0) {
        self.hidden = YES;
    }
    else{
        self.hidden = NO;
    }
    [self.mainCollectionView reloadData];
    NSInteger index = [[KKAlbumImagePickerManager defaultManager].allSource indexOfObject:notice.object];
    [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)Notification_KKAlbumImagePickerUnSelectModel:(NSNotification*)notice{
    [self.mainCollectionView reloadData];
    if ([[KKAlbumImagePickerManager defaultManager].allSource count]==0) {
        self.hidden = YES;
    }
    else{
        self.hidden = NO;
    }
}

#pragma mark - ==================================================
#pragma mark == UICollectionViewDataSource
#pragma mark ====================================================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[KKAlbumImagePickerManager defaultManager].allSource count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KKAlbumImageShowCollectionBarItem *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:KKAlbumImageShowCollectionBarItem_ID forIndexPath:indexPath];
    
    KKAlbumAssetModel *assetModel = [[KKAlbumImagePickerManager defaultManager].allSource objectAtIndex:indexPath.row];
    if (assetModel==self.selectModel) {
        [cell reloadWithInformation:assetModel select:YES];
    }
    else{
        [cell reloadWithInformation:assetModel select:NO];
    }
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
// 设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = 40;
    return CGSizeMake(itemWidth, itemWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){0,0};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){0,0};
}




#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImageShowCollectionBar_SelectModel:)]) {
        KKAlbumAssetModel *assetModel = [[KKAlbumImagePickerManager defaultManager].allSource objectAtIndex:indexPath.row];
        [self.delegate KKAlbumImageShowCollectionBar_SelectModel:assetModel];
    }
}

//// 长按某item，弹出copy和paste的菜单
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}
//
//// 使copy和paste有效
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
//{
//    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
//    {
//        return YES;
//    }
//
//    return NO;
//}
//
////
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
//{
////    if([NSStringFromSelector(action) isEqualToString:@"copy:"])
////    {
////        //      NSLog(@"-------------执行拷贝-------------");
////        [_collectionView performBatchUpdates:^{
////            [_section0Array removeObjectAtIndex:indexPath.row];
////            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
////        } completion:nil];
////    }
////    else if([NSStringFromSelector(action) isEqualToString:@"paste:"])
////    {
////        NSLog(@"-------------执行粘贴-------------");
////    }
//}

@end
