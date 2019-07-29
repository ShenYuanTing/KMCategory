//
//  NSDictionary+JJ_Security.h
//  WOEWO
//
//  Created by BPMAC on 2017/3/16.
//  Copyright © 2017年 BPMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JJ_Security)

-(NSArray*)jj_arrayForKey:(NSString*)key;
-(NSDictionary*)jj_dicForKey:(NSString*)key;
-(NSString*)jj_stringForKey:(NSString*)key;
@end
