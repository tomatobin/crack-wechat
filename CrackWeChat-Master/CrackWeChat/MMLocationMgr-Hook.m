//
//  MMLocationMgr-Hook
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
CHDeclareClass(MMLocationMgr);

//Hook的函数
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
CHMethod(3, void, MMLocationMgr, locationManager, id, manager, didUpdateToLocation, id, newLocation, fromLocation, id, oldLcation)
{
    if([LLRedEnvelopesMgr shared].isOpenVirtualLocation && newLocation && [newLocation isMemberOfClass:[CLLocation class]]){
        CLLocation *virutalLocation = [[LLRedEnvelopesMgr shared] getVirutalLocationWithRealLocation:newLocation];
        CHSuper(3, MMLocationMgr, locationManager, manager, didUpdateToLocation, newLocation, fromLocation, virutalLocation);
    } else {
        CHSuper(3, MMLocationMgr, locationManager, manager, didUpdateToLocation, newLocation, fromLocation, oldLcation);
    }
}

//Hook的函数
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(CLLocation *)location
CHMethod(2, void, MMLocationMgr, mapView, id, mapView, didUpdateUserLocation, id, location)
{
    if([LLRedEnvelopesMgr shared].isOpenVirtualLocation && location && [location isMemberOfClass:[CLLocation class]]){
        CLLocation *virutalLocation = [[LLRedEnvelopesMgr shared] getVirutalLocationWithRealLocation:location];
        CHSuper(2, MMLocationMgr, mapView, mapView, didUpdateUserLocation, virutalLocation);
    } else {
        CHSuper(2, MMLocationMgr, mapView, mapView, didUpdateUserLocation, location);
    }
}

//Hook函数的入口
__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(MMLocationMgr);
    CHClassHook(3, MMLocationMgr, locationManager, didUpdateToLocation, fromLocation);
    CHClassHook(2, MMLocationMgr, mapView, didUpdateUserLocation);
}
