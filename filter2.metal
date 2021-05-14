//
//  filter2.metal
//  TestVideo
//
//  Created by admin on 14.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {

    float4 filter2(sample_t s, destination dest) {
        float2 c = dest.coord();
        int I = ((int)c.x/50+0.5f),J = ((int)c.y/50+0.5f);
        I%=2,J%=2;
        if ((I^J)==0)
            return s.brga;
        else            
            return s.rbga;
    }

}}

