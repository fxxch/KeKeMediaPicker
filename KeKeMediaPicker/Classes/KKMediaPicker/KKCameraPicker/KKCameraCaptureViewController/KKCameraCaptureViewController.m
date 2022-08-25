//
//  KKCameraCaptureViewController.m
//  BM
//
//  Created by 刘波 on 2020/2/29.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKCameraCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KKCameraCaptureTopBar.h"
#import "KKCameraHelper.h"
#import "KKCameraWaitingView.h"
#import "XLCircleProgress.h"
#import "KKCameraCaptureShowViewController.h"
#import "KKCameraCaptureDataModal.h"
#import "KKMediaPickerWatingView.h"
#import "KKMediaPickerAuthorization.h"
#import "UIWindow+KKMediaPicker.h"
#import "KKAlbumManager.h"
#import "UIImage+KKMediaPicker.h"

//#import "IJSImagePickerController.h"
//#import "IJSImageManagerController.h"
//#import <IJSFoundation/IJSFoundation.h>
//#import "IJSMapViewModel.h"

#define KKCameraCapture_TimeMaxCount (30)

@interface KKCameraCaptureViewController ()
<KKCameraCaptureTopBarDelegate,
UIGestureRecognizerDelegate,
AVCapturePhotoCaptureDelegate,
AVCaptureFileOutputRecordingDelegate,
KKCameraCaptureShowDelegate>

// 数据模型
@property (nonatomic, strong)KKCameraCaptureDataModal *dataModal;

// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong)AVCaptureSession *captureSession;

// AVCaptureDeviceInput 对象是输入流
@property (nonatomic, strong)AVCaptureDeviceInput *captureDeviceInputVideo;
@property (nonatomic, strong)AVCaptureDeviceInput *captureDeviceInputAudio;
@property (nonatomic, assign)AVCaptureFlashMode flashMode;
// AVCapturePhotoOutput 照片输出流对象
@property (nonatomic, strong)AVCapturePhotoOutput *capturePhotoOutput;
// AVCaptureMovieFileOutput 视频输出流对象
@property (strong,nonatomic) AVCaptureMovieFileOutput  *captureMovieFileOutput;
@property (nonatomic, strong) NSTimer *recorderAnimationTimer;//长按录制视频的按钮进度
@property (nonatomic, assign) NSInteger recorderTimerCount;//N秒后自动结束
@property (nonatomic, assign) CGFloat recorderAnimationTimerCount;//长按录制视频的按钮进度
@property (nonatomic, assign) NSInteger timerResult;//视频的录制时间

// 放置预览图层的View
@property (nonatomic, strong)UIView *cameraShowView;
// 预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
// 放置图像拍摄成功的预览View
@property (nonatomic, strong)UIImageView *previewImageView;

// 顶部操作Bar
@property (nonatomic, strong)KKCameraCaptureTopBar *topBar;
@property (nonatomic, strong)UIView *recordButton;
@property(nonatomic,assign)BOOL recordButtonIsBig;
@property(nonatomic,assign)BOOL recordTimeTooShort;//录像时间太短，取视频第一帧为图片
@property (nonatomic, strong)XLCircleProgress *recordCircle;

// 聚焦的View
@property (nonatomic, strong)UIView *focusView;

@property(nonatomic,assign)CGFloat beginGestureScale;

@property(nonatomic,assign)CGFloat effectiveScale;


@end

@implementation KKCameraCaptureViewController

- (void)dealloc{
    [self destroyTimer];
    [self.dataModal stopMotionManager];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.effectiveScale = 1.0f;
        self.beginGestureScale = 1.0f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.dataModal = [[KKCameraCaptureDataModal alloc] init];

    if ([KKMediaPickerAuthorization isCameraAuthorized]) {
        [self.dataModal startMotionManager];

        [self initialSession];

        [self initPreviewImageView];

        [self initCameraShowView];

        /*顶部*/
        self.topBar = [[KKCameraCaptureTopBar alloc] initWithFrame:CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_statusBarAndNavBarHeight)];
        self.topBar.delegate = self;
        [self.view addSubview:self.topBar];
        self.topBar.doneButton.hidden = YES;

        [self initRecordButton];
    }
    else{
        /*顶部*/
        self.topBar = [[KKCameraCaptureTopBar alloc] initWithFrame:CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_statusBarAndNavBarHeight)];
        self.topBar.delegate = self;
        [self.view addSubview:self.topBar];

        self.topBar.doneButton.hidden = YES;
        self.topBar.cameraDeviceButton.hidden = YES;
        self.topBar.cameraFlashModeButton.hidden = YES;
    }
}

#pragma mark ==================================================
#pragma mark == UI & init
#pragma mark ==================================================
- (void)initialSession{
    //初始化会话
    self.captureSession=[[AVCaptureSession alloc]init];
    [self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]?[self.captureSession setSessionPreset:AVCaptureSessionPresetHigh]:nil;
    [self.captureSession beginConfiguration];

    /* ========== 输入设备 ========== */
    //获得输入设备(取得后置摄像头)
    AVCaptureDevice *videoCaptureDevice=[KKCameraHelper cameraVideoWithPosition:AVCaptureDevicePositionBack];
    self.dataModal.captureDevicePosition = AVCaptureDevicePositionBack;
    //获取音频输入设备（麦克风）
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error=nil;
    self.captureDeviceInputVideo = [[AVCaptureDeviceInput alloc]initWithDevice:videoCaptureDevice error:&error];
    self.captureDeviceInputAudio=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if ([self.captureSession canAddInput:self.captureDeviceInputVideo] &&
        [self.captureSession canAddInput:self.captureDeviceInputAudio] ) {
        [self.captureSession addInput:self.captureDeviceInputVideo];
        [self.captureSession addInput:self.captureDeviceInputAudio];
    }


    /* ========== 输出 ========== */
    //视频
    self.captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    if ([self.captureSession canAddOutput:self.captureMovieFileOutput]) {
        [self.captureSession addOutput:self.captureMovieFileOutput];
    }
    //图片
    self.capturePhotoOutput = [[AVCapturePhotoOutput alloc] init];
    if ([self.captureSession canAddOutput:self.capturePhotoOutput]) {
        [self.captureSession addOutput:self.capturePhotoOutput];
    }
    [KKCameraHelper reloadAVCapturePhotoSettings:self.capturePhotoOutput flashMode:self.flashMode];

    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([captureConnection isVideoStabilizationSupported ] &&
        captureConnection.activeVideoStabilizationMode == AVCaptureVideoStabilizationModeOff){
        captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;//视频防抖
    }
    captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;//镜头缩放最大
    captureConnection.videoOrientation = [self.previewLayer connection].videoOrientation;//预览图层和视频方向保持一致

    [self.captureSession commitConfiguration];
}

- (void)initPreviewImageView{
    self.previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight)];
    self.previewImageView.backgroundColor = [UIColor clearColor];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.previewImageView];
    self.previewImageView.clipsToBounds = YES;
    self.previewImageView.userInteractionEnabled = NO;
}

- (void)initCameraShowView{
    self.cameraShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight)];
    [self.view addSubview:self.cameraShowView];

    self.focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.focusView.layer.borderColor = [UIColor colorWithRed:252/255.0 green:208/255.0 blue:52/255.0 alpha:1.0].CGColor;
    self.focusView.layer.borderWidth = 2.0f;
    self.focusView.hidden = YES;
    self.focusView.alpha = 0.0;
    [self.view addSubview:self.focusView];


    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.cameraShowView addGestureRecognizer:pinch];


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusAction:)];
    [self.cameraShowView addGestureRecognizer:tap];
}

- (void)initRecordButton{
    self.recordCircle = [[XLCircleProgress alloc] initWithFrame:CGRectMake((UIWindow.kkmp_screenWidth-90)/2.0, UIWindow.kkmp_screenHeight-UIWindow.kkmp_safeAreaBottomHeight-90-30, 90, 90)];
    self.recordCircle.backgroundColor = [UIColor colorWithRed:0.86f green:0.85f blue:0.84f alpha:1.00f];
    self.recordCircle.userInteractionEnabled = YES;
    [self.view addSubview:self.recordCircle];
    [self.recordCircle needShowText:NO];
    self.recordCircle.layer.cornerRadius = self.recordCircle.frame.size.height/2.0;
    self.recordCircle.layer.masksToBounds = YES;

    self.recordButton = [[UIView alloc] initWithFrame:CGRectMake((self.recordCircle.frame.size.width-70)/2.0, (self.recordCircle.frame.size.height-70)/2.0, 70, 70)];
    self.recordButton.backgroundColor = [UIColor whiteColor];
    [self.recordCircle addSubview:self.recordButton];
    self.recordButton.layer.cornerRadius = self.recordButton.frame.size.height/2.0;
    self.recordButton.layer.masksToBounds = YES;

    // 添加长按手势
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordButtonLongPressed:)];
    [longPress setDelegate:self];
    [longPress setMinimumPressDuration:0.15f];
    [longPress setAllowableMovement:0.0];
    [self.recordButton addGestureRecognizer:longPress];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tapGestureRecognizer.delegate = self;
    [self.recordButton addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

- (void)setUpCameraLayer{
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];

        UIView * view = self.cameraShowView;
        CALayer * viewLayer = [view layer];
        // UIView的clipsToBounds属性和CALayer的setMasksToBounds属性表达的意思是一致的,决定子视图的显示范围。当取值为YES的时候，剪裁超出父视图范围的子视图部分，当取值为NO时，不剪裁子视图。
        [viewLayer setMasksToBounds:YES];
        CGRect bounds = [view bounds];
        [self.previewLayer setFrame:bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [viewLayer addSublayer:self.previewLayer];
    }
}

- (void)recordButtonBigAnimated{
    if (self.recordButtonIsBig==NO) {
        self.recordButtonIsBig = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform newTransform =  CGAffineTransformScale(self.recordCircle.transform, 1.0*1.35, 1.0*1.35);
            [self.recordCircle setTransform:newTransform];
            CGAffineTransform newTransform2 =  CGAffineTransformScale(self.recordButton.transform, 1.0*0.5, 1.0*0.5);
            [self.recordButton setTransform:newTransform2];

        } completion:^(BOOL finished) {
                    
        }];
    }
}

- (void)recordButtonSmallAnimated{
    if (self.recordButtonIsBig==YES) {
        self.recordButtonIsBig = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform newTransform =  CGAffineTransformScale(self.recordCircle.transform, 1.0/1.35, 1.0/1.35);
            [self.recordCircle setTransform:newTransform];
            CGAffineTransform newTransform2 =  CGAffineTransformScale(self.recordButton.transform, 1.0/0.5, 1.0/0.5);
            [self.recordButton setTransform:newTransform2];

        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark ==================================================
#pragma mark == 长按手势
#pragma mark ==================================================
- (void)recordButtonLongPressed:(UILongPressGestureRecognizer *)recognizer{

    //识别器尚未识别其手势，但可能正在评估触摸事件。这是默认状态
    if(recognizer.state == UIGestureRecognizerStatePossible){

    }
    else if(recognizer.state == UIGestureRecognizerStateBegan){
        [self recordButtonBigAnimated];
        [self startRecord];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged){

    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //        NSLog(@"长按结束");
        [self recordButtonSmallAnimated];
        [self stopRecord];
    }
    //识别器已接收到导致手势取消的触摸。action方法将在运行循环的下一轮调用。识别器将被重置为UIGestureRecognizerStatePossible
    else if(recognizer.state == UIGestureRecognizerStateCancelled){
        [self recordButtonSmallAnimated];
        [self stopRecord];
    }
    //识别器接收到的触摸序列不能被识别为手势。动作方法将不会被调用，识别器将被重置为UIGestureRecognizerStatePossible
    else if(recognizer.state == UIGestureRecognizerStateFailed){
        [self recordButtonSmallAnimated];
        [self stopRecord];
    }
    //识别器接收到被识别为手势的触摸。动作方法将在运行循环的下一个回合被调用，识别器将被重置为UIGestureRecognizerStatePossible
    else if(recognizer.state == UIGestureRecognizerStateRecognized){

    }
    else{

    }
}

//单击
- (void) singleTap:(UITapGestureRecognizer*) tap {
    [self shutterCamera];
}

#pragma mark ==================================================
#pragma mark == 拍照
#pragma mark ==================================================
// 这是拍照按钮的方法
- (void)shutterCamera{
    AVCaptureConnection *videoConnection = [self.capturePhotoOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        return;
    }

    if (videoConnection.active) {
        videoConnection.videoOrientation = [self.dataModal.helper captureVideoOrientation];
        self.dataModal.isImage = YES;
        AVCapturePhotoSettings *outputSettings = [KKCameraHelper getAVCapturePhotoSettings:self.flashMode];
        [self.capturePhotoOutput capturePhotoWithSettings:outputSettings delegate:self];
    }
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error API_AVAILABLE(ios(11.0)){

    [KKMediaPickerWatingView showInView:self.view blackBackground:NO];
    [self.captureSession stopRunning];

    __weak   typeof(self) weakself = self;
    // 为了防止界面卡住，可以异步执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 这个就是HEIF(HEIC)的文件数据,直接保存即可
        NSData *data = photo.fileDataRepresentation;
        UIImage *image = [UIImage imageWithData:data].kkmp_fixOrientation;
        NSData *newData = UIImageJPEGRepresentation(image, 1.0);
        if (data &&
            image && [image isKindOfClass:[UIImage class]] ) {
            BOOL saveResult = [newData writeToFile:weakself.dataModal.imageFilePath atomically:YES];
            if (saveResult) {
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.previewImageView.image = image;
                    [KKMediaPickerWatingView hideForView:weakself.view];

                    [weakself cameraCaptureFinishedWithFilePath:weakself.dataModal.imageFilePath placeHolderImage:nil];
                });
            }
            else{
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.previewImageView.image = image;
                });
            }
        } else{
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.previewImageView.image = image;
            });
        }
    });
}

#pragma mark ==================================================
#pragma mark == 录像
#pragma mark ==================================================
- (void)startRecord{
    [self destroyTimer];

    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    if (![self.captureMovieFileOutput isRecording]) {
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation = [self.dataModal.helper captureVideoOrientation];
        self.dataModal.isImage = NO;
        [self.captureMovieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:self.dataModal.movFileFullPath] recordingDelegate:self];
    }
}

- (void)stopRecord{
    //录像时间太短
    if (self.recorderTimerCount<1) {
        self.recordTimeTooShort = YES;
    } else {
        self.recordTimeTooShort = NO;
    }
    [self destroyTimer];
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
    if ([self.captureMovieFileOutput isRecording]) {
        [self.captureMovieFileOutput stopRecording];
    }
}


#pragma mark ==================================================
#pragma mark == AVCaptureFileOutputRecordingDelegate
#pragma mark ==================================================
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    [self startTimer];
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    if (self.recordTimeTooShort) {
        [KKMediaPickerWatingView showInView:self.view blackBackground:NO];

        __weak   typeof(self) weakself = self;
        // 为了防止界面卡住，可以异步执行
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 这个就是HEIF(HEIC)的文件数据,直接保存即可
            UIImage *image = [KKAlbumManager getVideoPreViewImageWithURL:[NSURL fileURLWithPath:weakself.dataModal.movFileFullPath]];
            [weakself.dataModal reset];
            weakself.dataModal.isImage = YES;
            NSData *newData = UIImageJPEGRepresentation(image, 1.0);
            if (newData &&
                image && [image isKindOfClass:[UIImage class]] ) {
                BOOL saveResult = [newData writeToFile:weakself.dataModal.imageFilePath atomically:YES];
                if (saveResult) {
                    //回到主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.previewImageView.image = image;
                        [KKMediaPickerWatingView hideForView:weakself.view];
                        
                        [weakself cameraCaptureFinishedWithFilePath:weakself.dataModal.imageFilePath placeHolderImage:nil];
                    });
                }
                else{
                    //回到主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakself.previewImageView.image = image;
                        [KKMediaPickerWatingView hideForView:weakself.view];
                    });
                }
            } else{
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.previewImageView.image = image;
                    [KKMediaPickerWatingView hideForView:weakself.view];
                });
            }
        });

        
    } else {
        [self cameraCaptureFinishedWithFilePath:self.dataModal.movFileFullPath placeHolderImage:nil];
    }}

- (void)startTimer{
    __weak   typeof(self) weakself = self;
    self.recorderAnimationTimer = [NSTimer kkmp_scheduledTimerWithTimeInterval:0.02 block:^{
        [weakself recorderAnimationTimerRunloop];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.recorderAnimationTimer forMode:NSRunLoopCommonModes];
}

- (void)destroyTimer{
    self.timerResult = self.recorderTimerCount;
    self.recorderTimerCount = 0;
    self.recorderAnimationTimerCount = 0;
    [self.recordCircle setProgress:0];
    if (self.recorderAnimationTimer) {
        [self.recorderAnimationTimer invalidate];
        self.recorderAnimationTimer = nil;
    }
}

- (void)recorderTimerRunloop{
    self.recorderTimerCount = self.recorderTimerCount + 1;
    if (self.recorderTimerCount>=KKCameraCapture_TimeMaxCount) {
        [self stopRecord];
    }
}

- (void)recorderAnimationTimerRunloop{
    self.recorderAnimationTimerCount = self.recorderAnimationTimerCount + 1;
    CGFloat allCounts = (KKCameraCapture_TimeMaxCount/0.02);
    CGFloat progress = self.recorderAnimationTimerCount*1.0/allCounts;
    [self.recordCircle setProgress:progress];
    
    self.recorderTimerCount = self.recorderAnimationTimerCount*0.02;
    if (self.recorderTimerCount>=KKCameraCapture_TimeMaxCount) {
        [self stopRecord];
    }
}

#pragma mark ==================================================
#pragma mark == KKCameraCaptureTopBarViewDelegate
#pragma mark ==================================================
/*取消*/
- (void)KKCameraCaptureTopBar_CancelButtonClicked:(KKCameraCaptureTopBar*)topView{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{

    }];
}

/*闪光灯*/
- (void)KKCameraCaptureTopBar:(KKCameraCaptureTopBar*)topView cameraFlashModeButtonClicked:(AVCaptureFlashMode)aCameraFlashMode{
    [self toggleFlashMode:aCameraFlashMode];
}

/*摄像头*/
- (void)KKCameraCaptureTopBar:(KKCameraCaptureTopBar*)topView  cameraDeviceButtonClicked:(AVCaptureDevicePosition)aCameraDevicePositon{
    self.dataModal.captureDevicePosition = aCameraDevicePositon;
    [self toggleCamera:aCameraDevicePositon];
}

/*完成*/
- (void)KKCameraCaptureTopBar_DoneButtonClicked:(KKCameraCaptureTopBar*)topView{

}


#pragma mark ==================================================
#pragma mark == 前后摄像头
#pragma mark ==================================================
// 这是切换镜头的按钮方法
- (void)toggleCamera:(AVCaptureDevicePosition)aCameraDevicePositon{

    AVCaptureDeviceDiscoverySession *captureDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                                                                                                            mediaType:AVMediaTypeVideo
                                                                                                                             position: AVCaptureDevicePositionUnspecified];
    NSArray *captureDevices = [captureDeviceDiscoverySession devices];
    NSUInteger cameraCount = [captureDevices count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[KKCameraHelper cameraVideoWithPosition:aCameraDevicePositon] error:&error];

        if (newVideoInput != nil) {
            [self.captureSession beginConfiguration];
            [self.captureSession removeInput:self.captureDeviceInputVideo];

            if ([self.captureSession canAddInput:newVideoInput]) {
                [self.captureSession addInput:newVideoInput];
                self.captureDeviceInputVideo = newVideoInput;
            }
            else {
                [self.captureSession addInput:self.captureDeviceInputVideo];
            }

            [self.captureSession commitConfiguration];

        }
        else if (error) {
            NSLog(@"toggle carema failed, error = %@", [error localizedDescription]);
        }
    }

}


#pragma mark ==================================================
#pragma mark == 闪光灯
#pragma mark ==================================================
// 这是切换镜头的按钮方法
- (void)toggleFlashMode:(AVCaptureFlashMode)aCaptureFlashMode{

    AVCaptureDevice *device = self.captureDeviceInputVideo.device;
    //修改前必须先锁定
    [device lockForConfiguration:nil];

    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([self.captureDeviceInputVideo.device hasFlash]) {
        if (aCaptureFlashMode == AVCaptureFlashModeOff) {
            self.flashMode = AVCaptureFlashModeOff;
            self.captureDeviceInputVideo.device.torchMode = AVCaptureTorchModeOff;
        }
        else if (aCaptureFlashMode == AVCaptureFlashModeOn) {
            self.flashMode = AVCaptureFlashModeOn;
            self.captureDeviceInputVideo.device.torchMode = AVCaptureTorchModeOn;
        }
        else{
            self.flashMode = AVCaptureFlashModeAuto;
            self.captureDeviceInputVideo.device.torchMode = AVCaptureTorchModeAuto;
        }
    }
    [device unlockForConfiguration];
}

#pragma mark ==================================================
#pragma mark == 聚焦
#pragma mark ==================================================
- (void)focusAction:(UITapGestureRecognizer *)sender{
    CGPoint location = [sender locationInView:self.cameraShowView];
    CGPoint pointInsect = CGPointMake(location.x / self.view.frame.size.width, location.y / self.view.frame.size.height);

    [self.focusView setCenter:location];
    self.focusView.hidden = NO;
    [UIView animateWithDuration:0.45 animations:^{
        self.focusView.alpha = 1.0;
    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.45 animations:^{
            self.focusView.alpha = 0.0;
        }completion:^(BOOL finished) {
            self.focusView.hidden = YES;
        }];
    }];

    if ([self.captureDeviceInputVideo.device isFocusPointOfInterestSupported] && [self.captureDeviceInputVideo.device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        NSError *error;
        if ([self.captureDeviceInputVideo.device lockForConfiguration:&error])
        {
            if ([self.captureDeviceInputVideo.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            {
                [self.captureDeviceInputVideo.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                [self.captureDeviceInputVideo.device setFocusPointOfInterest:pointInsect];
            }

            if([self.captureDeviceInputVideo.device isExposurePointOfInterestSupported] && [self.captureDeviceInputVideo.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [self.captureDeviceInputVideo.device setExposurePointOfInterest:pointInsect];
                [self.captureDeviceInputVideo.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];

            }

            [self.captureDeviceInputVideo.device unlockForConfiguration];
        }
    }

}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{

    if (recognizer.state ==UIGestureRecognizerStateBegan) {

    }
    else if (recognizer.state ==UIGestureRecognizerStateChanged) {
        BOOL allTouchesAreOnThePreviewLayer = YES;
        NSUInteger numTouches = [recognizer numberOfTouches], i;
        for ( i = 0; i < numTouches; ++i ) {
            CGPoint location = [recognizer locationOfTouch:i inView:self.cameraShowView];
            CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
            if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
                allTouchesAreOnThePreviewLayer = NO;
                break;
            }
        }

        if ( allTouchesAreOnThePreviewLayer ) {
            self.effectiveScale = self.beginGestureScale * recognizer.scale;
            if (self.effectiveScale < 1.0){
                self.effectiveScale = 1.0;
            }

            CGFloat maxScaleAndCropFactor = [[self.capturePhotoOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
            CGFloat maxScaleAndCropFactor2 = 10;
            if (self.effectiveScale > maxScaleAndCropFactor)
                self.effectiveScale = maxScaleAndCropFactor;
            if (self.effectiveScale > maxScaleAndCropFactor2)
                self.effectiveScale = maxScaleAndCropFactor2;

            [CATransaction begin];
            [CATransaction setAnimationDuration:.025];
            [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
            [CATransaction commit];

            //设置视频方向
            UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
            AVCaptureVideoOrientation avcaptureOrientation = (AVCaptureVideoOrientation)curDeviceOrientation;
            if (curDeviceOrientation == UIDeviceOrientationLandscapeLeft){
                avcaptureOrientation = AVCaptureVideoOrientationLandscapeRight;
            }else if(curDeviceOrientation == UIDeviceOrientationLandscapeRight){
                avcaptureOrientation = AVCaptureVideoOrientationLandscapeLeft;
            }

            /*========== 图片 ==========*/
            //获取指定连接
            AVCaptureConnection *stillImageConnection = [self.capturePhotoOutput connectionWithMediaType:AVMediaTypeVideo];
            [stillImageConnection setVideoOrientation:avcaptureOrientation];
            [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];

            /*========== 视频 ==========*/
            AVCaptureDevice *captureDevice = self.captureDeviceInputVideo.device;
            if (self.effectiveScale < captureDevice.activeFormat.videoMaxZoomFactor && self.effectiveScale>1){
                NSError *error;
                //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
                if ([captureDevice lockForConfiguration:&error]) {
                    [captureDevice rampToVideoZoomFactor:self.effectiveScale withRate:10];
                    [captureDevice unlockForConfiguration];
                }
                else{
                    NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
                }
            }
        }
    }
    // 当手指离开屏幕时
    else if ((recognizer.state ==UIGestureRecognizerStateEnded) ||
        (recognizer.state ==UIGestureRecognizerStateCancelled)) {
        self.beginGestureScale = self.effectiveScale;
    }
    else{

    }
}

#pragma mark ==================================================
#pragma mark == 主体颜色
#pragma mark ==================================================
/* 子类可重写该方法，不重写的话默认是白色 */
- (UIColor*)kk_DefaultNavigationBarBackgroundColor{
    return [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // TODO:暂时隐藏
//    [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];

    [self setUpCameraLayer];

    [self.dataModal reset];
    self.previewImageView.image = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

#pragma mark ==================================================
#pragma mark == 录像/拍摄完成——跳转到展示界面(或者编辑界面)
#pragma mark ==================================================
- (void)cameraCaptureFinishedWithFilePath:(NSString*)aPath placeHolderImage:(UIImage*)aImage{
    NSString *pathExtention = aPath.pathExtension.lowercaseString;
    //图片
    if ([pathExtention isEqualToString:@"png"]) {
        /* 编辑 */
        UIImage *aImage = [UIImage imageWithContentsOfFile:aPath];
//        [self goEditViewController:aImage];

        /* 不编辑 */
        KKCameraCaptureShowViewController* view = [[KKCameraCaptureShowViewController alloc] initWithDataModal:self.dataModal placholderImage:aImage];
        view.delegate = self;
        [self.navigationController pushViewController:view animated:NO];
    }
    //视频
    else if ([pathExtention isEqualToString:@"mp4"] || [pathExtention isEqualToString:@"mov"]) {
        KKCameraCaptureShowViewController* view = [[KKCameraCaptureShowViewController alloc] initWithDataModal:self.dataModal placholderImage:aImage];
        view.delegate = self;
        [self.navigationController pushViewController:view animated:NO];
    }
    else {

    }
}

#pragma mark ==================================================
#pragma mark == KKCameraCaptureShowDelegate【展示界面，确认完成】
#pragma mark ==================================================
- (void)KKCameraCaptureShowViewController_ClickedOK:(NSString *)aFilepath{
    [self confimFinishedWithFilePath:aFilepath];
}

- (void)confimFinishedWithFilePath:(NSString*)aFilepath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraCaptureViewController_FinishedWithFilaFullPath:fileName:fileExtention:timeDuration:)]) {

        NSString *pathExtention = aFilepath.pathExtension.lowercaseString;
        if ([pathExtention isEqualToString:@"png"]) {
            NSString *fileNameFullOld = [aFilepath lastPathComponent];
            NSString *extention = [fileNameFullOld pathExtension];
            NSString *fileName = nil;
            if (extention) {
                NSString *extentionDel = [NSString stringWithFormat:@".%@",extention];
                NSString *shortName = [fileNameFullOld stringByReplacingOccurrencesOfString:extentionDel withString:@""];
                fileName = shortName;
            } else {
                fileName = fileNameFullOld;
            }


            [self.delegate KKCameraCaptureViewController_FinishedWithFilaFullPath:aFilepath fileName:fileName fileExtention:extention timeDuration:0];
        }
        else if ([pathExtention isEqualToString:@"mp4"] || [pathExtention isEqualToString:@"mov"]) {
            NSString *fileNameFullOld = [aFilepath lastPathComponent];
            NSString *extention = [fileNameFullOld pathExtension];
            NSString *fileName = nil;
            if (extention) {
                NSString *extentionDel = [NSString stringWithFormat:@".%@",extention];
                NSString *shortName = [fileNameFullOld stringByReplacingOccurrencesOfString:extentionDel withString:@""];
                fileName = shortName;
            } else {
                fileName = fileNameFullOld;
            }

            NSString *timeDuration = [NSString stringWithFormat:@"%ld",self.timerResult];

            [self.delegate KKCameraCaptureViewController_FinishedWithFilaFullPath:aFilepath fileName:fileName fileExtention:extention timeDuration:timeDuration];
        }
        else{

        }
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark ==================================================
#pragma mark == 编辑图片
#pragma mark ==================================================
- (void)goEditViewController:(UIImage*)aImage{
//    //第三方图片剪辑
//    KKWeakSelf(self)
//    IJSImageManagerController *managerVc = [[IJSImageManagerController alloc] initWithEditImage:aImage];
//    [managerVc loadImageOnCompleteResult:^(UIImage *image, NSURL *outputPath, NSError *error) {
//        if (image) {
//            NSData *data = UIImageJPEGRepresentation(image, 1.0);
//            if (data && [data writeToFile:weakself.dataModal.imageEditFilePath atomically:YES]) {
//                [weakself confimFinishedWithFilePath:weakself.dataModal.imageEditFilePath];
//            }
//            return YES;
//        } else {
//            return NO;
//        }
//    }];
//    managerVc.mapImageArr = [managerVc defaultEmojiMapArray];
//    managerVc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.navigationController pushViewController:managerVc animated:YES];
}


@end
