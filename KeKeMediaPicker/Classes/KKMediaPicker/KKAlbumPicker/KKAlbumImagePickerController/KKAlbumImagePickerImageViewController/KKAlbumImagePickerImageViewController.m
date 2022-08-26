//
//  KKAlbumImagePickerImageViewController.m
//  HeiPa
//
//  Created by liubo on 2019/3/13.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImagePickerImageViewController.h"
#import "KKAlbumImageToolBar.h"
#import "KKImageCropperViewController.h"
#import "KKAlbumImageShowViewController.h"
#import "KKAlbumImagePickerDirectoryList.h"
#import "KKAlbumImagePickerNavTitleBar.h"
#import "AlbumImageCollectionViewCell.h"
#import "KKMediaPickerAuthorization.h"
#import "UIWindow+KKMediaPicker.h"
#import "NSString+KKMediaPicker.h"
#import "NSBundle+KKMediaPicker.h"
#import "KKMediaPickerLocalization.h"

@interface KKAlbumImagePickerImageViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
KKAlbumImageToolBarDelegate,
AlbumImageCollectionViewCellDelegate,
KKAlbumImageShowViewControllerDelegate,
KKAlbumImagePickerDirectoryListDelegate,
KKAlbumImagePickerNavTitleBarDelegate>

@property (nonatomic , strong) UICollectionView *mainCollectionView;
@property (nonatomic , strong) KKAlbumImageToolBar *toolBar;
@property (nonatomic , strong) KKAlbumImagePickerNavTitleBar *titleBar;
@property (nonatomic , strong) KKAlbumImagePickerDirectoryList *directoryList;
// 放置图像处理时候的等待View
@property (nonatomic , strong)UIView *waitingView;
@property (nonatomic , strong) KKAlbumDirectoryModel *directoryModel;

@end

@implementation KKAlbumImagePickerImageViewController

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self name:NotificationName_KKAlbumManagerLoadSourceFinished object:nil];
    NSLog(@"KKAlbumImagePickerImageViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //左导航
    UIImage *image = [NSBundle kkmp_imageInBundle:@"KKAlbumManager.bundle" imageName:@"Cancel"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton addTarget:self action:@selector(navigationControllerDismiss) forControlEvents:UIControlEventTouchUpInside];
    leftButton.exclusiveTouch = YES;//关闭多点
    [leftButton setImage:image forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];

    //右导航
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    UIBarButtonItem *negativeSeperatorRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSeperatorRight, rightItem, nil];

    self.titleBar = [[KKAlbumImagePickerNavTitleBar alloc] initWithFrame:CGRectMake(0, 0,  UIWindow.kkmp_screenWidth-leftButton.frame.size.width*2, UIWindow.kkmp_navigationBarHeight)];
    self.navigationItem.titleView = self.titleBar;
    self.titleBar.delegate = self;
    
    [self initUI];
    
    self.directoryList = [[KKAlbumImagePickerDirectoryList alloc] initWithFrame:CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight-UIWindow.kkmp_statusBarAndNavBarHeight)];
    [self.view addSubview:self.directoryList];
    self.directoryList.hidden = YES;
    self.directoryList.delegate = self;
    
    [self initWaitingView];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumManagerLoadSourceFinished:) name:NotificationName_KKAlbumManagerLoadSourceFinished object:nil];
    
    
    [KKMediaPickerAuthorization.defaultManager isAlbumAuthorized:^(BOOL isAuthorized) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isAuthorized) {
                // 为了防止界面卡住，可以异步执行
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    KKAssetMediaType type = [KKAlbumImagePickerManager defaultManager].mediaType;
                    NSArray *array = [KKAlbumManager loadDirectory_WithMediaType:type];

                    //回到主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [NSNotificationCenter.defaultCenter postNotificationName:NotificationName_KKAlbumManagerLoadSourceFinished object:array];
                        
                    });
                    
                });
            }
            else{
                [NSNotificationCenter.defaultCenter postNotificationName:NotificationName_KKAlbumManagerLoadSourceFinished object:nil];
            }
        });
        
    }];
}

- (void)loadImagesLimited{
    // 为了防止界面卡住，可以异步执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //用户选择Limited模式，限制App访问有限的相册资源
        NSMutableArray<UIImage *> *images = [NSMutableArray array];
        //获取可访问的图片配置选项
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        //根据图片的创建时间升序排序返回
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        //获取类型为image的资源
        PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
        //遍历出每个PHAsset资源对象
        [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = (PHAsset *)obj;
            //将PHAsset解析为image的配置选项
            PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
            //图像缩放模式
            requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
            //图片质量
            requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            //PHImageManager解析图片
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                NSLog(@"图片 %@",result);
                //在这里可以自定义一个显示可访问相册资源的viewController.
                [images addObject:result];
            }];
        }];
        
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [NSNotificationCenter.defaultCenter postNotificationName:NotificationName_KKAlbumManagerLoadSourceFinished object:array];
            
        });

        
    });
}

- (void)initUI{
    if ([KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected>1) {
        //主图片
        CGRect collectionViewFrame= CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight-UIWindow.kkmp_statusBarAndNavBarHeight-60);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.mainCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
        self.mainCollectionView.showsVerticalScrollIndicator = NO;
        self.mainCollectionView.showsHorizontalScrollIndicator = NO;
        self.mainCollectionView.backgroundColor = [UIColor whiteColor];
        self.mainCollectionView.dataSource = self;
        self.mainCollectionView.delegate = self;
        self.mainCollectionView.bounces = YES;
        self.mainCollectionView.alwaysBounceVertical = YES;
        [self.mainCollectionView registerClass:[AlbumImageCollectionViewCell class] forCellWithReuseIdentifier:AlbumImageCollectionViewCell_ID];
        [self.view addSubview:self.mainCollectionView];

        /*底部工具栏*/
        self.toolBar = [[KKAlbumImageToolBar alloc] initWithFrame:CGRectMake(0, UIWindow.kkmp_screenHeight-UIWindow.kkmp_statusBarAndNavBarHeight-(UIWindow.kkmp_safeAreaBottomHeight+50), UIWindow.kkmp_screenWidth, (UIWindow.kkmp_safeAreaBottomHeight+50))];
        self.toolBar.delegate = self;
        [self.view addSubview:self.toolBar];
        [self.toolBar setNumberOfPic:0 maxNumberOfPic:[KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected];
    }
    else{
        //主图片
        CGRect collectionViewFrame= CGRectMake(0, 0,  UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight-UIWindow.kkmp_statusBarAndNavBarHeight);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.mainCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
        self.mainCollectionView.showsVerticalScrollIndicator = NO;
        self.mainCollectionView.showsHorizontalScrollIndicator = NO;
        self.mainCollectionView.backgroundColor = [UIColor whiteColor];
        self.mainCollectionView.dataSource = self;
        self.mainCollectionView.delegate = self;
        self.mainCollectionView.bounces = YES;
        self.mainCollectionView.alwaysBounceVertical = YES;
        [self.mainCollectionView registerClass:[AlbumImageCollectionViewCell class] forCellWithReuseIdentifier:AlbumImageCollectionViewCell_ID];
        [self.view addSubview:self.mainCollectionView];
    }

    if (self.directoryModel.assetsArray.count>0) {
        [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.directoryModel.assetsArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumImagePickerSelectModel:) name:NotificationName_KKAlbumImagePickerSelectModel object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(Notification_KKAlbumImagePickerUnSelectModel:) name:NotificationName_KKAlbumImagePickerUnSelectModel object:nil];
}

- (void)initWaitingView{
    self.waitingView = [[UIView alloc] initWithFrame:CGRectMake((UIWindow.kkmp_screenWidth-80)/2.0, (UIWindow.kkmp_screenHeight-UIWindow.kkmp_statusBarAndNavBarHeight-80)/2.0, 80, 80)];
    self.waitingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.waitingView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.waitingView];
    self.waitingView.clipsToBounds = YES;
    self.waitingView.userInteractionEnabled = YES;
    self.waitingView.layer.cornerRadius = 10.0;
    self.waitingView.layer.masksToBounds = YES;

    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activeView startAnimating];
    activeView.frame = CGRectMake(0, 0, 50, 50);
    activeView.center = CGPointMake(self.waitingView.frame.size.width/2.0, self.waitingView.frame.size.height/2.0);
    [self.waitingView addSubview:activeView];
    self.waitingView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.directoryModel==nil) {
        self.waitingView.hidden = NO;
    }
}

- (void)navigationControllerDismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
- (void)Notification_KKAlbumImagePickerSelectModel:(NSNotification*)notice{
    KKAlbumAssetModel *model = notice.object;
    NSInteger index = [self.directoryModel.assetsArray indexOfObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.mainCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void)Notification_KKAlbumImagePickerUnSelectModel:(NSNotification*)notice{
    KKAlbumAssetModel *model = notice.object;
    NSInteger index = [self.directoryModel.assetsArray indexOfObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.mainCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void)Notification_KKAlbumManagerLoadSourceFinished:(NSNotification*)notice{
    [self.waitingView removeFromSuperview];
    NSArray *array = notice.object;
    for (NSInteger i=0; i<[array count]; i++) {
        KKAlbumDirectoryModel *data = (KKAlbumDirectoryModel*)[array objectAtIndex:i];
        if (data.assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            self.directoryModel = data;
            [self.mainCollectionView reloadData];
            [self collectionViewScrollToBottom];
            break;
        }
    }
}

- (void)KKAlbumImagePickerNavTitleBar_Open:(BOOL)aOpen{
    if (aOpen) {
        [self.directoryList beginShow];
    } else {
        [self.directoryList beginHide];
    }
}

- (void)KKAlbumImagePickerDirectoryList:(KKAlbumImagePickerDirectoryList*)aListView
                 selectedDirectoryModel:(KKAlbumDirectoryModel*)aModel{
    self.directoryModel = aModel;
    [self.titleBar reloadWithDirectoryModel:self.directoryModel];
    [self.mainCollectionView reloadData];
    [self collectionViewScrollToBottom];
}

- (void)KKAlbumImagePickerDirectoryList_WillHide:(KKAlbumImagePickerDirectoryList*)aListView{
    [self.titleBar close];
}

- (void)KKAlbumImagePickerDirectoryList_WillShow:(KKAlbumImagePickerDirectoryList*)aListView{
    [self.titleBar open];
}

- (void)collectionViewScrollToBottom{
    CGFloat contentSizeHeight = contentSizeHeight =  self.mainCollectionView.collectionViewLayout.collectionViewContentSize.height;
    if (contentSizeHeight>self.mainCollectionView.bounds.size.height) {
        [self.mainCollectionView setContentOffset:CGPointMake(0, contentSizeHeight-self.mainCollectionView.bounds.size.height) animated:NO];
    }
    else{
        [self.mainCollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

#pragma mark - ==================================================
#pragma mark == UICollectionViewDataSource
#pragma mark ====================================================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.directoryModel.assetsArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumImageCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:AlbumImageCollectionViewCell_ID forIndexPath:indexPath];
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
    
    KKAlbumAssetModel *assetModel = [self.directoryModel.assetsArray objectAtIndex:indexPath.row];
    if ([[KKAlbumImagePickerManager defaultManager] isSelectAssetModel:assetModel]) {
        [(AlbumImageCollectionViewCell*)cell reloadWithInformation:assetModel select:YES];
    }
    else{
        [(AlbumImageCollectionViewCell*)cell reloadWithInformation:assetModel select:NO];
    }

}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = ( UIWindow.kkmp_screenWidth-25)/4.0;
    return CGSizeMake(itemWidth, itemWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){ UIWindow.kkmp_screenWidth,0.1};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){ UIWindow.kkmp_screenWidth,0.1};
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
    [self collectionViewItem_didSelectAtIndexPath:indexPath];
}

- (void)AlbumImageCollectionViewCell_MainButtonClicked:(AlbumImageCollectionViewCell*)aItemCell{
    NSInteger maxNumber = [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected;
    if (maxNumber==1) {
        NSIndexPath *indexPath = [self.mainCollectionView indexPathForCell:aItemCell];
        [self collectionViewItem_didSelectAtIndexPath:indexPath];
    }
    else{
        NSInteger index = [self.mainCollectionView indexPathForCell:aItemCell].row;
        
        //全屏展示
        KKAlbumImageShowViewController *viewController = [[KKAlbumImageShowViewController alloc] initWithArray:self.directoryModel.assetsArray selectIndex:index];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)AlbumImageCollectionViewCell_SelectButtonClicked:(AlbumImageCollectionViewCell*)aItemCell{
    NSIndexPath *indexPath = [self.mainCollectionView indexPathForCell:aItemCell];
    [self collectionViewItem_didSelectAtIndexPath:indexPath];
}


- (void)collectionViewItem_didSelectAtIndexPath:(NSIndexPath *)indexPath{
    
    KKAlbumAssetModel *assetModel = [self.directoryModel.assetsArray objectAtIndex:indexPath.row];
    [self selectdModelProcess:assetModel];
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

- (void)KKAlbumImageToolBar_PreviewButtonClicked:(KKAlbumImageToolBar*)toolView{
    //全屏展示
    KKAlbumImageShowViewController *viewController = [[KKAlbumImageShowViewController alloc] initWithArray:[KKAlbumImagePickerManager defaultManager].allSource selectIndex:0];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)KKAlbumImageToolBar_OKButtonClicked:(KKAlbumImageToolBar*)toolView{
    [self selectMultipleFinished];
}

- (void)selectSingleComplete:(KKAlbumAssetModel*)assetModel{
    
    if (assetModel.asset.mediaType==PHAssetMediaTypeImage) {
        if ([KKAlbumImagePickerManager defaultManager].cropEnable) {
            
            if (assetModel.fileURL==nil) {
                NSLog(@"KKAlbumImagePickerManager 图片任务处理开始");
                __weak   typeof(self) weakself = self;
                [KKAlbumManager startExportImageWithPHAsset:assetModel.asset
                                                resultBlock:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    if (imageData) {
                        [assetModel setOriginImageInfo:info
                                             imageData:imageData
                                          imageDataUTI:dataUTI
                                      imageOrientation:orientation
                                           filePathURL:nil];
                        
                        if (assetModel.fileURL) {
                            KKImageCropperViewController *cropImageViewController = [[KKImageCropperViewController alloc] initWithAssetModel:assetModel cropSize:[KKAlbumImagePickerManager defaultManager].cropSize];
                            [weakself.navigationController pushViewController:cropImageViewController animated:YES];
                            [cropImageViewController cropImage:^(KKAlbumAssetModel *aModel, UIImage *newImage) {
                                aModel.img_croppedbImage = newImage;
                                [[KKAlbumImagePickerManager defaultManager] selectAssetModel:aModel];
                                [weakself selectSingleFinished];
                            }];
                            NSLog(@"KKAlbumImagePickerManager A图片任务处理结束:【成功】");
                        }
                        else{
                            NSLog(@"KKAlbumImagePickerManager B图片任务处理结束:【失败】");
                        }
                    }
                    else{
                        NSLog(@"KKAlbumImagePickerManager C图片任务处理结束:【失败】");
                    }

                }];
            }
            else{
                NSLog(@"KKAlbumImagePickerManager 图片存在");
                KKImageCropperViewController *cropImageViewController = [[KKImageCropperViewController alloc] initWithAssetModel:assetModel cropSize:[KKAlbumImagePickerManager defaultManager].cropSize];
                
                [self.navigationController pushViewController:cropImageViewController animated:YES];
                __weak   typeof(self) weakself = self;
                [cropImageViewController cropImage:^(KKAlbumAssetModel *aModel, UIImage *newImage) {
                    aModel.img_croppedbImage = newImage;
                    [[KKAlbumImagePickerManager defaultManager] selectAssetModel:aModel];
                    [weakself selectSingleFinished];
                }];
            }
        }
        else{
            [[KKAlbumImagePickerManager defaultManager] selectAssetModel:assetModel];
            [self selectSingleFinished];
        }
    }
    else if (assetModel.asset.mediaType==PHAssetMediaTypeVideo){
        [[KKAlbumImagePickerManager defaultManager] selectAssetModel:assetModel];
        [self selectSingleFinished];
    }
    else{
        
    }
    
}

- (void)selectMultipleFinished{
    [[KKAlbumImagePickerManager defaultManager] finishedWithNavigationController:self.navigationController];
}

- (void)selectSingleFinished{
    [[KKAlbumImagePickerManager defaultManager] finishedWithNavigationController:self.navigationController];
}

- (void)KKAlbumImageShowViewController_ClickedModel:(KKAlbumAssetModel*)aModel{
    [self selectdModelProcess:aModel];
}

- (void)selectdModelProcess:(KKAlbumAssetModel*)assetModel{
    
    /* 最大允许数量 */
    NSInteger maxNumber = [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected;
    if (maxNumber==1) {
        [[KKAlbumImagePickerManager defaultManager] clearAllObjects];
        [self selectSingleComplete:assetModel];
    }
    else{
        if ([[KKAlbumImagePickerManager defaultManager] isSelectAssetModel:assetModel]) {
            [[KKAlbumImagePickerManager defaultManager] deselectAssetModel:assetModel];
        }
        else{
            /* 已经达到最大 */
            NSInteger maxNumber = [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected;
            NSInteger selectNumber = [[KKAlbumImagePickerManager defaultManager].allSource count];
            if (selectNumber >= maxNumber) {
  
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[KKMediaPickerLocalization localizationStringForKey:KKMediaPickerLocalKey_Album_MaxLimited]
//                                                                                         message:nil
//                                                                                  preferredStyle:UIAlertControllerStyleAlert];
//                
//                [alertController addAction:[UIAlertAction actionWithTitle:[KKMediaPickerLocalization localizationStringForKey:KKMediaPickerLocalKey_Common_OK]
//                                                                    style:UIAlertActionStyleDefault
//                                                                  handler:nil]];
//                
//                [self.navigationController presentViewController:alertController animated:true completion:nil];
                return;
            }
            [[KKAlbumImagePickerManager defaultManager] selectAssetModel:assetModel];
        }
    }

}

#pragma mark ==================================================
#pragma mark == 主体颜色
#pragma mark ==================================================
/* 子类可重写该方法，不重写的话默认是白色 */
- (UIColor*)kk_DefaultNavigationBarBackgroundColor{
    return [KKAlbumManager navigationBarBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self kkmp_setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
}


@end



