//
//  UIView+Util.m
//  SleepPillow
//
//  Created by 张庆玉 on 25/05/2017.
//  Copyright © 2017 MWellness. All rights reserved.
//

#import "UIView+Util.h"

@implementation UIView (Util)

+ (instancetype)getXIBView {
    NSString *xibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] firstObject];
}

/**
 *  设置边框宽度
 *
 *  @param borderWidth 可视化视图传入的值
 */
- (void)setBorderWidth:(CGFloat)borderWidth {
    
    if (borderWidth < 0) return;
    
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

/**
 *  设置边框颜色
 *
 *  @param borderColor 可视化视图传入的值
 */
- (void)setBorderColor:(UIColor *)borderColor {
    
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    UIColor *color = [UIColor colorWithCGColor:self.layer.borderColor];;
    return color;
}

/**
 *  设置圆角
 *
 *  @param cornerRadius 可视化视图传入的值
 */
- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}


- (void)setBorderCornerWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius {
    borderColor = borderColor == nil ? [UIColor clearColor] : borderColor;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
    [self clipsToBounds];
}


// 圆形
- (void)setCircleCorner {
    CGFloat radius = CGRectGetWidth(self.frame) / 2;
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    [self clipsToBounds];
}

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 添加平均分布的子视图
 
 @param subViews 子视图集合
 @param rows 行数
 @param ranks 列数
 */
- (void)constrainSubViewsAverage:(NSArray *)subViews rows:(int)rows ranks:(int)ranks {
    CGFloat rowNum = rows;
    CGFloat colNum = ranks;
    
    NSInteger count = subViews.count;
    
    CGFloat widthMultiplier = 1 / colNum;
    CGFloat heithMultiplier = 1 / rowNum;
    for (int i = 0; i < count; i++) {
        int row = i / ranks;
        int col = i % ranks;
        UIView *view = [subViews objectAtIndex:i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *widthCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:widthMultiplier constant:0.0];
        NSLayoutConstraint *heightCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:heithMultiplier constant:0.0];
        NSLayoutConstraint *leftCon;
        if (col == 0) {
            leftCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        } else {
            leftCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:col * widthMultiplier constant:0.0];
        }
        NSLayoutConstraint *topCon;
        if (row == 0) {
            topCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        } else {
            topCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:row * heithMultiplier constant:0.0];
        }
        [self addSubview:view];
        [self addConstraints:@[widthCon, heightCon, leftCon, topCon]];
    }
}

/**
 添加平均分布的子视图
 
 @param subViews 子视图集合
 @param rows 行数
 @param ranks 列数
 @param rowMargin 行间距
 @param rankMargin 列间距
 */
- (void)constrainSubViewsAverage:(NSArray *)subViews rows:(int)rows ranks:(int)ranks rowMargin:(float)rowMargin rankMargin:(float)rankMargin {
    
    NSInteger count = subViews.count;
    if (count == 0) {
        return;
    }
    
    for (int i = 0; i < count; i++) {
        UIView *view = [subViews objectAtIndex:i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        if (!view.superview) {
            [self addSubview:view];
        } else if (view.superview != self) {
            [view removeFromSuperview];
            [self addSubview:view];
        }
        
        int row = i / ranks;
        int col = i % ranks;
        
        // 水平约束
        if (col == 0) { // 第一列
            NSLayoutConstraint *leftCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
            [self addConstraint:leftCon];
        }
        if ((i + 1) < count && (i + 1)/ranks == row) { // 同一行
            UIView *aftereView = [subViews objectAtIndex:i + 1];
            NSLayoutConstraint *leftCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:aftereView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-rankMargin];
            NSLayoutConstraint *widthCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:aftereView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
            [self addConstraint:leftCon];
            [self addConstraint:widthCon];
        }
        
        
        if ((col + 1) == ranks) { // 最后一列
            NSLayoutConstraint *rightCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
            [self addConstraint:rightCon];
        }
        
        // 垂直约束
        if (row == 0) { // 第一行
            NSLayoutConstraint *topCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            [self addConstraint:topCon];
        }
        if ((i + ranks) < count && (i + ranks) % ranks == col) { // 同一列
            UIView *aftereView = [subViews objectAtIndex:i + ranks];
            NSLayoutConstraint *topCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:aftereView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-rowMargin];
            NSLayoutConstraint *heightCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:aftereView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
            [self addConstraint:topCon];
            [self addConstraint:heightCon];
        }
        if ((row  + 1) == rows) {
            NSLayoutConstraint *bottomCon = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            [self addConstraint:bottomCon];
        }
    }
}




















- (void)setX_qy:(CGFloat)x_qy {
    CGRect frame = self.frame;
    frame.origin.x = x_qy;
    self.frame = frame;
}

- (void)setY_qy:(CGFloat)y_qy {
    CGRect frame = self.frame;
    frame.origin.y = y_qy;
    self.frame = frame;
}

- (void)setW_qy:(CGFloat)w_qy {
    CGRect frame = self.frame;
    frame.size.width = w_qy;
    self.frame = frame;
}

- (void)setH_qy:(CGFloat)h_qy {
    CGRect frame = self.frame;
    frame.size.height = h_qy;
    self.frame = frame;
}

- (void)setSize_qy:(CGSize)size_qy {
    CGRect frame = self.frame;
    frame.size = size_qy;
    self.frame = frame;
}

- (void)setOrigin_qy:(CGPoint)origin_qy {
    CGRect frame = self.frame;
    frame.origin = origin_qy;
    self.frame = frame;
}

- (CGFloat)x_qy {
    return self.frame.origin.x;
}

- (CGFloat)y_qy {
    return self.frame.origin.y;
}

- (CGFloat)w_qy {
    return self.frame.size.width;
}

- (CGFloat)h_qy {
    return self.frame.size.height;
}

- (CGSize)size_qy {
    return self.frame.size;
}

- (CGPoint)origin_qy {
    return self.frame.origin;
}

- (void)setHorizontalGradientBackColorWithStartColor:(UIColor *)startColor EndColor:(UIColor *)endColor frame:(CGRect)frame {
    
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMinY(rect));
    CGPathCloseSubpath(path);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGPathRelease(path);
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    for (UIView *imgView in self.subviews) {
        if (imgView.tag == 1000) {
            [imgView removeFromSuperview];
            break;
        }
    }
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.tag = 1000;
    [self insertSubview:imgView atIndex:0];
    
}


@end















