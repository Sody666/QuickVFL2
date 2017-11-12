//
//  QLayoutResult.m
//  LibSourceUser
//
//  Created by 苏第 on 17/11/5.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import "QLayoutResult.h"

@implementation QLayoutResult
-(id)viewNamed:(NSString*)name{
    if(name.length == 0 || self.createdViews.count == 0){
        return nil;
    }
    
    return [self.createdViews objectForKey:name];
}
@end
