//
//  Main-Hook.m
//  CrackWeChat
//
//  Created by jiangbin on 2018/2/5.
//

#import "CaptainHook.h"
#import "WCRedEnvelopesHelper.h"
#import "LLRedEnvelopesMgr.h"
#import "LLSettingController.h"


#pragma mark - Hook NewMainFrameViewController
//Hook的class
CHDeclareClass(NewMainFrameViewController);

//Hook的函数
// - (void)viewDidLoad
CHMethod(0, void, NewMainFrameViewController, viewDidLoad)
{
    CHSuper(0, NewMainFrameViewController, viewDidLoad);
    
    [LLRedEnvelopesMgr shared].openRedEnvelopesBlock = ^{
        if([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].haveNewRedEnvelopes){
            [LLRedEnvelopesMgr shared].haveNewRedEnvelopes = NO;
            [LLRedEnvelopesMgr shared].isHongBaoPush = YES;
            [[LLRedEnvelopesMgr shared] openRedEnvelopes:self];
        }
    };
}

// - (void)reloadSessions
CHMethod(0, void, NewMainFrameViewController, reloadSessions)
{
    if([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].openRedEnvelopesBlock){
        [LLRedEnvelopesMgr shared].openRedEnvelopesBlock();
    }
    
    CHSuper(0, NewMainFrameViewController, reloadSessions);
}


#pragma mark - Hook WCRedEnvelopesControlLogic
//Hook的class
CHDeclareClass(WCRedEnvelopesControlLogic);

//Hook的函数
// - (void)startLoading
CHMethod(0, void, WCRedEnvelopesControlLogic, startLoading)
{
    if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper) {
        //隐藏加载菊花
        //do nothing
    } else {
        CHSuper(0, WCRedEnvelopesControlLogic, startLoading);
    }
}

#pragma mark - Hook MicroMessengerAppDelegate
//Hook的class
CHDeclareClass(MicroMessengerAppDelegate);

//Hook的函数
// - (void)applicationWillEnterForeground:(UIApplication *)application
CHMethod(1, void, MicroMessengerAppDelegate, applicationWillEnterForeground, id, application)
{
    CHSuper(1, MicroMessengerAppDelegate, applicationWillEnterForeground, application);
    [[LLRedEnvelopesMgr shared] reset];
}

// - (void)applicationDidEnterBackground:(UIApplication *)application
CHMethod(1, void, MicroMessengerAppDelegate, applicationDidEnterBackground, id, application)
{
    CHSuper(1, MicroMessengerAppDelegate, applicationDidEnterBackground, application);
    [[LLRedEnvelopesMgr shared] enterBackgroundHandler];
}

#pragma mark - Hook MMMsgLogicManager
//Hook的class
CHDeclareClass(MMMsgLogicManager);

//Hook的函数
// - (id)GetCurrentLogicController
CHMethod(0, id, MMMsgLogicManager, GetCurrentLogicController)
{
    if([LLRedEnvelopesMgr shared].logicController) {
        return [LLRedEnvelopesMgr shared].logicController;
    }
    
    return CHSuper(0, MMMsgLogicManager, GetCurrentLogicController);
}

//Hook函数的入口
__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(NewMainFrameViewController);
    CHClassHook(0, NewMainFrameViewController, viewDidLoad);
    CHClassHook(0, NewMainFrameViewController, reloadSessions);
    
    CHLoadLateClass(WCRedEnvelopesControlLogic);
    CHClassHook(0, WCRedEnvelopesControlLogic, startLoading);
    
    CHLoadLateClass(MicroMessengerAppDelegate);
    CHClassHook(1, MicroMessengerAppDelegate, applicationWillEnterForeground);
    CHClassHook(1, MicroMessengerAppDelegate, applicationDidEnterBackground);
    
    CHLoadLateClass(MMMsgLogicManager);
    CHClassHook(0, MMMsgLogicManager, GetCurrentLogicController);
}

