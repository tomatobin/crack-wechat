//
//  WCDeviceStepObject-Hook.m
//  CrackWeChat
//
//  Created by jiangbin on 2018/2/5.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CaptainHook.h"
#import "WCRedEnvelopesHelper.h"
#import "LLRedEnvelopesMgr.h"
#import "LLSettingController.h"

//Hook的class
CHDeclareClass(WCDeviceStepObject);

//Hook的函数
// - (void)reloadTableData
CHMethod(0, unsigned long, WCDeviceStepObject, m7StepCount)
{
    if([LLRedEnvelopesMgr shared].isOpenSportHelper){
        return [[LLRedEnvelopesMgr shared] getSportStepCount]; 
    } else {
        return CHSuper(0, WCDeviceStepObject, m7StepCount);;
    }
}

//Hook函数的入口
__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(WCDeviceStepObject);
    CHClassHook(0, WCDeviceStepObject, m7StepCount);
}
