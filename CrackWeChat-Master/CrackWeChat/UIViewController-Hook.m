//
//  UIViewController-Hook.m
//  CrackWeChat
//
//  Created by jiangbin on 2018/2/5.
//

#import "CaptainHook.h"
#import "WCRedEnvelopesHelper.h"
#import "LLRedEnvelopesMgr.h"

//Hook的class
CHDeclareClass(UINavigationController);

//Hook的函数
// - (void)PushViewController:(id)arg1 animated:(_Bool)arg2;
CHMethod(2, void, UINavigationController, PushViewController, id, viewController, animated, BOOL, animated)
{
    if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper &&
        [LLRedEnvelopesMgr shared].isHongBaoPush &&
        [viewController isMemberOfClass:NSClassFromString(@"BaseMsgContentViewController")]) {
        [LLRedEnvelopesMgr shared].isHongBaoPush = NO;
        [[LLRedEnvelopesMgr shared] handleRedEnvelopesPushVC:(BaseMsgContentViewController *)viewController];
    } else {
        CHSuper(2, UINavigationController, PushViewController, viewController, animated, animated);
    }
}


CHDeclareClass(UIViewController);

//Hook的函数
// - (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
CHMethod(3, void, UIViewController, presentViewController, id, viewControllerToPresent, animated, BOOL, animated, completion, id, completion)
{
    LLRedEnvelopesMgr *manager = [LLRedEnvelopesMgr shared];
    if (manager.isOpenRedEnvelopesHelper &&
        [viewControllerToPresent isKindOfClass:NSClassFromString(@"MMUINavigationController")])
    {
        UINavigationController *navController = (UINavigationController *)viewControllerToPresent;
        if (navController.viewControllers.count > 0)
        {
            if ([navController.viewControllers[0] isKindOfClass:NSClassFromString(@"WCRedEnvelopesRedEnvelopesDetailViewController")]){
                //模态红包详情视图
                if([manager isMySendMsgWithMsgWrap:manager.msgWrap]){
                    //领取的是自己发的红包,不自动回复和自动留言
                    return;
                }
                
                if(manager.isOpenAutoReply && [self isMemberOfClass:NSClassFromString(@"BaseMsgContentViewController")]){
                    BaseMsgContentViewController *baseMsgVC = (BaseMsgContentViewController *)self;
                    [baseMsgVC AsyncSendMessage:manager.autoReplyText];
                }
                
                if(manager.isOpenAutoLeaveMessage)
                {
                    WCRedEnvelopesReceiveControlLogic *redEnvelopeLogic = [navController.viewControllers[0] valueForKey:@"m_delegate"];
                    [redEnvelopeLogic OnCommitWCRedEnvelopes:manager.autoLeaveMessageText];
                }
                return;
            }
        }
    }
    
    CHSuper(3, UIViewController, presentViewController, viewControllerToPresent, animated, animated, completion, completion);
}

//Hook函数的入口
__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(UINavigationController);
    CHClassHook(2, UINavigationController, PushViewController, animated);
    
    CHLoadLateClass(UIViewController);
    CHClassHook(3, UIViewController, presentViewController, animated, completion);
}

