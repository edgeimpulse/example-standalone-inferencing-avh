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

#include "cycle_handler.h"
#include "RTE_Components.h"
#include CMSIS_device_header

#if defined(DWT)

/* DWT Variables */
#define CM_DWT_CYCCNTENA_BIT   (1UL<<0)
#define CM_TRCENA_BIT          (1UL<<24)

#define CM_DWT_CONTROL         (*((volatile uint32_t*)0xE0001000))
#define CM_DWT_CYCCNT          (*((volatile uint32_t*)0xE0001004))
#define CM_DWT_LAR             (*((volatile uint32_t*)0xE0001FB0))
#define CM_DEMCR               (*((volatile uint32_t*)0xE000EDFC))

#define CM_DWT_CPICNT          (*((volatile uint32_t*)0xE0001008))
#define CM_DWT_EXCCNT          (*((volatile uint32_t*)0xE000100C))
#define CM_DWT_SLEEPCNT        (*((volatile uint32_t*)0xE0001010))
#define CM_DWT_LSUCNT          (*((volatile uint32_t*)0xE0001014))
#define CM_DWT_FOLDCNT         (*((volatile uint32_t*)0xE0001018))

volatile uint32_t dwt_ctrl;

/**
 * @brief Initialize cycle counter
 * 
 */
void cycle_counter_init(void)
{    
    CM_DEMCR |= CM_TRCENA_BIT;
    CM_DWT_LAR = 0xC5ACCE55;
    //ITM->LAR = 0xC5ACCE55;

    DWT->CYCCNT = 0;
}

/**
 * @brief Start cycle counter
 * 
 */
void cycle_counter_start(void)
{    
    cycle_counter_reset();
    DWT->CTRL = _VAL2FLD(DWT_CTRL_CYCCNTENA, 1) | _VAL2FLD(DWT_CTRL_CPIEVTENA, 1) |
                _VAL2FLD(DWT_CTRL_EXCEVTENA, 1) | _VAL2FLD(DWT_CTRL_SLEEPEVTENA, 1) |
                _VAL2FLD(DWT_CTRL_LSUEVTENA, 1) | _VAL2FLD(DWT_CTRL_FOLDEVTENA, 1) |
                _VAL2FLD(DWT_CTRL_CYCEVTENA, 1);
}

/**
 * @brief Stop cycle counter
 * 
 */
void cycle_counter_stop(void)
{
    DWT->CTRL &= ~DWT_CTRL_CYCCNTENA_Msk;
}

/**
 * @brief Reset cycle counter
 * 
 */
void cycle_counter_reset(void)
{    
    DWT->CYCCNT = 0;
    DWT->CPICNT = 0;
    DWT->EXCCNT = 0;
    DWT->SLEEPCNT = 0;
    DWT->LSUCNT = 0;
    DWT->FOLDCNT = 0;
}

/**
 * @brief 
 * 
 * @param cc 
 */
void cycle_counter_get(cycle_counter_t* cc)
{
    cc->_CPICNT = DWT->CPICNT;
    cc->_CYCCNT = DWT->CYCCNT;
    cc->_FOLDCNT = DWT->FOLDCNT;
    cc->_LSUCNT = DWT->LSUCNT;
}

/**
 * @brief
 */
int cycle_prof_counters_available(void)
{
    dwt_ctrl = CM_DWT_CONTROL;
    return ((DWT->CTRL & DWT_CTRL_NOCYCCNT_Msk) << DWT_CTRL_NOCYCCNT_Pos);
}

int cycle_counter_available(void)
{
    dwt_ctrl = CM_DWT_CONTROL;
    return ((DWT->CTRL & DWT_CTRL_NOPRFCNT_Msk) << DWT_CTRL_NOPRFCNT_Pos);
}

#endif