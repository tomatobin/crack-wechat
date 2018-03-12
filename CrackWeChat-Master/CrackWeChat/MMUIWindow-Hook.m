//
//  MMUIWindow-Hook.m
//  CrackWeChat
//
//  Created by jiangbin on 2018/2/5.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CaptainHook.h"
#import "WCRedEnvelopesHelper.h"
#import "LLRedEnvelopesMgr.h"

//Hook的class
CHDeclareClass(MMUIWindow);

//Hook的函数
// - (void)addSubview:(UIView *)subView
CHMethod(1, void, MMUIWindow, addSubview, id, subView)
{
    if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper &&
        [subView isKindOfClass:NSClassFromString(@"WCRedEnvelopesReceiveHomeView")]) {
        //Todo::隐藏弹出红包领取完成页面所在window
        //((UIView *)self).hidden = YES;
    } else {
        CHSuper(1, MMUIWindow, addSubview, subView);
    }
}

//Hook函数的入口
__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(MMUIWindow);
    CHClassHook(1, MMUIWindow, addSubview);
}

