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

static const float features[] = { 
        // copy raw features here (for example from the 'Live classification' page)
         -0.8100, 0.7200, 9.5200, -5.1100, -2.0100, 9.7000, -2.3700, -0.1500, 9.3400, -2.6700, 0.1300, 9.2100, -2.6700, 0.1300, 9.2100, -2.0100, -2.1200, 9.5700, 2.7800, 1.3300, 9.4400, -1.3000, 1.1600, 10.1700, -2.3200, -2.0500, 10.1400, -0.5000, 0.1000, 9.4100, 1.3300, 1.1700, 9.9700, 1.3300, 1.1700, 9.9700, -0.8000, 0.6300, 10.3900, -0.0600, -1.1000, 9.7600, 0.1500, -1.2100, 9.8700, -0.2200, 1.2500, 10.0000, -0.6100, 3.6300, 9.7700, 0.6500, 4.0200, 10.1500, 0.6500, 4.0200, 10.1500, 0.6800, 2.1500, 9.9600, 0.9500, -2.3300, 9.9900, 0.0700, -2.7800, 10.2600, 1.1700, -0.5700, 9.3400, 0.8100, 0.8100, 9.8600, 1.0800, 0.9700, 9.4700, 1.0800, 0.9700, 9.4700, 1.2400, 1.1700, 9.8500, 0.7500, 1.6100, 7.8500, 1.7600, 1.7600, 6.7300, -0.3300, -0.1700, 8.7300, 0.2400, -1.3400, 8.6300, 0.0400, 0.2800, 9.6300, 0.0400, 0.2800, 9.6300, -0.2400, 2.5000, 9.0900, 1.4100, 5.0200, 8.7600, 0.2400, 3.8700, 9.5100, 0.0900, 2.0700, 9.6900, -0.3100, 1.3400, 9.8800, -1.1400, 1.2100, 10.2300, -1.1400, 1.2100, 10.2300, -0.1400, 1.4100, 10.0400, 0.1200, 1.9400, 9.5200, -0.1300, 1.6400, 10.0500, -0.1000, -0.0200, 9.9700, -0.6100, -0.4800, 9.7300, -1.6100, -0.6200, 10.0900, -1.6100, -0.6200, 10.0900, -2.4200, -0.4500, 10.1000, -2.8600, 0.2800, 9.7900, -1.4700, 1.1700, 10.2900, -0.5500, 0.5900, 10.0700, -0.3300, -0.6200, 10.0500, -0.3300, -0.6200, 9.8800, 0.1800, -2.0100, 9.8800, -1.1300, -3.2400, 10.0500, -1.5900, -3.3000, 10.2100, -1.4900, -2.6800, 9.9000, -0.2200, -1.9100, 10.1400, 0.5300, -1.1100, 9.5900, 0.5300, -1.1100, 9.5900, 0.7500, -0.5500, 9.9500, -0.0400, -0.9200, 9.9100, -0.3200, -1.4300, 9.9000, -0.2200, -1.2600, 9.9900, 0.3800, -0.1400, 10.3400, 1.9300, 0.4300, 10.0500, 1.9300, 0.4300, 10.0500, 0.4500, -0.5100, 9.9500, -0.1300, -1.0100, 10.3700, 1.5800, -2.1400, 9.8600, 1.9200, -1.8600, 9.5700, 2.3200, -1.2100, 9.7700, 1.4500, -0.0900, 8.7400, 1.4500, -0.0900, 8.7400, 0.0400, 0.8300, 9.6000, 0.6000, 1.8400, 8.6200, 2.2700, 1.6500, 9.0000, 1.3100, 0.8100, 9.7200, 0.6600, 0.6200, 10.1000, 0.5100, 2.7900, 9.8800, 0.5100, 2.7900, 9.8800, 0.0500, 4.8900, 10.2200, 1.1700, 4.7300, 9.6900, 2.4100, 2.5800, 10.0600, 1.6500, 1.3600, 9.6600, 0.6900, 0.1800, 10.1400, -1.0500, 0.8500, 9.7600, -1.0500, 0.8500, 9.7600, 0.0400, 2.9200, 10.1100, 0.7800, 2.5500, 9.7800, 0.0200, 2.1400, 10.2100, 0.1100, 1.1300, 9.5600, -1.8200, 0.9000, 10.2200, -2.4900, 1.3800, 9.9400, -2.4900, 1.3800, 9.9400, -1.2400, 1.2000, 10.0700, 0.0400, 1.0900, 10.0200, 0.2800, 0.5500, 9.9600, -0.6300, -0.7300, 9.1700, -1.7200, -1.1800, 9.6500, -2.2100, -0.7000, 9.5400, -2.2100, -0.7000, 9.5400, -2.3600, -0.1000, 10.1400, -1.8100, -0.1600, 10.0000, -1.5200, -0.5200, 9.8700, 0.0600, -1.5300, 9.8800, -0.5900, -2.1000, 10.2900, -1.3400, -2.8800, 10.0000, -1.3400, -2.8800, 10.0000, -0.7700, -2.8800, 10.1100, -0.7900, -1.9500, 10.1900, -0.8500, -0.6600, 9.5900, 0.4400, -0.3200, 9.7500, 0.8900, -0.1000, 10.1100, 0.8900, -0.1000, 10.1100, 0.3500, -0.1300, 10.1300, 0.3800, -0.4900, 9.8600, -0.0500, -1.0400, 9.5400, -1.1300, -0.8500, 10.0800, -0.0100, -0.2200, 9.7600, 0.7400, -0.2600, 10.2900, 0.7400, -0.2600, 10.2900, 0.2000, -0.6000, 10.3200, 0.8100, -0.7200, 9.1400, 1.4000, -1.0600, 9.0600
};

int raw_feature_get_data(size_t offset, size_t length, float *out_ptr)
{
    memcpy(out_ptr, features + offset, length * sizeof(float));
    return 0;
}

int main(void)
{
    ei_impulse_result_t result = {nullptr};
    systick_handler_init();

    ei_printf("Edge Impulse standalone inferencing (AVH)\n");

    if (sizeof(features) / sizeof(float) != EI_CLASSIFIER_DSP_INPUT_FRAME_SIZE) {
        ei_printf("The size of your 'features' array is not correct. Expected %d items, but had %u\n",
                EI_CLASSIFIER_DSP_INPUT_FRAME_SIZE, sizeof(features) / sizeof(float));
        return 1;
    }
        
    // the features are stored into flash, and we don't want to load everything into RAM
    signal_t features_signal;
    features_signal.total_length = sizeof(features) / sizeof(features[0]);
    features_signal.get_data = &raw_feature_get_data;

    // invoke the impulse
    EI_IMPULSE_ERROR res = run_classifier(&features_signal, &result, false);

    //ei_printf("run_classifier returned: %d\n", res);

    if (res != 0) {
        return 1;
    }
        
    ei_printf("Predictions (DSP: %ld us., Classification: %ld us., Anomaly: %ld us.): \n",
                (int32_t)result.timing.dsp_us, (int32_t)result.timing.classification_us, (int32_t)result.timing.anomaly_us);

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
