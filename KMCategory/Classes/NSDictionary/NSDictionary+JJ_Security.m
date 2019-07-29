//
//  NSDictionary+JJ_Security.m
//  WOEWO
//
//  Created by BPMAC on 2017/3/16.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import "NSDictionary+JJ_Security.h"

@implementation NSDictionary (JJ_Security)

-(NSArray*)jj_arrayForKey:(NSString*)key{
    
    id value= [self objectForKey:key];
    
    return ([value isEqual:[NSNull null]]||value==nil)?@[]:([value isKindOfClass:[NSArray class]]?value:@[]);;
}
-(NSDictionary*)jj_dicForKey:(NSString*)key{
    
    id value= [self objectForKey:key];
    
    return ([value isEqual:[NSNull null]]||value==nil)?@{}:([value isKindOfClass:[NSDictionary class]]?value:@{});
}
-(NSString*)jj_stringForKey:(NSString*)key{
    
    id value= [self objectForKey:key];
    
    return (([value isEqual:[NSNull null]]||value==nil)?@"":[NSString stringWithFormat:@"%@",value]);
    
    
}
@end
