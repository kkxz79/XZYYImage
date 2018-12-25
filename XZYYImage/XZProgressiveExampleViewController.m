//
//  XZProgressiveExampleViewController.m
//  XZYYImage
//
//  Created by kkxz on 2018/12/25.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "XZProgressiveExampleViewController.h"
#import <YYImage/YYImage.h>
#import "UIView+YYAdd.h"
#import "UIControl+YYAdd.h"

@interface NSData(YYAdd)
@end

@implementation NSData(YYAdd)
+(NSData*)dataNamed:(NSString*)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    if(!path){
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

@end

@interface XZProgressiveExampleViewController () {
    UIImageView *_imageView;
    UISegmentedControl *_seg0;
    UISegmentedControl *_seg1;
    UISlider *_slider0;
    UIButton *_decodeBtn;
    UIButton *_encodeBtn;
}

@end

@implementation XZProgressiveExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [UIImageView new];
    _imageView.size = CGSizeMake(300, 300);
    _imageView.backgroundColor = [UIColor colorWithWhite:0.790 alpha:1.000];
    _imageView.centerX = self.view.width / 2;
    
    _seg0 = [[UISegmentedControl alloc] initWithItems:@[@"baseline",@"progressive/interlaced"]];
    _seg0.selectedSegmentIndex = 0;
    _seg0.size = CGSizeMake(_imageView.width, 30);
    _seg0.centerX = self.view.width / 2;
    
    _seg1 = [[UISegmentedControl alloc] initWithItems:@[@"JPEG",@"PNG",@"GIF"]];
    _seg1.frame = _seg0.frame;
    _seg1.selectedSegmentIndex = 0;
    
    _slider0 = [UISlider new];
    _slider0.width = _seg0.width;
    _slider0.minimumValue = 0;
    _slider0.maximumValue = 1.05;
    _slider0.value = 0;
    _slider0.centerX = self.view.width / 2;
    
    _decodeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _decodeBtn.size = CGSizeMake(100, 30);
    _decodeBtn.centerX = self.view.width / 2;
    [_decodeBtn addTarget:self action:@selector(decodeClick) forControlEvents:UIControlEventTouchUpInside];
    [_decodeBtn setTitle:@"图片解码" forState:UIControlStateNormal];
    
    _encodeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _encodeBtn.size = CGSizeMake(100, 30);
    _encodeBtn.centerX = self.view.width / 2;
    [_encodeBtn addTarget:self action:@selector(encodeClick) forControlEvents:UIControlEventTouchUpInside];
    [_encodeBtn setTitle:@"图片编码" forState:UIControlStateNormal];
    
    _imageView.top = 64 + 10;
    _seg0.top = _imageView.bottom + 10;
    _seg1.top = _seg0.bottom + 10;
    _slider0.top = _seg1.bottom + 10;
    _decodeBtn.top = _slider0.bottom + 10;
    _encodeBtn.top = _decodeBtn.bottom + 10;
    
    [self.view addSubview:_imageView];
    [self.view addSubview:_seg0];
    [self.view addSubview:_seg1];
    [self.view addSubview:_slider0];
    [self.view addSubview:_decodeBtn];
    [self.view addSubview:_encodeBtn];
    
    __weak typeof (self)_self = self;
    [_seg0 addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
        [_self changed];
    }];
    [_seg1 addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
        [_self changed];
    }];
    [_slider0 addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
        [_self changed];
    }];
}

-(void)changed {
    NSString *name = nil;
    if(0==_seg0.selectedSegmentIndex){
        if(0==_seg1.selectedSegmentIndex){
            name = @"mew_baseline.jpg";
        } else if (1 == _seg1.selectedSegmentIndex){
            name = @"mew_baseline.png";
        } else {
            name = @"mew_baseline.gif";
        }
    } else {
        if(0==_seg1.selectedSegmentIndex){
            name = @"mew_progressive.jpg";
        }else if (1 == _seg1.selectedSegmentIndex){
            name = @"mew_interlaced.png";
        } else {
            name = @"mew_interlaced.gif";
        }
    }
    
    NSData *data = [NSData dataNamed:name];
    float  progress = _slider0.value;
    if(progress > 1){
        progress = 1;
    }
    NSData *subData = [data subdataWithRange:NSMakeRange(0, data.length*progress)];
    
    YYImageDecoder *decoder = [[YYImageDecoder alloc] initWithScale:[UIScreen mainScreen].scale];
    [decoder updateData:subData final:NO];
    
    YYImageFrame *frame = [decoder frameAtIndex:0 decodeForDisplay:YES];
    _imageView.image = frame.image;
    
}

///图片解码
-(void)decodeClick {
    NSData *data = [NSData dataNamed:@"niconiconi@2x.gif"];
    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:2.0];
    UIImage *image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
    _imageView.image = image;
}

///图片编码
-(void)encodeClick {
    // 编码静态图 (支持各种常见图片格式)
    YYImage *image = [YYImage imageNamed:@"cube"];
    YYImageEncoder * pngEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypePNG];
    pngEncoder.quality = 0.9;
    [pngEncoder addImage:image duration:0];
    NSData *pngData = [pngEncoder encode];
    NSLog(@"pngData：%@",pngData);

    // 编码动态图 (支持 GIF/APNG/WebP)
    YYImageEncoder * webpEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeWebP];
    webpEncoder.loopCount = 5;
    YYImage *imag = [YYImage imageNamed:@"google"];
    [webpEncoder addImage:imag duration:0.1];
    NSData *webpData = [webpEncoder encode];
    NSLog(@"webpData：%@",webpData);
    //解码
    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:webpData scale:2.0];
    UIImage *im = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
    _imageView.image = im;
    
    //图片类型获取
    CFDataRef cfData = CFBridgingRetain(webpData);
    YYImageType type = YYImageDetectType(cfData);
    NSLog(@"type : %ld",type);
    
}

@end
