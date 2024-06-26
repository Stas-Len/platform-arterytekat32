/*
*****************************************************************************
**
**  File        : AT32F413xC_FLASH_ZW.ld
**
**  Abstract    : Linker script for AT32F413xC Device with
**                256KByte FLASH_ZW, 32KByte RAM
**
**                Set heap size, stack size and stack location according
**                to application requirements.
**
**                Set memory bank area and size if external memory is used.
**
**  Target      : Artery Tek AT32
**
**  Environment : Arm gcc toolchain
**
*****************************************************************************
*/

/* Entry Point */
ENTRY(Reset_Handler)

/* Highest address of the user mode stack */
_estack = 0x20008000;    /* end of RAM */

/* Generate a link error if heap and stack don't fit into RAM */
_Min_Heap_Size = 0x200;      /* required amount of heap  */
_Min_Stack_Size = 0x400; /* required amount of stack */

/* Specify the memory areas */
MEMORY
{
FLASH_ZW (rx)   : ORIGIN = 0x08000000, LENGTH = 96K
FLASH_SL (rx)   : ORIGIN = 0x08018000, LENGTH = 160K
RAM (xrw)       : ORIGIN = 0x20000000, LENGTH = 32K
SPIM (rx)       : ORIGIN = 0x08400000, LENGTH = 16384K
}

/* Define output sections */
SECTIONS
{
  /* The startup code goes first into FLASH_ZW */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector)) /* Startup code */
    . = ALIGN(4);
  } >FLASH_ZW

  /* The program code and other data goes into slow FLASH_SL */
  .text_sl :
  {
    _stext_sl = .;
    . = ALIGN(4);
    *(.text.sl)           /* .text.sl sections (code) */
    *(.text.sl*)          /* .text.sl* sections (code) */
    *(.text.your_own_funcs)  /* .slowtext* sections (code) */

    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    _etext_sl = .;        /* define a global symbols at end of slow code */
  } >FLASH_SL

  /* The program code and other data goes into FLASH_ZW */
  .text :
  {
    . = ALIGN(4);
    *(.text)           /* .text sections (code) */
    *(.text*)          /* .text* sections (code) */
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */
    *(.eh_frame)

    . = ALIGN(4);
  } >FLASH_ZW

  /* Constant data goes into FLASH_ZW */
  .rodata :
  {
    _stext = .;
    . = ALIGN(4);
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)
    . = ALIGN(4);
  } >FLASH_ZW

  .ARM.extab   : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >FLASH_SL
  .ARM : {
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
  } >FLASH_SL

  .preinit_array     :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } >FLASH_SL
  .init_array :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
  } >FLASH_SL
  .fini_array :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } >FLASH_SL

  /* used by the startup to initialize data */
  _sidata = LOADADDR(.data);

  /* Initialized data sections goes into RAM, load LMA copy after code */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */

    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */
  } >RAM AT> FLASH_SL

  _spim_init_base = LOADADDR(.spim);
  _spim_init_length = SIZEOF(.spim);

  .spim :
  {
    . = ALIGN(4);
    _spim_start = .;        /* create a global symbol at spim start */
    *(.spim)                /* .spim sections */
    *(.spim*)               /* .spim* sections */
    . = ALIGN(4);
    _spim_end = .;         /* define a global symbols at end of spim */
  } >SPIM

  /* Uninitialized data section */
  . = ALIGN(4);
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss secion */
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)
    _sstack = .;

    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
    __bss_end__ = _ebss;
  } >RAM

  /* User_heap_stack section, used to check that there is enough RAM left */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } >RAM

  /* Remove information from the standard libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  .ARM.attributes 0 : { *(.ARM.attributes) }
}
