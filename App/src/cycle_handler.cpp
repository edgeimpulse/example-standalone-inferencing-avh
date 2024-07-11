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

#include "RTE_Components.h"
#include CMSIS_device_header
#include "cycle_handler.h"

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



/**
 * @brief Initialize cycle counter
 * 
 */
void cycle_counter_init(void)
{
    CM_DEMCR |= CM_TRCENA_BIT;
    //DCB->DEMCR |= DCB_DEMCR_TRCENA_Msk;
    CM_DWT_LAR = 0xC5ACCE55;
    //ITM->LAR = 0xC5ACCE55;

    DWT->CYCCNT = 0;
    //DWT->CTRL |= 1UL;
}

/**
 * @brief Start cycle counter
 * 
 */
void cycle_counter_start(void)
{    
    DWT->CYCCNT = 0;
    DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
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
    DWT->CPICNT = 0;
    DWT->CYCCNT = 0;
    DWT->FOLDCNT = 0;
    DWT->LSUCNT = 0;
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

#endif
