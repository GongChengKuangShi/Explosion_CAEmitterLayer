//
//  BowButton.m
//  TheExplosionButton
//
//  Created by xrh on 2017/11/6.
//  Copyright © 2017年 xrh. All rights reserved.
//

//http://blog.csdn.net/xlawszero/article/details/52065495

/*
 emitterCells：CAEmitterCell对象的数组，被用于把粒子投放到layer上
 
 birthRate:可以通俗的理解为发射源的个数，默认1.0。当前每秒产生的真实粒子数为=CAEmitterLayer的birthRate*子粒子的birthRate；
 
 lifetime
 
 emitterPosition，emitterZposition: The center of the emission shape. Defaults to (0, 0, 0). 发射源形状的中心。
 emitterZposition:发射源的z坐标位置；
 
 emitterSize
 
 emitterDepth:决定粒子形状的深度
 
 emitterShape:发射源的形状：
 NSString * const kCAEmitterLayerPoint;
 NSString * const kCAEmitterLayerLine;
 NSString * const kCAEmitterLayerRectangle;
 NSString * const kCAEmitterLayerCuboid;
 NSString * const kCAEmitterLayerCircle;
 NSString * const kCAEmitterLayerSphere;
 
 emitterMode:发射模式
 NSString * const kCAEmitterLayerPoints;
 NSString * const kCAEmitterLayerOutline;
 NSString * const kCAEmitterLayerSurface;
 NSString * const kCAEmitterLayerVolume;
 
 
 
 renderMode:渲染模式：
 NSString * const kCAEmitterLayerUnordered;
 NSString * const kCAEmitterLayerOldestFirst;
 NSString * const kCAEmitterLayerOldestLast;
 NSString * const kCAEmitterLayerBackToFront;
 NSString * const kCAEmitterLayerAdditive;
 
 velocity:粒子速度
 
 scale:粒子的缩放比例
 
 
 
 CAEmitterCell
 
 
 
 name：粒子的名字
 enabled：粒子是否被渲染
 birthRate：每秒钟产生的粒子数量，默认是0.
 lifetime：每一个粒子的生存周期多少秒
 lifetimeRange：生命周期变化范围      lifetime= lifetime(+/-) lifetimeRange
 emissionLatitude：发射的z轴方向的角度
 emissionLongitude:x-y平面的发射方向
 emissionRange；周围发射角度变化范围
 velocity：每个粒子的速度
 velocityRange：每个粒子的速度变化范围
 xAcceleration:粒子x方向的加速度分量
 yAcceleration:粒子y方向的加速度分量
 zAcceleration:粒子z方向的加速度分量
 scale：整体缩放比例（0.0~1.0）
 scaleRange：缩放比例变化范围
 scaleSpeed：缩放比例变化速度
 spin：每个粒子的旋转角度，默认为0
 spinRange：每个粒子的旋转角度变化范围
 color:每个粒子的颜色
 redRange：一个粒子的颜色red 能改变的范围；
 redSpeed; 粒子red在生命周期内的改变速度；
 blueRange: 一个粒子的颜色blue 能改变的范围；
 blueSpeed: 粒子blue在生命周期内的改变速度；
 greenrange: 一个粒子的颜色green 能改变的范围；
 greenSpeed: 粒子green在生命周期内的改变速度；
 alphaRange: 一个粒子的颜色alpha能改变的范围；
 alphaSpeed: 粒子透明度在生命周期内的改变速度
 contents：是个CGImageRef的对象,既粒子要展现的图片；
 contentsRect：应该画在contents里的子rectangle：--
 magnificationFilter：不是很清楚好像增加自己的大小-
 minificatonFilter：减小自己的大小--
 minificationFilterBias：减小大小的因子--
 emitterCells 子粒子
 emitterCells：粒子发射的粒子
 */

#import "BowButton.h"

@implementation BowButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setSelfView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setSelfView];
    }
    return self;
}

- (void)setSelfView {
    [self addTarget:self action:@selector(boom:) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = [UIColor redColor];
    self.layer.cornerRadius = self.frame.size.width / 2;
}

- (void)boom:(UIButton *)sender {
    
    //提供一个基于CoreAnimation的粒子发射系统，粒子用CAEmitterCell来初始化
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    
    [emitter setEmitterSize:CGSizeMake(CGRectGetWidth(sender.frame), CGRectGetHeight(sender.frame))];
    emitter.emitterPosition = CGPointMake(sender.frame.size.width / 2.0f, sender.frame.size.height / 2.0f);//发射源形状的中心。
    emitter.emitterShape = kCAEmitterLayerCircle;//发射源的形状：
    emitter.emitterMode  = kCAEmitterLayerOutline;//发射模式
    emitter.renderMode   = kCAEmitterLayerBackToFront;//渲染模式
    [sender.layer addSublayer:emitter];
    
    
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    [cell setName:@"zanShape"];//这个是当effectCell存在caeEmitter 的emitterCells中用来辨认的。用到setValue forKeyPath比较有用
    
    cell.contents = (__bridge id _Nullable)([self createImageWithColor:[UIColor redColor]].CGImage);//这个和CALayer一样，只是用来设置图片
    cell.birthRate = 100;//每秒某个点产生的effectCell数量。默认是0.
    cell.lifetime  = 6;//表示effectCell的生命周期，既在屏幕上的显示时间要多长
    cell.alphaSpeed = -2;//一个粒子的颜色alpha能改变的范围；
    cell.velocity = 0.5;//velocity & velocityRange & emissionRange 表示cell向屏幕右边飞行的速度 & 在右边什么范围内飞行& ＋－角度扩散
    cell.velocityRange = 200;//每个粒子的速度变化范围
    emitter.emitterCells = @[cell];//粒子发射的粒子
    
    CABasicAnimation *effectLayerAnimation = [CABasicAnimation animationWithKeyPath:@"emitterCells.zanShape.birthRate"];
    [effectLayerAnimation setFromValue:[NSNumber numberWithFloat:1500]];
    [effectLayerAnimation setToValue:[NSNumber numberWithFloat:0]];
    [effectLayerAnimation setDuration:0.0f];
    [effectLayerAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [emitter addAnimation:effectLayerAnimation forKey:@"ZanCount"];
    
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    //开启上下文
    UIGraphicsBeginImageContext(rect.size);
    //获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //给上下文填充颜色
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文。
    
    return [self circleImage:theImage];
}

- (UIImage *)circleImage:(UIImage *)image {
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
