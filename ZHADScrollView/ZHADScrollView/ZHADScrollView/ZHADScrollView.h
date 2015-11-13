//
//  ZHADScrollView.h
//  ZHADScrollView
//
//  Created by 张行 on 15/11/13.
//  Copyright © 2015年 张行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHADScrollView : UIView<UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame;
//设置本地的图片
@property (nonatomic, strong) NSArray<UIImage *> *bannerImages;
///设置多少秒切换图片 默认为3秒
@property (nonatomic, assign) NSUInteger timerInterval;
///网络图片地址 设置将取代本地图片
@property (nonatomic, strong) NSArray<NSString *> *bannerImageUrls;
///点击广告图的回调
@property (nonatomic, copy) void(^adScrollViewDidiClick)(ZHADScrollView *adView,NSUInteger index);
///重新刷新
- (void)reloadBannerView;


@end
