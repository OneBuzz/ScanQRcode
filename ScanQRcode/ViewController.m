//
//  ViewController.m
//  ScanQRcode
//
//  Created by BuzzLightYear23 on 16/2/28.
//  Copyright © 2016年 Irving. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic , weak) AVCaptureSession *session;
@property(nonatomic,  weak) AVCaptureVideoPreviewLayer *layer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ScanQRcode];
    
}

-(void)ScanQRcode{
    
    //1.创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    
    //2.添加输入设备(数据从摄像头输入)
    AVCaptureDevice *device =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];
    
    //3.添加输出设备
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    //设置输入元数据的类型(类型是二维码数据)
    
    //4.添加扫描图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    //5.开始扫描
    [session startRunning];
    
    
    
}

#pragma mark -实现output的回调方法
//当扫描到数据时就会执行该方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if(metadataObjects.count>0){
        //获取扫描的结果,数组中最后一个元素，就是最新的一个数据
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        NSLog(@"%@",object.stringValue);
        
        //停止扫描
        [self.session stopRunning];
        
        //将预览图层移除
        [self.layer removeFromSuperlayer];
        
    }else{
        NSLog(@"没有扫描到数据");
    }
}

@end
