#import "WCRedEnvelopesHelper.h"
#import "LLRedEnvelopesMgr.h"
#import "LLSettingController.h"
#import <AVFoundation/AVFoundation.h>
%hook WCDeviceStepObject

- (unsigned long)m7StepCount{
	if([LLRedEnvelopesMgr shared].isOpenSportHelper){
		return [[LLRedEnvelopesMgr shared] getSportStepCount]; // max value is 98800
	} else {
		return %orig;
	}
}

%end

%hook UINavigationController

- (void)PushViewController:(UIViewController *)controller animated:(BOOL)animated{
	if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].isHongBaoPush && [controller isMemberOfClass:NSClassFromString(@"BaseMsgContentViewController")]) {
		[LLRedEnvelopesMgr shared].isHongBaoPush = NO;
        [[LLRedEnvelopesMgr shared] handleRedEnvelopesPushVC:(BaseMsgContentViewController *)controller]; 
    } else {
    	%orig;
    }
}

%end

%hook UIViewController 

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
	LLRedEnvelopesMgr *manager = [LLRedEnvelopesMgr shared];
	if (manager.isOpenRedEnvelopesHelper && manager.isHiddenRedEnvelopesReceiveView && [viewControllerToPresent isKindOfClass:NSClassFromString(@"MMUINavigationController")]){
		manager.isHiddenRedEnvelopesReceiveView = NO;
		UINavigationController *navController = (UINavigationController *)viewControllerToPresent;
		if (navController.viewControllers.count > 0){
			if ([navController.viewControllers[0] isKindOfClass:NSClassFromString(@"WCRedEnvelopesRedEnvelopesDetailViewController")]){
				//模态红包详情视图
				if([manager isMySendMsgWithMsgWrap:manager.msgWrap]){
					//领取的是自己发的红包,不自动回复和自动留言
					return;
				}
				if(manager.isOpenAutoReply && [self isMemberOfClass:%c(BaseMsgContentViewController)]){
					BaseMsgContentViewController *baseMsgVC = (BaseMsgContentViewController *)self;
					[baseMsgVC AsyncSendMessage:manager.autoReplyText];
				}
				if(manager.isOpenAutoLeaveMessage){
					WCRedEnvelopesReceiveControlLogic *redEnvelopeLogic = MSHookIvar<WCRedEnvelopesReceiveControlLogic *>(navController.viewControllers[0],"m_delegate");
					[redEnvelopeLogic OnCommitWCRedEnvelopes:manager.autoLeaveMessageText];
				}
				return;
			}
		}
	} 
	%orig;	
}

%end


%hook NewMainFrameViewController

- (void)viewDidLoad{
	%orig;
	[LLRedEnvelopesMgr shared].openRedEnvelopesBlock = ^{
		if([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].haveNewRedEnvelopes){
			[LLRedEnvelopesMgr shared].haveNewRedEnvelopes = NO;
			[LLRedEnvelopesMgr shared].isHongBaoPush = YES;
			[[LLRedEnvelopesMgr shared] openRedEnvelopes:self];
		}
	};
}

- (void)reloadSessions{
	%orig;
	if([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].openRedEnvelopesBlock){
		[LLRedEnvelopesMgr shared].openRedEnvelopesBlock();
	}
}

%end

%hook WCRedEnvelopesControlLogic

- (void)startLoading{
	if ([LLRedEnvelopesMgr shared].isOpenRedEnvelopesHelper && [LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView){
		//隐藏加载菊花
		//do nothing	
	} else {
		%orig;
	}
}

%end


%hook MicroMessengerAppDelegate

- (void)applicationWillEnterForeground:(UIApplication *)application {
	%orig;
	[[LLRedEnvelopesMgr shared] reset];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
  %orig;
  [[LLRedEnvelopesMgr shared] enterBackgroundHandler];
}

%end

%hook MMMsgLogicManager

- (id)GetCurrentLogicController{
	if([LLRedEnvelopesMgr shared].isHiddenRedEnvelopesReceiveView && [LLRedEnvelopesMgr shared].logicController){
		return [LLRedEnvelopesMgr shared].logicController;
	} 
	return %orig;
}

%end
