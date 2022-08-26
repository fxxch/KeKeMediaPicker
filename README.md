# KeKeMediaPicker

## 说明：
1、这只是我本人封装的一个从相册选择图片、或者拍照方式拍摄照片、或者长按拍摄视频单击拍照。<br>



## 引入方式：
```
1、git clone https://github.com/fxxch/KeKeMediaPicker.git 然后自行编译静态库或者动态库
```

```
2、pod 'KeKeMediaPicker'
```

## 使用方法：
```
#import <KeKeMediaPicker/KKMediaPicker.h>
```

1. 从相册选择图片或视频，支持预览，选择单张照片的时候支持裁剪。
```
    CGSize cropSize = CGSizeMake(100,100);
    KKAlbumImagePickerController *viewController = [[KKAlbumImagePickerController alloc] initWithDelegate:self numberOfPhotosNeedSelected:9 cropEnable:NO cropSize:cropSize assetMediaType:KKAssetMediaType_All];
    [self.navigationController presentViewController:viewController animated:YES completion:^{
            
    }];

```

****结果代理回调
```
#pragma mark ==================================================
#pragma mark == KKAlbumImagePickerDelegate
#pragma mark ==================================================
- (void)KKAlbumImagePicker_didFinishedPickImages:(NSArray<KKAlbumAssetModel*>*)aImageArray{


}

```


2. 调用系统相机拍摄照片，支持拍多张。

```
    CGSize cropSize = CGSizeMake(100, 100);
    KKCameraImagePickerController *viewController = [[KKCameraImagePickerController alloc] initWithDelegate:self numberOfPhotosNeedSelected:1 cropEnable:YES cropSize:cropSize imageFileMaxSize:300];
    [self.navigationController presentViewController:viewController animated:YES completion:^{
            
    }];

```

****结果代理回调
```
#pragma mark ==================================================
#pragma mark == KKCameraImagePickerDelegate
#pragma mark ==================================================
- (void)KKCameraImagePicker_didFinishedPickImages:(NSArray <UIImage*>*)aImageArray{

}
```

3. 调用系统相机拍摄照片或视频。只支持单张，单击的时候拍照，长按拍摄视频。

```
    KKCameraCapturePickerController *viewController = [[KKCameraCapturePickerController alloc] initWithDelegate:self];
    [self.navigationController presentViewController:viewController animated:YES completion:^{
            
    }];

```

****结果代理回调

```
#pragma mark ==================================================
#pragma mark == KKCameraCaptureViewControllerDelegate
#pragma mark ==================================================
/// 完成拍摄
/// @param aFileFullPath 拍摄保存的文件路径
/// @param aFileName 拍摄保存的文件的文件名
/// @param aExtention 拍摄保存的文件的扩展名（png、mp4、mov）
/// @param aTimeDuration 如果是拍摄的视频，这个是视频的时长
- (void)KKCameraCapturePicker_FinishedWithFilaFullPath:(NSString*)aFileFullPath
                                              fileName:(NSString*)aFileName
                                         fileExtention:(NSString*)aExtention
                                          timeDuration:(NSString*)aTimeDuration{
    
}

```

## 期待：
作者：刘波<br>
QQ：349230334<br>
Email：349230334@qq.com<br>

