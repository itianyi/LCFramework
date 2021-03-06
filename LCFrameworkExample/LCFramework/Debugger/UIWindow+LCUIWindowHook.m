//
//  LC_ViewInspector.h
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-10-9.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "UIWindow+LCUIWindowHook.h"

#if defined(LC_DEBUG_ENABLE) && LC_DEBUG_ENABLE

@interface LC_WindowHookIndicator : UIView

- (void)startAnimation;

@end

@implementation LC_WindowHookIndicator

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;
		self.userInteractionEnabled = NO;
	}
	return self;
}

- (void)startAnimation
{
	self.alpha = 1.0f;
	self.transform = CGAffineTransformMakeScale( 0.5f, 0.5f );
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationStopped)];
	
	self.alpha = 0.0f;
	self.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}

- (void)didAppearingAnimationStopped
{
	[self removeFromSuperview];
}

@end

@interface LC_WindowHookBorder : UIView

- (void)startAnimation;

@end

@implementation LC_WindowHookBorder

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		self.layer.borderWidth = 2.0f;
		self.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.7].CGColor;
        //		self.textColor = [UIColor redColor];
        //		self.textAlignment = UITextAlignmentCenter;
        //		self.font = [UIFont boldSystemFontOfSize:12.0f];
	}
	return self;
}

- (void)didMoveToSuperview
{
	[super didMoveToSuperview];
	
	self.layer.cornerRadius = self.superview.layer.cornerRadius;
}

- (void)startAnimation
{
	self.alpha = 1.0f;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationStopped)];
	
	self.alpha = 0.0f;
    
	[UIView commitAnimations];
}

- (void)didAppearingAnimationStopped
{
	[self removeFromSuperview];
}

- (void)dealloc
{
	[super dealloc];
}


@end

@implementation UIWindow (LCUIWindowHook)

static BOOL	__printfTouchView = NO;
static BOOL	__blocked = NO;
static void (*__sendEvent)( id, SEL, UIEvent * );

+ (void)hook
{
	static BOOL __swizzled = NO;
    
	if ( NO == __swizzled )
	{
		Method method;
		IMP implement;
        
		method = class_getInstanceMethod( [UIWindow class], @selector(sendEvent:) );
		__sendEvent = (void *)method_getImplementation( method );
		
		implement = class_getMethodImplementation( [UIWindow class], @selector(mySendEvent:) );
		method_setImplementation( method, implement );
		
		__swizzled = YES;
	}
}

+ (void)block:(BOOL)flag
{
	__blocked = flag;
}

- (void) mySendEvent:(UIEvent *)event
{
	UIWindow * keyWindow = [LC_UIApplication sharedInstance].window;
    
    if (self == keyWindow) {
        
        if ( UIEventTypeTouches == event.type )
        {
            NSSet * allTouches = [event allTouches];
            
            if ( 1 == [allTouches count] )
            {
                UITouch * touch = [[allTouches allObjects] objectAtIndex:0];
                
                if ( 1 == [touch tapCount] )
                {
                    if ( UITouchPhaseBegan == touch.phase )
                    {
                        if (__printfTouchView == YES) {
                            
                            INFO( @"Touch view : %@, frame : %@, superview : %@", [touch.view class], NSStringFromCGRect(touch.view.frame),touch.view.superview ? touch.view.superview.class : @"none");
                        }
                        
                        LC_WindowHookBorder * border = [LC_WindowHookBorder new];
                        border.frame = touch.view.bounds;
                        [touch.view addSubview:border];
                        [border startAnimation];
                        [border release];
                    }
                    else if ( UITouchPhaseMoved == touch.phase )
                    {
                    }
                    else if ( UITouchPhaseEnded == touch.phase || UITouchPhaseCancelled == touch.phase )
                    {
                        LC_WindowHookIndicator * indicator = [LC_WindowHookIndicator new];
						indicator.frame = CGRectMake( 0, 0, 50.0f, 50.0f );
						indicator.center = [touch locationInView:keyWindow];
						[keyWindow addSubview:indicator];
						[indicator startAnimation];
						[indicator release];
                    }
                }
            }
        }
        
    }
    
	if ( NO == __blocked )
	{
		if ( __sendEvent )
		{
			__sendEvent( self, _cmd, event );
		}
	}
}


@end

#endif

