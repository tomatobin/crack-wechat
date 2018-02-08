//
//  CrackWeChat.m
//  CrackWeChat
//
//  Created by jiangbin on 16/11/9.
//  Copyright (c) 2016年 __MyCompanyName__. All rights reserved.
//
//


//#import "CaptainHook.h"
//
////Hook的class
//CHDeclareClass(CMessageMgr);
//
////Hook的函数
////- (void)AsyncOnAddMsg:(NSString *)msg MsgWrap:(CMessageWrap *)wrap
//CHMethod(2, void, CMessageMgr, AsyncOnAddMsg, id, arg1, MsgWrap, id, arg2)
//{
//    CHSuper(2, CMessageMgr, AsyncOnAddMsg, arg1, MsgWrap, arg2);
//    Ivar uiMessageTypeIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_uiMessageType");
//    ptrdiff_t offset = ivar_getOffset(uiMessageTypeIvar);
//    unsigned char *stuffBytes = (unsigned char *)(__bridge void *)arg2;
//    NSUInteger m_uiMessageType = * ((NSUInteger *)(stuffBytes + offset));
//
//    Ivar nsFromUsrIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsFromUsr");
//    id m_nsFromUsr = object_getIvar(arg2, nsFromUsrIvar);
//
//    Ivar nsContentIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsContent");
//    id m_nsContent = object_getIvar(arg2, nsContentIvar);
//
//    switch(m_uiMessageType) {
//        case 49: {
//
//            [NSThread sleepForTimeInterval:10];
//
//            //微信的服务中心
//            Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
//            IMP impMMSC = method_getImplementation(methodMMServiceCenter);
//            id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
//            //红包控制器
//            id logicMgr = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("WCRedEnvelopesLogicMgr"));
//            //通讯录管理器
//            id contactManager = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("CContactMgr"));
//
//            Method methodGetSelfContact = class_getInstanceMethod(objc_getClass("CContactMgr"), @selector(getSelfContact));
//            IMP impGS = method_getImplementation(methodGetSelfContact);
//            id selfContact = impGS(contactManager, @selector(getSelfContact));
//
//            Ivar nsUsrNameIvar = class_getInstanceVariable([selfContact class], "m_nsUsrName");
//            id m_nsUsrName = object_getIvar(selfContact, nsUsrNameIvar);
//            BOOL isMesasgeFromMe = NO;
//            BOOL isChatroom = NO;
//
//            if ([m_nsFromUsr isEqualToString:m_nsUsrName]) { //自己的红包
//                isMesasgeFromMe = YES;
//            }
//
//            if ([m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound) //群里的红包
//            {
//                isChatroom = YES;
//            }
//
//            if ([m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound)
//            {
//                NSString *nativeUrl = m_nsContent;
//                NSRange rangeStart = [m_nsContent rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao"];
//                if (rangeStart.location != NSNotFound)
//                {
//                    NSUInteger locationStart = rangeStart.location;
//                    nativeUrl = [nativeUrl substringFromIndex:locationStart];
//                }
//
//                NSRange rangeEnd = [nativeUrl rangeOfString:@"]]"];
//                if (rangeEnd.location != NSNotFound)
//                {
//                    NSUInteger locationEnd = rangeEnd.location;
//                    nativeUrl = [nativeUrl substringToIndex:locationEnd];
//                }
//
//                NSString *naUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
//
//                NSArray *parameterPairs =[naUrl componentsSeparatedByString:@"&"];
//
//                NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
//                for (NSString *currentPair in parameterPairs) {
//                    NSRange range = [currentPair rangeOfString:@"="];
//                    if(range.location == NSNotFound)
//                        continue;
//                    NSString *key = [currentPair substringToIndex:range.location];
//                    NSString *value =[currentPair substringFromIndex:range.location + 1];
//                    [parameters setObject:value forKey:key];
//                }
//
//                //红包参数
//                NSMutableDictionary *params = [@{} mutableCopy];
//
//                [params setObject:parameters[@"msgtype"]?:@"null" forKey:@"msgType"];
//                [params setObject:parameters[@"sendid"]?:@"null" forKey:@"sendId"];
//                [params setObject:parameters[@"channelid"]?:@"null" forKey:@"channelId"];
//
//                id getContactDisplayName = objc_msgSend(selfContact, @selector(getContactDisplayName));
//                id m_nsHeadImgUrl = objc_msgSend(selfContact, @selector(m_nsHeadImgUrl));
//
//                [params setObject:getContactDisplayName forKey:@"nickName"];
//                [params setObject:m_nsHeadImgUrl forKey:@"headImg"];
//                [params setObject:[NSString stringWithFormat:@"%@", nativeUrl]?:@"null" forKey:@"nativeUrl"];
//                [params setObject:m_nsFromUsr?:@"null" forKey:@"sessionUserName"];
//
//                    //自动抢红包
//                ((void (*)(id, SEL, NSMutableDictionary*))objc_msgSend)(logicMgr, @selector(OpenRedEnvelopesRequest:), params);
//            }
//
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//__attribute__((constructor)) static void entry()
//{
//    CHLoadLateClass(CMessageMgr);
//    CHClassHook(2, CMessageMgr, AsyncOnAddMsg, MsgWrap);
//}

