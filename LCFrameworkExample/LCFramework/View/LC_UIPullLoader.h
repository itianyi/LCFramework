//
//  UIPullLoader.h
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-17.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "LC_UIActivityIndicatorView.h"

typedef enum _LC_PULL_DIRETION {

    LC_PULL_DIRETION_TOP    = 0,
    LC_PULL_DIRETION_BUTTOM = 1,

} LC_PULL_DIRETION;

typedef enum _LC_PULL_BACK_GROUND_STYLE {
    
    LC_PULL_BACK_GROUND_STYLE_CUSTOM   = 0, //当为自定义时可以手动设置背景以及箭头图片
    LC_PULL_BACK_GROUND_STYLE_COLORFUL = 1
    
} LC_PULL_BACK_GROUND_STYLE;

typedef enum _LC_PULL_STYLE {
    
    LC_PULL_STYLE_HEADER             = 0, 
    LC_PULL_STYLE_FOOTER             = 1,
    LC_PULL_STYLE_HEADER_AND_FOOTER  = 2,
    LC_PULL_STYLE_NULL               = 3,
    
} LC_PULL_STYLE;

@class LC_UIPullLoader;

typedef void (^LCUIPulldidRefreshBlock)( LC_UIPullLoader * pull , LC_PULL_DIRETION diretion );

@interface LC_UIPullLoader : NSObject

@property (nonatomic,copy) LCUIPulldidRefreshBlock beginRefreshBlock;

@property (nonatomic,assign) UIScrollView * scrollView;

@property (nonatomic,assign) BOOL canLoadMore;

@property (readonly) LC_PULL_STYLE             pullStyle;
@property (readonly) LC_PULL_BACK_GROUND_STYLE backGroundStyle;

+ (id) pullLoaderWithScrollView:(UIScrollView *)scrollView
                      pullStyle:(LC_PULL_STYLE)pullStyle
                backGroundStyle:(LC_PULL_BACK_GROUND_STYLE)backGroundStyle;

- (id) initWithScrollView:(UIScrollView *)scrollView
                pullStyle:(LC_PULL_STYLE)pullStyle
          backGroundStyle:(LC_PULL_BACK_GROUND_STYLE)backGroundStyle;

- (id) initWithWeakScrollView:(UIScrollView *)scrollView
                    pullStyle:(LC_PULL_STYLE)pullStyle
              backGroundStyle:(LC_PULL_BACK_GROUND_STYLE)backGroundStyle;

- (void) startRefresh;
- (void) endRefresh;
- (void) endRefreshWithAnimated:(BOOL)animated;

@end
