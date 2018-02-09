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
CHDeclareClass(NSBundle);


//Hook的函数
//
CHMethod(0, id, NSBundle, getBundleIdentifier)
{
    //CHSuper(0, NSBundle, load);

    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NSBundle" message:[NSString stringWithFormat:@"Get bundle id:%@", bundleId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
    
    return @"com.tencent.xin";
}


//Hook函数的入口
__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(NSBundle);
    CHClassHook(0, NSBundle, getBundleIdentifier);
}

