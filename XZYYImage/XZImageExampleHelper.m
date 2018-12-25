//
//  XZImageExampleHelper.m
//  XZYYImage
//
//  Created by kkxz on 2018/12/25.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "XZImageExampleHelper.h"
#import <YYImage/YYImage.h>
#import "UIView+YYAdd.h"
#import "UIGestureRecognizer+YYAdd.h"
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>

@implementation XZImageExampleHelper
+(void)addTapControlToAnimatedImageView:(YYAnimatedImageView *)view {
    if(!view) return;
    view.userInteractionEnabled = YES;
    __weak typeof (view)_view = view;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        if([_view isAnimating]){
            [_view stopAnimating];
        }else{
            [_view startAnimating];
        }
        
        //add a "bounce" animation
        UIViewAnimationOptions op = UIViewAnimationOptionCurveEaseInOut
                                                    | UIViewAnimationOptionAllowAnimatedContent
                                                    | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
            [_view.layer setValue:@(0.97) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                [_view.layer setValue:@(1.008) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                    [_view.layer setValue:@(1) forKeyPath:@"transform.scale"];
                } completion:NULL];
            }];
        }];
    }];
    [view addGestureRecognizer:tap];
}

+(void)addPanControlToAnimatedImageView:(YYAnimatedImageView *)view {
    if(!view) return;
    view.userInteractionEnabled = YES;
    __weak typeof (view) _view = view;
    __block BOOL previouslsPlaying;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        UIImage<YYAnimatedImage>*image = (id)_view.image;
        if(![image conformsToProtocol:@protocol(YYAnimatedImage)]){
            return;
        }
        UIPanGestureRecognizer *gesture = sender;
        CGPoint p = [gesture locationInView:gesture.view];
        CGFloat progress = p.x / gesture.view.width;
        if(gesture.state == UIGestureRecognizerStateBegan){
            previouslsPlaying = [_view isAnimating];
            [_view stopAnimating];
            _view.currentAnimatedImageIndex = image.animatedImageFrameCount * progress;
        } else if (gesture.state == UIGestureRecognizerStateEnded ||
                    gesture.state == UIGestureRecognizerStateCancelled) {
            if(previouslsPlaying){
                [_view startAnimating];
            }
        } else {
            _view.currentAnimatedImageIndex = image.animatedImageFrameCount * progress;
        }
    }];
    [view addGestureRecognizer:pan];
}
@end
