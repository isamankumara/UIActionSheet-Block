//
//  UIActionSheet+Blocking.m
//
//  Created by Saman Kumara on 6/26/15.
//  Copyright (c) 2015 Saman Kumara. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#import <objc/runtime.h>
#import "UIActionSheet+Blocking.h"


@interface ActionSheetHandler : NSObject<UIActionSheetDelegate>
@property (nonatomic , copy) void (^tapBlock)(UIActionSheet *actionSheet , NSInteger buttonIndex);
@end

@implementation ActionSheetHandler

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.tapBlock) {
        self.tapBlock(actionSheet,buttonIndex);
    }
}


@end


static const char KActionSheetHandler;
@implementation UIActionSheet (Blocking)


+(void)showMessage:(NSString *)message buttons:(NSArray *)buttons showIn:(id)view tapBlock:(void (^)(UIActionSheet *actionSheet , NSInteger buttonIndex))block{
    
    [UIActionSheet showMessage:message titlle:nil buttons:buttons showIn:view tapBlock:block];
}


+(void)showMessage:(NSString *)message titlle:(NSString *)title buttons:(NSArray *)buttons showIn:(id)view tapBlock:(void (^)(UIActionSheet *actionSheet , NSInteger buttonIndex))block{
    ActionSheetHandler *actionHandler = [[ActionSheetHandler alloc]init];

    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:actionHandler cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString * title in buttons) {
        [actionSheet addButtonWithTitle:title];
    }
     actionHandler.tapBlock = block;
    
    actionSheet.delegate = actionHandler;
    objc_setAssociatedObject(self, &KActionSheetHandler, actionHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    if ([view isKindOfClass:[UIToolbar class]]) {
        
    }else if ([view isKindOfClass:[UITabBar class]]) {
        
    }else{
        [actionSheet showInView:view];
    }

}


@end
