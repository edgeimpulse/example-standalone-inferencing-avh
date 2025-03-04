/*
 * Copyright (c) 2024 EdgeImpulse Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include <stdio.h>
#include "ei_run_classifier.h"
#include "edge-impulse-sdk/porting/ei_classifier_porting.h"
#include "systick_handler.h"
#include "board_init.h"
#include "features.h"

#include "RTE_Components.h"
#include CMSIS_device_header

#if defined(DWT)
#include "cycle_handler.h"
#endif

extern uint32_t SystemCoreClock;

int raw_feature_get_data(size_t offset, size_t length, float *out_ptr)
{
    memcpy(out_ptr, features + offset, length * sizeof(float));
    return 0;
}

int main(void)
{
    ei_impulse_result_t result = {nullptr};

    board_init();
    systick_handler_init();
#if defined(DWT)
    cycle_counter_init();
#endif

    ei_printf("Edge Impulse standalone inferencing (AVH)\n");
    ei_printf("SystemCoreClock: %ld\n", SystemCoreClock);

    if (FEATURES_SIZE!= EI_CLASSIFIER_DSP_INPUT_FRAME_SIZE) {
        ei_printf("The size of your 'features' array is not correct. Expected %d items, but had %u\n",
                EI_CLASSIFIER_DSP_INPUT_FRAME_SIZE, FEATURES_SIZE);
        return 1;
    }
        
    // the features are stored into flash, and we don't want to load everything into RAM
    signal_t features_signal;
    features_signal.total_length = sizeof(features) / sizeof(features[0]);
    features_signal.get_data = &raw_feature_get_data;

#if defined(DWT)
    cycle_counter_t post_cycle;
    cycle_counter_start();
#endif

    // invoke the impulse
    EI_IMPULSE_ERROR res = run_classifier(&features_signal, &result, false);

    if (res != 0) {
        return 1;
    }
    
#if defined(DWT)
    cycle_counter_get(&post_cycle);
    cycle_counter_stop();

    ei_printf("_CYCCNT: %lu\n", post_cycle._CYCCNT);
    ei_printf("_CPICNT: %lu\n", post_cycle._CPICNT);
    ei_printf("_LSUCNT: %lu\n", post_cycle._LSUCNT);
    ei_printf("_FOLDCNT: %lu\n", post_cycle._FOLDCNT);    
#endif

    ei_printf("Predictions (DSP: %ld us., Classification: %ld us., Anomaly: %ld us.): \n",
                (int32_t)result.timing.dsp_us, (int32_t)result.timing.classification_us, (int32_t)result.timing.anomaly_us);
    
    ei_printf("Predictions (DSP: %ld ms., Classification: %ld ms., Anomaly: %ld ms.): \n",
                (int32_t)result.timing.dsp, (int32_t)result.timing.classification, (int32_t)result.timing.anomaly);

    // print the predictions
    ei_printf("[");

#if EI_CLASSIFIER_OBJECT_DETECTION == 1
    bool bb_found = result.bounding_boxes[0].value > 0;
    for (size_t ix = 0; ix < EI_CLASSIFIER_OBJECT_DETECTION_COUNT; ix++) {
        auto bb = result.bounding_boxes[ix];
        if (bb.value == 0) {
            continue;
        }

        ei_printf("    %s (", bb.label);
        ei_printf_float(bb.value);
        ei_printf(") [ x: %lu, y: %lu, width: %lu, height: %lu ]\n", bb.x, bb.y, bb.width, bb.height);
    }

    if (!bb_found) {
        ei_printf("    No objects found\n");
    }
#else
    for (size_t ix = 0; ix < EI_CLASSIFIER_LABEL_COUNT; ix++) {
        ei_printf("    %s: ",result.classification[ix].label);
        ei_printf_float(result.classification[ix].value);

#if EI_CLASSIFIER_HAS_ANOMALY == 1
        ei_printf(",\n");            
#else
        if (ix != EI_CLASSIFIER_LABEL_COUNT - 1) {
            ei_printf(",\n");                
        }
#endif
    }
#endif

#if EI_CLASSIFIER_HAS_ANOMALY == 1
    ei_printf("Anomaly: ");
    ei_printf_float(result.anomaly);
#endif
    ei_printf("]\n");


    return  0;
}
