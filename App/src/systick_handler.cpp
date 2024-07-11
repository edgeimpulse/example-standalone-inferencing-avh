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
#include "systick_handler.h"
#include "RTE_Components.h"
#include CMSIS_device_header

#ifndef SYSTICK_IRQ_PRIORITY
#define SYSTICK_IRQ_PRIORITY    0xFFU
#endif

#ifndef SYSTICK_CORRECTION_FACTOR
#define SYSTICK_CORRECTION_FACTOR    (1.0)
#endif

static uint32_t _ms_count;
static uint32_t fact;

/**
 * @brief 
 * 
 */
void systick_handler_init(void)
{
    _ms_count = 0;

    // Set SysTick Interrupt Priority
    NVIC_SetPriority (SysTick_IRQn, (1<<__NVIC_PRIO_BITS) - 1);
    fact = (SystemCoreClock / 1000000);
    
    SysTick->LOAD = 0xFFFFFF;   // 24 bit timer
    SysTick->VAL  =  0U;    //
    SysTick->CTRL =  SysTick_CTRL_CLKSOURCE_Msk // processor clock source
                //| SysTick_CTRL_TICKINT_Msk  // Enables SysTick exception request - not handled in AVH
                | SysTick_CTRL_ENABLE_Msk;  // Enable the counter
}

/**
 * @brief 
 * 
 * @return uint32_t 
 */
uint32_t systick_handler_get(void)
{
    SysTick->CTRL &= ~SysTick_CTRL_ENABLE_Msk;  // stop

    _ms_count += ((SysTick->LOAD - SysTick->VAL) / fact);
    SysTick->VAL  =  0U;    // reset

    SysTick->CTRL |= SysTick_CTRL_ENABLE_Msk;   // restart

    return (_ms_count * SYSTICK_CORRECTION_FACTOR);
}
