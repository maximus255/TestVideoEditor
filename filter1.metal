//
//  filter1.metal
//  TestVideo
//
//  Created by admin on 14.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {

    float4 filter1(sample_t s, float anAgrument, destination dest) {
        return float4((1.0 - s.rgb), s.a);
    }
    
//    float4 filter1(sampler src) {
//        return src.sample(src.coord());
//    }
    
    
}}
