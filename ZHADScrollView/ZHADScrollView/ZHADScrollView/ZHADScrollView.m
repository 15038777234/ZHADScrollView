//
//  ZHADScrollView.m
//  ZHADScrollView
//
//  Created by 张行 on 15/11/13.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ZHADScrollView.h"

@implementation ZHADScrollView {
    
    NSMutableArray *_bannerButtons;
    UIScrollView *_bannerScrollView;
    UIPageControl *_pageControll;
    NSMutableArray<UIImage *> *_bannerCacheImages;
    NSTimer *_bannerTimer;
    NSUInteger _bannerIndex;
    UIButton *_showButton;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self =[super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView{
    //self.backgroundColor =[UIColor redColor];
    _bannerButtons = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = self.bounds;
        button.tag = i;
        [button addTarget:self
                   action:@selector(bannerSelect)
         forControlEvents:UIControlEventTouchUpInside];
        [_bannerButtons addObject:button];
        [_bannerScrollView addSubview:button];
    }
    _bannerScrollView =[[UIScrollView alloc]init];
    _bannerScrollView.frame = self.bounds;
    _bannerScrollView.delegate = self;
    _bannerScrollView.pagingEnabled = YES;
    _bannerScrollView.scrollEnabled = NO;
    
    _pageControll = [[UIPageControl alloc]init];
    
    [self addSubview:_bannerScrollView];
    
    [self addSubview:_pageControll];
    
    _bannerCacheImages = [NSMutableArray array];
    self.timerInterval = 3;
    
}
-(void)awakeFromNib {
    
    [self _initView];
}
- (void)bannerSelect {
    
    if (self.adScrollViewDidiClick) {
        self.adScrollViewDidiClick(self,_bannerIndex);
    }
}
- (void)reloadBannerView {
    
    [_bannerTimer invalidate];
    for (UIButton *button in _bannerButtons) {
        [button removeFromSuperview];
    }
    
    if (self.bannerImages.count > 1) {
        
        _bannerScrollView.contentSize =
        CGSizeMake(CGRectGetWidth(_bannerScrollView.frame)*self.bannerImages.count,
                   CGRectGetHeight(_bannerScrollView.frame));
        _showButton = _bannerButtons[0];
        _showButton.frame = self.bounds;
        [_bannerScrollView addSubview:_showButton];
        [_showButton setBackgroundImage:self.bannerImages[0] forState:UIControlStateNormal];
        _bannerTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval
                                                        target:self
                                                      selector:@selector(scroolBannerImage)
                                                      userInfo:nil
                                                       repeats:YES];
        
        _bannerIndex = 0;
        CGSize size =[_pageControll sizeForNumberOfPages:self.bannerImages.count];
        _pageControll.numberOfPages = self.bannerImages.count;
        _pageControll.frame=CGRectMake(CGRectGetWidth(self.frame)-size.width-20,
                                       CGRectGetHeight(self.frame)-size.height,
                                       size.width,
                                       size.height);
        _pageControll.pageIndicatorTintColor = [UIColor grayColor];
        _pageControll.currentPageIndicatorTintColor = [UIColor redColor];
        
        
        
    }else {
        
        UIButton *button = _bannerButtons[0];
        [button setBackgroundImage:self.bannerImages[0] forState:UIControlStateNormal];
    }
    
}
- (void)scroolBannerImage {
    
    NSUInteger buttonTag = _showButton.tag;
    if (buttonTag <1) {
        buttonTag ++;
    }else {
        
        buttonTag = 0;
    }
    _showButton = _bannerButtons[buttonTag];
    _bannerIndex ++;
    
    if (_bannerIndex == self.bannerImages.count) {
        _bannerIndex = 0;
        _showButton.frame = self.bounds;
    }else {
        
        _showButton.frame =
        CGRectMake(_bannerScrollView.contentOffset.x+CGRectGetWidth(_bannerScrollView.frame),
                   _bannerScrollView.contentOffset.y,
                   CGRectGetWidth(_bannerScrollView.frame),
                   CGRectGetHeight(_bannerScrollView.frame));
        
    }
    [_bannerScrollView addSubview:_showButton];
    [_bannerScrollView setContentOffset:CGPointMake(_bannerIndex*CGRectGetWidth(_bannerScrollView.frame), 0) animated:_bannerIndex==0?(NO):(YES)];
    [_showButton setBackgroundImage:self.bannerImages[_bannerIndex] forState:UIControlStateNormal];
    _pageControll.currentPage = _bannerIndex;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat x=scrollView.contentOffset.x -(_bannerIndex)*CGRectGetWidth(self.frame);
    
    NSUInteger buttonTag = _showButton.tag;
    if (buttonTag <1) {
        buttonTag ++;
    }else {
        
        buttonTag = 0;
    }
    UIButton *button =_bannerButtons[buttonTag];
    if (x>0) {
        ///左
        
        button.frame= CGRectMake(CGRectGetMaxX(_showButton.frame), CGRectGetMinY(_showButton.frame), CGRectGetWidth(_showButton.frame), CGRectGetHeight(_showButton.frame));
        
        
    }else {
        ///右
        button.frame= CGRectMake(CGRectGetMinX(_showButton.frame)-CGRectGetWidth(_showButton.frame), CGRectGetMinY(_showButton.frame), CGRectGetWidth(_showButton.frame), CGRectGetHeight(_showButton.frame));
    }
    
}
-(void)setBannerImageUrls:(NSArray<NSString *> *)bannerImageUrls {
    
    _bannerImageUrls = bannerImageUrls;
    [_bannerCacheImages removeAllObjects];
    __weak typeof(self) weakSelf =self;
    if (bannerImageUrls.count > 0) {
        
        for (NSUInteger i = 0; i<_bannerImageUrls.count ; i++) {
            [self downloadImageFromUrl:[NSURL URLWithString:_bannerImageUrls[i]]
                              complete:
             ^(UIImage *image) {
                 
                 __strong typeof(weakSelf) strongSelf = weakSelf;
                 [_bannerCacheImages addObject:image];
                 strongSelf.bannerImages = _bannerCacheImages;
                 [strongSelf reloadBannerView];
             }];
        }
    }
}
- (void)downloadImageFromUrl:(NSURL *)url complete:(void(^)(UIImage *image))complete {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        if (image) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                complete(image);
            });
        }
    });
    
}
@end
