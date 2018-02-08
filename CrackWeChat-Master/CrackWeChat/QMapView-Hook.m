//
//  QMapView-Hook.m
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
CHDeclareClass(QMapView);

//Hook的函数
//locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
CHMethod(3, void, QMapView, locationManager, id, manager, didUpdateToLocation, id, newLocation, fromLocation, id, oldLcation)
{
    CHSuper(3, QMapView, locationManager, manager, didUpdateToLocation, newLocation, fromLocation, oldLcation);
}

//Hook的函数
//- (id)correctLocation:(id)arg1
CHMethod(1, id, QMapView, correctLocation, id, arg1)
{
    return [LLRedEnvelopesMgr shared].isOpenVirtualLocation ? arg1 : CHSuper(1, QMapView, correctLocation, arg1);;
}

//Hook函数的入口
__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(QMapView);
    CHClassHook(3, QMapView, locationManager, didUpdateToLocation, fromLocation);
    CHClassHook(1, QMapView, correctLocation);
}
