//
//  WCRedEnvelopesReceiveHomeView-Hook.m
//  CrackWeChat
//
//  Created by jiangbin on 2018/2/5.
//  红包显示页面，需要手动点击

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CaptainHook.h"
#import "WCRedEnvelopesHelper.h"
#import "LLRedEnvelopesMgr.h"

//Hook的class
CHDeclareClass(WCRedEnvelopesReceiveHomeView);

//Hook的函数
//- (id)initWithFrame:(CGRect)frame andData:(id)data delegate:(id)delegate
CHMethod(3, id, WCRedEnvelopesReceiveHomeView, initWithFrame, CGRect, frame, andData, id, data, delegate, id, delegate)
{
    WCRedEnvelopesReceiveHomeView *view = CHSuper(3, WCRedEnvelopesReceiveHomeView, initWithFrame, frame, andData, data, delegate, delegate);
    if(![LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper) {
        return view;
    }
    
    float randomDelay = ((rand() % 100 + 1) / 100.0) * [LLRedEnvelopesMgr shared].openRedEnvelopesDelaySecond ;
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Red" message:[NSString stringWithFormat:@"Random delay:%0.2f", randomDelay] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomDelay), dispatch_get_main_queue(), ^{
        //打开红包
        [view OnOpenRedEnvelopes];
    });
    
    view.hidden = YES;
    
    return view;
}

//- (void)showSuccessOpenAnimation
CHMethod(0, void, WCRedEnvelopesReceiveHomeView, showSuccessOpenAnimation)
{
    CHSuper(0, WCRedEnvelopesReceiveHomeView, showSuccessOpenAnimation);;
    
    if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper &&
        [UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        [[LLRedEnvelopesMgr shared] successOpenRedEnvelopesNotification];
    }
}

//Hook函数的入口
__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(WCRedEnvelopesReceiveHomeView);
    CHClassHook(3, WCRedEnvelopesReceiveHomeView, initWithFrame, andData, delegate);
    CHClassHook(0, WCRedEnvelopesReceiveHomeView, showSuccessOpenAnimation);
}

