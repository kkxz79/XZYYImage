//
//  XZImageExampleHelper.h
//  XZYYImage
//
//  Created by kkxz on 2018/12/25.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYAnimatedImageView;
NS_ASSUME_NONNULL_BEGIN

@interface XZImageExampleHelper : NSObject
///Tap to play/pause
+(void)addTapControlToAnimatedImageView:(YYAnimatedImageView *)view;
///Slide to forward/rewind
+(void)addPanControlToAnimatedImageView:(YYAnimatedImageView *)view;
@end

NS_ASSUME_NONNULL_END
