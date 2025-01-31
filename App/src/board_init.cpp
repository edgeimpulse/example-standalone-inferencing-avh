/*
 * Copyright (c) 2024 EdgeImpulse Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an "AS
 * IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "board_init.h"

/* Platform dependent files */
#include "RTE_Components.h"  /* Provides definition for CMSIS_device_header */
#include CMSIS_device_header /* Gives us IRQ num, base addresses. */
#include "edge-impulse-sdk/porting/ei_classifier_porting.h"

#if defined(EI_ETHOS)
#include "ethosu_driver.h" /* Arm Ethos-U NPU driver header */
#include "ethosu_mem_config.h" /* Arm Ethos-U NPU memory config */

#if defined(ETHOS_U_CACHE_BUF_SZ) && (ETHOS_U_CACHE_BUF_SZ > 0)
static uint8_t cache_arena[ETHOS_U_CACHE_BUF_SZ] CACHE_BUF_ATTRIBUTE;
#else  /* defined (ETHOS_U_CACHE_BUF_SZ) && (ETHOS_U_CACHE_BUF_SZ > 0) */
static uint8_t* cache_arena = NULL;
#endif /* defined (ETHOS_U_CACHE_BUF_SZ) && (ETHOS_U_CACHE_BUF_SZ > 0) */

static uint8_t* get_cache_arena()
{
    return cache_arena;
}

static size_t get_cache_arena_size()
{
#if defined(ETHOS_U_CACHE_BUF_SZ) && (ETHOS_U_CACHE_BUF_SZ > 0)
    return sizeof(cache_arena);
#else  /* defined (ETHOS_U_CACHE_BUF_SZ) && (ETHOS_U_CACHE_BUF_SZ > 0) */
    return 0;
#endif /* defined (ETHOS_U_CACHE_BUF_SZ) && (ETHOS_U_CACHE_BUF_SZ > 0) */
}

static struct ethosu_driver npuDriver;/* Default Ethos-U device driver */

/** @brief   Defines the Ethos-U interrupt handler: just a wrapper around the default
 *           implementation. */
static void arm_ethosu_npu_irq_handler(void)
{
    /* Call the default interrupt handler from the NPU driver */
    ethosu_irq_handler(&npuDriver);
}

/** @brief  Initialises the NPU IRQ */
static void arm_ethosu_npu_irq_init(void)
{
#if defined (ETHOSU55)
    const IRQn_Type ethosu_irqnum = (IRQn_Type)ETHOS_U55_IRQn;
#elif defined (ETHOSU65)
    const IRQn_Type ethosu_irqnum = (IRQn_Type)NPU0_IRQn;
#elif defined (ETHOSU85)
    const IRQn_Type ethosu_irqnum = (IRQn_Type)NPU0_IRQn;
#else
#error "Unsupported Ethos-U NPU"
#endif


    /* Register the EthosU IRQ handler in our vector table.
     * Note, this handler comes from the EthosU driver */
    NVIC_SetVector(ethosu_irqnum, (uint32_t)arm_ethosu_npu_irq_handler);

    /* Enable the IRQ */
    NVIC_EnableIRQ(ethosu_irqnum);
}

/** @brief  Initialises the NPU */
static int arm_ethosu_npu_init(void)
{
    int err = 0;

    /* Initialise the IRQ */
    arm_ethosu_npu_irq_init();

    /* Initialise Ethos-U device */
#if defined (ETHOSU55)
    void* const ethosu_base_address = reinterpret_cast<void*>(ETHOS_U55_APB_BASE_S);
    ei_printf("ETHOS_U55_APB_BASE_S %d\n", ETHOS_U55_APB_BASE_S);
#elif defined (ETHOSU65)
    void* const ethosu_base_address = reinterpret_cast<void*>(NPU0_APB_BASE_S);
    ei_printf("ETHOS_U55_APB_BASE_S %d\n", NPU0_APB_BASE_S);
#elif defined (ETHOSU85)
    void* const ethosu_base_address = reinterpret_cast<void*>(NPU0_APB_BASE_S);
    ei_printf("ETHOS_U55_APB_BASE_S %d\n", NPU0_APB_BASE_S);
#else
#error "Unsupported Ethos-U NPU"
#endif

    ei_printf("get_cache_arena_size %d\n", get_cache_arena_size());

    if (0 != (err = ethosu_init(&npuDriver,         /* Ethos-U driver device pointer */
                                ethosu_base_address, /* Ethos-U NPU's base address. */
                                get_cache_arena(),   /* Pointer to fast mem area - NULL for U55. */
                                get_cache_arena_size(), /* Fast mem region size. */
                                1,                      /* Security enable. */
                                1)))                    /* Privilege enable. */
    {
        ei_printf("failed to initialise Ethos-U device\n");
        return err;
    }

    return 0;
}

#endif /* if defined(EI_ETHOS) */


void board_init(void)
{
#if defined(EI_ETHOS)
    /* Initialise the NPU */
    arm_ethosu_npu_init();
#endif /* defined(EI_ETHOS) */
}
