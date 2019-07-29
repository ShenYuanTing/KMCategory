//
//  NSArray+JJ_Security.m
//  WOEWO
//
//  Created by BPMAC on 2017/3/16.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import "NSArray+JJ_Security.h"

@implementation NSArray (JJ_Security)

-(id)jj_objectAtIndex:(NSInteger)index{
    
    return (index<self.count) ?[self objectAtIndex:index]:[[NSObject alloc]init];
}
@end
