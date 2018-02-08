//
//  NewSettingViewController-Hook.m
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
CHDeclareClass(NewSettingViewController);

//Hook的函数
// - (void)reloadTableData
CHMethod(0, void, NewSettingViewController, reloadTableData)
{
    CHSuper(0, NewSettingViewController, reloadTableData);

    MMTableViewCellInfo *configCell = [NSClassFromString(@"MMTableViewCellInfo") normalCellForSel:@selector(configHandler) target:self title:@"微信助手设置" accessoryType:1];
    MMTableViewSectionInfo *sectionInfo = [NSClassFromString(@"MMTableViewSectionInfo") sectionInfoDefaut];
    [sectionInfo addCell:configCell];
    
    MMTableViewInfo *tableViewInfo = [self valueForKey:@"m_tableViewInfo"];
    [tableViewInfo insertSection:sectionInfo At:0];
    [[tableViewInfo getTableView] reloadData];
}

//Hook函数的入口
__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(NewSettingViewController);
    CHClassHook(0, NewSettingViewController, reloadTableData);
}

CHDeclareMethod(0, void, NewSettingViewController, configHandler)
{
    LLSettingController *settingVC = [[LLSettingController alloc] init];
    [((UIViewController *)self).navigationController PushViewController:settingVC animated:YES];
}
