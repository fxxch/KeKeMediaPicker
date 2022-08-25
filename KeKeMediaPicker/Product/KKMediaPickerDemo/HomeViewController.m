//
//  HomeViewController.m
//  KKRequestDemo
//
//  Created by edward lannister on 2022/08/15.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "HomeViewController.h"
#import "KKCameraImagePickerController.h"
#import "KKAlbumImagePickerController.h"
#import "KKMediaPickerDefine.h"
#import "UIWindow+KKMediaPicker.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,KKCameraImagePickerDelegate,KKAlbumImagePickerDelegate>

@property (nonatomic , strong) UITableView *table;
@property (nonatomic , strong) NSMutableArray *dataSource;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KKRequestDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *buttonAlbum = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonAlbum.frame = CGRectMake(20, 20+UIWindow.kkmp_statusBarAndNavBarHeight, (UIWindow.kkmp_screenWidth-60)/2.0, 50);
    [buttonAlbum setTitle:@"相册" forState:UIControlStateNormal];
    [buttonAlbum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonAlbum.backgroundColor = [UIColor systemBlueColor];
    [self.view addSubview:buttonAlbum];
    [buttonAlbum addTarget:self action:@selector(buttonAlbumClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonCamera = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonCamera.frame = CGRectMake(CGRectGetMaxX(buttonAlbum.frame)+10, 20+UIWindow.kkmp_statusBarAndNavBarHeight, (UIWindow.kkmp_screenWidth-60)/2.0, 50);
    [buttonCamera setTitle:@"相机" forState:UIControlStateNormal];
    [buttonCamera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonCamera.backgroundColor = [UIColor systemRedColor];
    [self.view addSubview:buttonCamera];
    [buttonCamera addTarget:self action:@selector(buttonCameraClicked) forControlEvents:UIControlEventTouchUpInside];

    self.dataSource = [[NSMutableArray alloc] init];
    
    CGRect frame = CGRectMake(0, 80+UIWindow.kkmp_statusBarAndNavBarHeight, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight-UIWindow.kkmp_statusBarAndNavBarHeight-80);
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexColor = [UIColor blackColor];
    tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.clipsToBounds = YES;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0;
    }
    self.table = tableView;
    [self.view addSubview:self.table];
}

- (void)buttonAlbumClicked{
    CGSize cropSize = CGSizeMake(UIWindow.kkmp_screenWidth-40, UIWindow.kkmp_screenWidth-40);
    KKAlbumImagePickerController *viewController = [[KKAlbumImagePickerController alloc] initWithDelegate:self numberOfPhotosNeedSelected:9 cropEnable:NO cropSize:cropSize assetMediaType:KKAssetMediaType_All];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:viewController animated:YES completion:^{
            
    }];
}

- (void)buttonCameraClicked{
    CGSize cropSize = CGSizeMake(UIWindow.kkmp_screenWidth-40, UIWindow.kkmp_screenWidth-40);
    KKCameraImagePickerController *viewController = [[KKCameraImagePickerController alloc] initWithDelegate:self numberOfPhotosNeedSelected:3 editEnable:YES cropSize:cropSize imageFileMaxSize:300];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:viewController animated:YES completion:^{
            
    }];
}


#pragma mark ==================================================
#pragma mark == KKCameraImagePickerDelegate
#pragma mark ==================================================
- (void)KKCameraImagePicker_didFinishedPickImages:(NSArray <UIImage*>*)aImageArray{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:aImageArray];
    [self.table reloadData];
}

#pragma mark ==================================================
#pragma mark == KKAlbumImagePickerDelegate
#pragma mark ==================================================
///// 选择图片之后，可自定义保存的路径，不过实现该方法（不自定义），内部会自动存储在一个地方
///// @param fileName 文件名 eg: happy.jpg
///// @param aExtentionName 文件扩展名 ex: jpg
//- (NSURL*)KKAlbumImagePicker_fileURLForSave:(NSString*)fileName
//                          fileExtentionName:(NSString*)aExtentionName{
//
//}
//
//
///// 对已经选择的图片进行压缩的时候，可自定义保存的路径，不过实现该方法（不自定义），内部会自动存储在一个地方
///// @param fileName 文件名 eg: happy.jpg
///// @param aExtentionName 文件扩展名 ex: jpg
//- (NSURL*)KKAlbumImagePicker_fileURLForCompress:(NSString*)fileName
//                              fileExtentionName:(NSString*)aExtentionName{
//
//}

- (void)KKAlbumImagePicker_didFinishedPickImages:(NSArray<KKAlbumAssetModal*>*)aImageArray{
    [self.dataSource removeAllObjects];
    for (KKAlbumAssetModal *model in aImageArray) {
        if (model.img_croppedbImage) {
            [self.dataSource addObject:model.img_croppedbImage];
        }
        else if (model.img_originData){
            [self.dataSource addObject:[UIImage imageWithData:model.img_originData]];
        }

    }
    
    [self.table reloadData];
}


#pragma mark ==================================================
#pragma mark == UITableViewDelegate
#pragma mark ==================================================
/* heightForRow */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

/* Header Height */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

/* Header View */
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

/* Footer Height */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

/* Footer View */
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

#pragma mark ==================================================
#pragma mark == UITableViewDataSource
#pragma mark ==================================================
/* numberOfRowsInSection */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

/* cellForRowAtIndexPath */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.imageView.image = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}


@end
