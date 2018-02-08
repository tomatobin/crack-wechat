//
//  CMessageMgr-Hook.m
//  CrackWeChat
//
//  Created by jiangbin on 2018/2/5.
//

#import "CaptainHook.h"
#import "LLRedEnvelopesMgr.h"

//Hook的class
CHDeclareClass(CMessageMgr);

//Hook的函数
//- (void)onRevokeMsg:(id)message 
CHMethod(1, void, CMessageMgr, onRevokeMsg, id, message)
{
    if([LLRedEnvelopesMgr shared].isOpenAvoidRevokeMessage){
        return;
    }
    
    CHSuper(1, CMessageMgr, onRevokeMsg, message);
}

// - (void)AsyncOnAddMsg:(NSString *)from MsgWrap:(id)msgWrap;
CHMethod(2, void, CMessageMgr, AsyncOnAddMsg, id, from, MsgWrap, id, msgWrap)
{
    CHSuper(2, CMessageMgr, AsyncOnAddMsg, from, MsgWrap, msgWrap);

    if([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper){
        //CMessageWrap *msgWrap = ext[@"3"];
        [[LLRedEnvelopesMgr shared] handleMessageWithMessageWrap:msgWrap isBackground:NO];
    }
}

// - (void)onNewSyncShowPush:(NSDictionary *)message
CHMethod(1, void, CMessageMgr, onNewSyncShowPush, id, message)
{
    CHSuper(1, CMessageMgr, onNewSyncShowPush, message);

    if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper &&
        [LLRedEnvelopesMgr shared].isOpenBackgroundMode &&
        [UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        //app在后台运行
        CMessageWrap *msgWrap = (CMessageWrap *)message;
        [[LLRedEnvelopesMgr shared] handleMessageWithMessageWrap:msgWrap isBackground:YES];
    }
}

//Hook函数的入口
__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(CMessageMgr);
    CHClassHook(1, CMessageMgr, onRevokeMsg);
    CHClassHook(1, CMessageMgr, onNewSyncShowPush);
    CHClassHook(2, CMessageMgr, AsyncOnAddMsg, MsgWrap);
}
