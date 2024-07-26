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

#ifndef _CYCLE_HANDLER_H_
#define _CYCLE_HANDLER_H_

#include <stdint.h>

/*
    From https://github.com/ARM-software/AVH/blob/main/DoxyGen/simulation/src/FVP-Timing.md :
    - The value of CPICNT and LSUCNT are incremented on additional wait states. These value should be added to the cycles measured in simulation.
    - The value of FOLDCNT is incremented when instructions are folded. This value should be subtracted from the cycles measured in simulation.
*/

typedef struct {
    uint32_t _CPICNT;   /* CPI Count Register */
    uint32_t _LSUCNT;   /* LSU Count Register */
    uint32_t _FOLDCNT;  /* Folded-instruction Count Register */
    uint32_t _CYCCNT;   /* Cycle Count Register */
} cycle_counter_t;

extern void cycle_counter_init(void);
extern void cycle_counter_start(void);
extern void cycle_counter_stop(void);
extern void cycle_counter_reset(void);
extern void cycle_counter_get(cycle_counter_t* cc);
extern int cycle_prof_counters_available(void);
extern int cycle_counter_available(void);

#endif /* _CYCLE_HANDLER_H_ */
