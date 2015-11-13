//
//  ViewController.m
//  ZHADScrollView
//
//  Created by 张行 on 15/11/13.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ViewController.h"
#import "ZHADScrollView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet ZHADScrollView *adScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adScrollView.bannerImageUrls = @[@"http://h.hiphotos.baidu.com/image/w%3D400/sign=11a7c428af6eddc426e7b5fb09dab6a2/b64543a98226cffc0144557fbb014a90f703ea95.jpg",@"http://d.hiphotos.baidu.com/image/w%3D400/sign=34c9b31d05082838680ddd148898a964/730e0cf3d7ca7bcb19f0df2dbc096b63f624a82c.jpg",@"http://b.hiphotos.baidu.com/image/w%3D400/sign=38eb58d974094b36db921aed93cc7c00/5d6034a85edf8db1c255da620b23dd54564e74b8.jpg",@"http://f.hiphotos.baidu.com/image/w%3D400/sign=2fcfc9090ed79123e0e095749d345917/ae51f3deb48f8c5471a15c2e38292df5e0fe7f45.jpg",@"http://f.hiphotos.baidu.com/image/w%3D400/sign=1466981da344ad342ebf8687e0a30c08/8d5494eef01f3a29a8b0ef3e9b25bc315d607cc1.jpg"];
//    self.adScrollView.bannerImages = @[[UIImage imageNamed:@"1.jpg"],
//                                       [UIImage imageNamed:@"2.jpg"],
//                                       [UIImage imageNamed:@"3.jpg"],
//                                       [UIImage imageNamed:@"4.jpg"]];
    [self.adScrollView reloadBannerView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
