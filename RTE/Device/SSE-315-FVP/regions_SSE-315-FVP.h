#ifndef REGIONS_SSE_315_FVP_H
#define REGIONS_SSE_315_FVP_H


//-------- <<< Use Configuration Wizard in Context Menu >>> --------------------
//------ With VS Code: Open Preview for Configuration Wizard -------------------

// <n> Auto-generated using information from packs
// <i> Device Family Pack (DFP):   ARM::SSE_315_BSP@1.0.0

// <h> ROM Configuration
// =======================
// <h> __ROM0 (is rx memory: IROM1 from DFP)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region. Default: 0x11000000
//   <i> Contains Startup and Vector Table
#define __ROM0_BASE 0x11000000
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region. Default: 0x00200000
#define __ROM0_SIZE 0x00200000
// </h>

// <h> __ROM1 (unused)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region.
#define __ROM1_BASE 0
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region.
#define __ROM1_SIZE 0
// </h>

// <h> __ROM2 (unused)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region.
#define __ROM2_BASE 0
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region.
#define __ROM2_SIZE 0
// </h>

// <h> __ROM3 (unused)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region.
#define __ROM3_BASE 0
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region.
#define __ROM3_SIZE 0
// </h>

// </h>

// <h> RAM Configuration
// =======================
// <h> __RAM0 (is rwx memory: IRAM1 from DFP)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region. Default: 0x31000000
//   <i> Contains uninitialized RAM, Stack, and Heap
#define __RAM0_BASE 0x31000000
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region. Default: 0x00020000
#define __RAM0_SIZE 0x00020000
// </h>

// <h> __RAM1 (is rwx memory: ITCM_NS from DFP)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region. Default: 0x00000000
#define __RAM1_BASE 0x00000000
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region. Default: 0x00008000
#define __RAM1_SIZE 0x00008000
// </h>

// <h> __RAM2 (is rwx memory: SRAM_NS from DFP)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region. Default: 0x01000000
#define __RAM2_BASE 0x01000000
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region. Default: 0x00200000
#define __RAM2_SIZE 0x00200000
// </h>

// <h> __RAM3 (is rwx memory: DTCM0_NS+DTCM1_NS+DTCM2_NS+DTCM3_NS from DFP)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region. Default: 0x20000000
#define __RAM3_BASE 0x20000000
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region. Default: 0x00008000
#define __RAM3_SIZE 0x00008000
// </h>

// </h>

// <h> Stack / Heap Configuration
//   <o0> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
//   <o1> Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
#define __STACK_SIZE 0x00001000
#define __HEAP_SIZE 0x00200000
// </h>

// <n> Resources that are not allocated to linker regions
// <i> rwx RAM:  ISRAM0_NS from DFP:     BASE: 0x21000000  SIZE: 0x00200000
// <i> rwx RAM:  ISRAM1_NS from DFP:     BASE: 0x21200000  SIZE: 0x00200000
// <i> rwx RAM:  QSPI_SRAM_NS from DFP:  BASE: 0x28000000  SIZE: 0x00800000
// <i> rwx RAM:  ITCM_S from DFP:        BASE: 0x10000000  SIZE: 0x00008000
// <i> rwx RAM:  SRAM_S from DFP:        BASE: 0x11000000  SIZE: 0x00200000
// <i> rwx RAM:  DTCM0_S from DFP:       BASE: 0x30000000  SIZE: 0x00002000
// <i> rwx RAM:  DTCM1_S from DFP:       BASE: 0x30002000  SIZE: 0x00002000
// <i> rwx RAM:  DTCM2_S from DFP:       BASE: 0x30004000  SIZE: 0x00002000
// <i> rwx RAM:  DTCM3_S from DFP:       BASE: 0x30006000  SIZE: 0x00002000
// <i> rwx RAM:  ISRAM0_S from DFP:      BASE: 0x31000000  SIZE: 0x00200000
// <i> rwx RAM:  ISRAM1_S from DFP:      BASE: 0x31200000  SIZE: 0x00200000
// <i> rwx RAM:  QSPI_SRAM_S from DFP:   BASE: 0x38000000  SIZE: 0x00800000


#endif /* REGIONS_SSE_315_FVP_H */
