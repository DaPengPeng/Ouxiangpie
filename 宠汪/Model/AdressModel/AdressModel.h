//
//  AdressModel.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/1.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "BaseModel.h"

@interface AdressModel : BaseModel

@property (nonatomic, copy) NSString *objectId, *createAt, *aProvince, *aCity, *aStresst;

@property (nonatomic, assign) NSUInteger aNumber;

@end
