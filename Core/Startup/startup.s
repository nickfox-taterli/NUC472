  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

.global  g_pfnVectors
.global  Default_Handler

/* start address for the initialization values of the .data section. 
defined in linker script */
.word  _sidata
/* start address for the .data section. defined in linker script */  
.word  _sdata
/* end address for the .data section. defined in linker script */
.word  _edata
/* start address for the .bss section. defined in linker script */
.word  _sbss
/* end address for the .bss section. defined in linker script */
.word  _ebss
/* stack used for SystemInit_ExtMemCtl; always internal RAM used */

/**
 * @brief  This is the code that gets called when the processor first
 *          starts execution following a reset event. Only the absolutely
 *          necessary set is performed, after which the application
 *          supplied main() routine is called. 
 * @param  None
 * @retval : None
*/

    .section  .text.Reset_Handler
  .weak  Reset_Handler
  .type  Reset_Handler, %function
Reset_Handler:  
  ldr   sp, =_estack    		 /* set stack pointer */

/* Call the clock system initialization function.*/
  bl  SystemInit   

/* Copy the data segment initializers from flash to SRAM */  
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit
  
/* Zero fill the bss segment. */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* Call static constructors */
    bl __libc_init_array
/* Call the application's entry point.*/
  bl  main
  bx  lr    
.size  Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an 
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 * @param  None     
 * @retval None       
*/
    .section  .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b  Infinite_Loop
  .size  Default_Handler, .-Default_Handler
/******************************************************************************
*
* The minimal vector table for a Cortex M3. Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
* 
*******************************************************************************/
   .section  .isr_vector,"a",%progbits
  .type  g_pfnVectors, %object
    
g_pfnVectors:
  .word  _estack
  .word  Reset_Handler
  .word  NMI_Handler
  .word  HardFault_Handler
  .word  MemManage_Handler
  .word  BusFault_Handler
  .word  UsageFault_Handler
  .word  0
  .word  0
  .word  0
  .word  0
  .word  SVC_Handler
  .word  DebugMon_Handler
  .word  0
  .word  PendSV_Handler
  .word  SysTick_Handler
  
  /* External Interrupts */
	.long	BOD_IRQHandler        /*  0: BOD                        */
	.long	IRC_IRQHandler        /*  1: IRC                        */
	.long	PWRWU_IRQHandler      /*  2: PWRWU                      */
	.long	RAMPE_IRQHandler      /*  3: RAMPE                      */
	.long	CKFAIL_IRQHandler     /*  4: CKFAIL                     */
	.long	0                     /*  5: Reserved                   */
	.long	RTC_IRQHandler        /*  6: RTC                        */
	.long	TAMPER_IRQHandler     /*  7: TAMPER                     */
	.long	EINT0_IRQHandler      /*  8: EINT0                      */
	.long	EINT1_IRQHandler      /*  9: EINT1                      */
	.long	EINT2_IRQHandler      /* 10: EINT2                      */
	.long	EINT3_IRQHandler      /* 11: EINT3                      */
	.long	EINT4_IRQHandler      /* 12: EINT4                      */
	.long	EINT5_IRQHandler      /* 13: EINT5                      */
	.long	EINT6_IRQHandler      /* 14: EINT6                      */
	.long	EINT7_IRQHandler      /* 15: EINT7                      */
	.long	GPA_IRQHandler        /* 16: GPA                        */
	.long	GPB_IRQHandler        /* 17: GPB                        */
	.long	GPC_IRQHandler        /* 18: GPC                        */
	.long	GPD_IRQHandler        /* 19: GPD                        */
	.long	GPE_IRQHandler        /* 20: GPE                        */
	.long	GPF_IRQHandler        /* 21: GPF                        */
	.long	GPG_IRQHandler        /* 22: GPG                        */
	.long	GPH_IRQHandler        /* 23: GPH                        */
	.long	GPI_IRQHandler        /* 24: GPI                        */
	.long	0                     /* 25: Reserved                   */
	.long	0                     /* 26: Reserved                   */
	.long	0                     /* 27: Reserved                   */
	.long	0                     /* 28: Reserved                   */
	.long	0                     /* 29: Reserved                   */
	.long	0                     /* 30: Reserved                   */
	.long	0                     /* 31: Reserved                   */
	.long	TMR0_IRQHandler       /* 32: TIMER0                     */
	.long	TMR1_IRQHandler       /* 33: TIMER1                     */
	.long	TMR2_IRQHandler       /* 34: TIMER2                     */
	.long	TMR3_IRQHandler       /* 35: TIMER3                     */
	.long	0                     /* 36: Reserved                   */
	.long	0                     /* 37: Reserved                   */
	.long	0                     /* 38: Reserved                   */
	.long	0                     /* 39: Reserved                   */
	.long	PDMA_IRQHandler       /* 40: PDMA                       */
	.long	0                     /* 41: Reserved                   */
	.long	ADC_IRQHandler        /* 42: ADC                        */
	.long	0                     /* 43: Reserved                   */
	.long	0                     /* 44: Reserved                   */
	.long	0                     /* 45: Reserved                   */
	.long	WDT_IRQHandler        /* 46: WDT                        */
	.long	WWDT_IRQHandler       /* 47: WWDT                       */
	.long	EADC0_IRQHandler      /* 48: EADC0                      */
	.long	EADC1_IRQHandler      /* 49: EADC1                      */
	.long	EADC2_IRQHandler      /* 50: EADC2                      */
	.long	EADC3_IRQHandler      /* 51: EADC3                      */
	.long	0                     /* 52: Reserved                   */
	.long	0                     /* 53: Reserved                   */
	.long	0                     /* 54: Reserved                   */
	.long	0                     /* 55: Reserved                   */
	.long	ACMP_IRQHandler       /* 56: ACMP                       */
	.long	0                     /* 57: Reserved                   */
	.long	0                     /* 58: Reserved                   */
	.long	0                     /* 59: Reserved                   */
	.long	OPA0_IRQHandler       /* 60: OPA0                       */
	.long	OPA1_IRQHandler       /* 61: OPA1                       */
	.long	ICAP0_IRQHandler      /* 62: ICAP0                      */
	.long	ICAP1_IRQHandler      /* 63: ICAP1                      */
	.long	PWM0CH0_IRQHandler    /* 64: PWM00                      */
	.long	PWM0CH1_IRQHandler    /* 65: PWM01                      */
	.long	PWM0CH2_IRQHandler    /* 66: PWM02                      */
	.long	PWM0CH3_IRQHandler    /* 67: PWM03                      */
	.long	PWM0CH4_IRQHandler    /* 68: PWM04                      */
	.long	PWM0CH5_IRQHandler    /* 69: PWM05                      */
	.long	PWM0_BRK_IRQHandler   /* 70: PWM0BRK                    */
	.long	QEI0_IRQHandler       /* 71: QEI0                       */
	.long	PWM1CH0_IRQHandler    /* 72: PWM10                      */
	.long	PWM1CH1_IRQHandler    /* 73: PWM11                      */
	.long	PWM1CH2_IRQHandler    /* 74: PWM12                      */
	.long	PWM1CH3_IRQHandler    /* 75: PWM13                      */
	.long	PWM1CH4_IRQHandler    /* 76: PWM14                      */
	.long	PWM1CH5_IRQHandler    /* 77: PWM15                      */
	.long	PWM1_BRK_IRQHandler   /* 78: PWM1BRK                    */
	.long	QEI1_IRQHandler       /* 79: QEI1                       */
	.long	EPWM0_IRQHandler      /* 80: EPWM0                      */
	.long	EPWM0BRK_IRQHandler   /* 81: EPWM0BRK                   */
	.long	EPWM1_IRQHandler      /* 82: EPWM1                      */
	.long	EPWM1BRK_IRQHandler   /* 83: EPWM1BRK                   */
	.long	0                     /* 84: Reserved                   */
	.long	0                     /* 85: Reserved                   */
	.long	0                     /* 86: Reserved                   */
	.long	0                     /* 87: Reserved                   */
	.long	USBD_IRQHandler       /* 88: USBD                       */
	.long	USBH_IRQHandler       /* 89: USBH                       */
	.long	USB_OTG_IRQHandler    /* 90: USBOTG                     */
	.long	0                     /* 91: Reserved                   */
	.long	EMAC_TX_IRQHandler    /* 92: EMAXTC                     */
	.long	EMAC_RX_IRQHandler    /* 93: EMACRX                     */
	.long	0                     /* 94: Reserved                   */
	.long	0                     /* 95: Reserved                   */
	.long	SPI0_IRQHandler       /* 96: SPI0                       */
	.long	SPI1_IRQHandler       /* 97: SPI1                       */
	.long	SPI2_IRQHandler       /* 98: SPI2                       */
	.long	SPI3_IRQHandler       /* 99: SPI3                       */
	.long	0                     /* 100: Reserved                  */
	.long	0                     /* 101: Reserved                  */
	.long	0                     /* 102: Reserved                  */
	.long	0                     /* 103: Reserved                  */
	.long	UART0_IRQHandler      /* 104: UART0                     */
	.long	UART1_IRQHandler      /* 105: UART1                     */
	.long	UART2_IRQHandler      /* 106: UART2                     */
	.long	UART3_IRQHandler      /* 107: UART3                     */
	.long	UART4_IRQHandler      /* 108: UART4                     */
	.long	UART5_IRQHandler      /* 109: UART5                     */
	.long	0                     /* 110: Reserved                  */
	.long	0                     /* 111: Reserved                  */
	.long	I2C0_IRQHandler       /* 112: I2C0                      */
	.long	I2C1_IRQHandler       /* 113: I2C1                      */
	.long	I2C2_IRQHandler       /* 114: I2C2                      */
	.long	I2C3_IRQHandler       /* 115: I2C3                      */
	.long	I2C4_IRQHandler       /* 116: I2C4                      */
	.long	0                     /* 117: Reserved                  */
	.long	0                     /* 118: Reserved                  */
	.long	0                     /* 119: Reserved                  */
	.long	SC0_IRQHandler        /* 120: SC0                       */
	.long	SC1_IRQHandler        /* 121: SC1                       */
	.long	SC2_IRQHandler        /* 122: SC2                       */
	.long	SC3_IRQHandler        /* 123: SC3                       */
	.long	SC4_IRQHandler        /* 124: SC4                       */
	.long	SC5_IRQHandler        /* 125: SC5                       */
	.long	0                     /* 126: Reserved                  */
	.long	0                     /* 127: Reserved                  */
	.long	CAN0_IRQHandler       /* 128: CAN0                      */
	.long	CAN1_IRQHandler       /* 129: CAN1                      */
	.long	0                     /* 130: Reserved                  */
	.long	0                     /* 131: Reserved                  */
	.long	I2S0_IRQHandler       /* 132: I2S0                      */
	.long	I2S1_IRQHandler       /* 133: I2S1                      */
	.long	0                     /* 134: Reserved                  */
	.long	0                     /* 135: Reserved                  */
	.long	SD_IRQHandler         /* 136: SD                        */
	.long	0                     /* 137: Reserved                  */
	.long	PS2D_IRQHandler       /* 138: PS2D                      */
	.long	CAP_IRQHandler        /* 139: CAP                       */
	.long	CRYPTO_IRQHandler     /* 140: CRYPTO                    */
	.long	CRC_IRQHandler        /* 141: CRC                       */
                    

  .size  g_pfnVectors, .-g_pfnVectors

/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the Default_Handler. 
* As they are weak aliases, any function with the same name will override 
* this definition.
* 
*******************************************************************************/
   .weak      NMI_Handler
   .thumb_set NMI_Handler,Default_Handler
  
   .weak      HardFault_Handler
   .thumb_set HardFault_Handler,Default_Handler
  
   .weak      MemManage_Handler
   .thumb_set MemManage_Handler,Default_Handler
  
   .weak      BusFault_Handler
   .thumb_set BusFault_Handler,Default_Handler

   .weak      UsageFault_Handler
   .thumb_set UsageFault_Handler,Default_Handler

   .weak      SVC_Handler
   .thumb_set SVC_Handler,Default_Handler

   .weak      DebugMon_Handler
   .thumb_set DebugMon_Handler,Default_Handler

   .weak      PendSV_Handler
   .thumb_set PendSV_Handler,Default_Handler

   .weak      SysTick_Handler
   .thumb_set SysTick_Handler,Default_Handler              
  
   .weak      BOD_IRQHandler
   .thumb_set BOD_IRQHandler,Default_Handler

   .weak      IRC_IRQHandler
   .thumb_set IRC_IRQHandler,Default_Handler

   .weak      PWRWU_IRQHandler
   .thumb_set PWRWU_IRQHandler,Default_Handler

   .weak      RAMPE_IRQHandler
   .thumb_set RAMPE_IRQHandler,Default_Handler

   .weak      CKFAIL_IRQHandler
   .thumb_set CKFAIL_IRQHandler,Default_Handler

   .weak      RTC_IRQHandler
   .thumb_set RTC_IRQHandler,Default_Handler

   .weak      TAMPER_IRQHandler
   .thumb_set TAMPER_IRQHandler,Default_Handler

   .weak      EINT0_IRQHandler
   .thumb_set EINT0_IRQHandler,Default_Handler

   .weak      EINT1_IRQHandler
   .thumb_set EINT1_IRQHandler,Default_Handler

   .weak      EINT2_IRQHandler
   .thumb_set EINT2_IRQHandler,Default_Handler

   .weak      EINT3_IRQHandler
   .thumb_set EINT3_IRQHandler,Default_Handler

   .weak      EINT4_IRQHandler
   .thumb_set EINT4_IRQHandler,Default_Handler

   .weak      EINT5_IRQHandler
   .thumb_set EINT5_IRQHandler,Default_Handler

   .weak      EINT6_IRQHandler
   .thumb_set EINT6_IRQHandler,Default_Handler

   .weak      EINT7_IRQHandler
   .thumb_set EINT7_IRQHandler,Default_Handler

   .weak      GPA_IRQHandler
   .thumb_set GPA_IRQHandler,Default_Handler

   .weak      GPB_IRQHandler
   .thumb_set GPB_IRQHandler,Default_Handler

   .weak      GPC_IRQHandler
   .thumb_set GPC_IRQHandler,Default_Handler

   .weak      GPD_IRQHandler
   .thumb_set GPD_IRQHandler,Default_Handler

   .weak      GPE_IRQHandler
   .thumb_set GPE_IRQHandler,Default_Handler

   .weak      GPF_IRQHandler
   .thumb_set GPF_IRQHandler,Default_Handler

   .weak      GPG_IRQHandler
   .thumb_set GPG_IRQHandler,Default_Handler

   .weak      GPH_IRQHandler
   .thumb_set GPH_IRQHandler,Default_Handler

   .weak      GPI_IRQHandler
   .thumb_set GPI_IRQHandler,Default_Handler

   .weak      TMR0_IRQHandler
   .thumb_set TMR0_IRQHandler,Default_Handler

   .weak      TMR1_IRQHandler
   .thumb_set TMR1_IRQHandler,Default_Handler

   .weak      TMR2_IRQHandler
   .thumb_set TMR2_IRQHandler,Default_Handler

   .weak      TMR3_IRQHandler
   .thumb_set TMR3_IRQHandler,Default_Handler

   .weak      PDMA_IRQHandler
   .thumb_set PDMA_IRQHandler,Default_Handler

   .weak      ADC_IRQHandler
   .thumb_set ADC_IRQHandler,Default_Handler

   .weak      WDT_IRQHandler
   .thumb_set WDT_IRQHandler,Default_Handler

   .weak      WWDT_IRQHandler
   .thumb_set WWDT_IRQHandler,Default_Handler

   .weak      EADC0_IRQHandler
   .thumb_set EADC0_IRQHandler,Default_Handler

   .weak      EADC1_IRQHandler
   .thumb_set EADC1_IRQHandler,Default_Handler

   .weak      EADC2_IRQHandler
   .thumb_set EADC2_IRQHandler,Default_Handler

   .weak      EADC3_IRQHandler
   .thumb_set EADC3_IRQHandler,Default_Handler

   .weak      ACMP_IRQHandler
   .thumb_set ACMP_IRQHandler,Default_Handler

   .weak      OPA0_IRQHandler
   .thumb_set OPA0_IRQHandler,Default_Handler

   .weak      OPA1_IRQHandler
   .thumb_set OPA1_IRQHandler,Default_Handler

   .weak      ICAP0_IRQHandler
   .thumb_set ICAP0_IRQHandler,Default_Handler

   .weak      ICAP1_IRQHandler
   .thumb_set ICAP1_IRQHandler,Default_Handler

   .weak      PWM0CH0_IRQHandler
   .thumb_set PWM0CH0_IRQHandler,Default_Handler

   .weak      PWM0CH1_IRQHandler
   .thumb_set PWM0CH1_IRQHandler,Default_Handler

   .weak      PWM0CH2_IRQHandler
   .thumb_set PWM0CH2_IRQHandler,Default_Handler

   .weak      PWM0CH3_IRQHandler
   .thumb_set PWM0CH3_IRQHandler,Default_Handler

   .weak      PWM0CH4_IRQHandler
   .thumb_set PWM0CH4_IRQHandler,Default_Handler

   .weak      PWM0CH5_IRQHandler
   .thumb_set PWM0CH5_IRQHandler,Default_Handler

   .weak      PWM0_BRK_IRQHandler
   .thumb_set PWM0_BRK_IRQHandler,Default_Handler

   .weak      QEI0_IRQHandler
   .thumb_set QEI0_IRQHandler,Default_Handler

   .weak      PWM1CH0_IRQHandler
   .thumb_set PWM1CH0_IRQHandler,Default_Handler

   .weak      PWM1CH1_IRQHandler
   .thumb_set PWM1CH1_IRQHandler,Default_Handler

   .weak      PWM1CH2_IRQHandler
   .thumb_set PWM1CH2_IRQHandler,Default_Handler

   .weak      PWM1CH3_IRQHandler
   .thumb_set PWM1CH3_IRQHandler,Default_Handler

   .weak      PWM1CH4_IRQHandler
   .thumb_set PWM1CH4_IRQHandler,Default_Handler

   .weak      PWM1CH5_IRQHandler
   .thumb_set PWM1CH5_IRQHandler,Default_Handler

   .weak      PWM1_BRK_IRQHandler
   .thumb_set PWM1_BRK_IRQHandler,Default_Handler

   .weak      QEI1_IRQHandler
   .thumb_set QEI1_IRQHandler,Default_Handler

   .weak      EPWM0_IRQHandler
   .thumb_set EPWM0_IRQHandler,Default_Handler

   .weak      EPWM0BRK_IRQHandler
   .thumb_set EPWM0BRK_IRQHandler,Default_Handler

   .weak      EPWM1_IRQHandler
   .thumb_set EPWM1_IRQHandler,Default_Handler

   .weak      EPWM1BRK_IRQHandler
   .thumb_set EPWM1BRK_IRQHandler,Default_Handler

   .weak      USBD_IRQHandler
   .thumb_set USBD_IRQHandler,Default_Handler

   .weak      USBH_IRQHandler
   .thumb_set USBH_IRQHandler,Default_Handler

   .weak      USB_OTG_IRQHandler
   .thumb_set USB_OTG_IRQHandler,Default_Handler

   .weak      EMAC_TX_IRQHandler
   .thumb_set EMAC_TX_IRQHandler,Default_Handler

   .weak      EMAC_RX_IRQHandler
   .thumb_set EMAC_RX_IRQHandler,Default_Handler

   .weak      SPI0_IRQHandler
   .thumb_set SPI0_IRQHandler,Default_Handler

   .weak      SPI1_IRQHandler
   .thumb_set SPI1_IRQHandler,Default_Handler

   .weak      SPI2_IRQHandler
   .thumb_set SPI2_IRQHandler,Default_Handler

   .weak      SPI3_IRQHandler
   .thumb_set SPI3_IRQHandler,Default_Handler

   .weak      UART0_IRQHandler
   .thumb_set UART0_IRQHandler,Default_Handler

   .weak      UART1_IRQHandler
   .thumb_set UART1_IRQHandler,Default_Handler

   .weak      UART2_IRQHandler
   .thumb_set UART2_IRQHandler,Default_Handler

   .weak      UART3_IRQHandler
   .thumb_set UART3_IRQHandler,Default_Handler

   .weak      UART4_IRQHandler
   .thumb_set UART4_IRQHandler,Default_Handler

   .weak      UART5_IRQHandler
   .thumb_set UART5_IRQHandler,Default_Handler

   .weak      I2C0_IRQHandler
   .thumb_set I2C0_IRQHandler,Default_Handler

   .weak      I2C1_IRQHandler
   .thumb_set I2C1_IRQHandler,Default_Handler

   .weak      I2C2_IRQHandler
   .thumb_set I2C2_IRQHandler,Default_Handler

   .weak      I2C3_IRQHandler
   .thumb_set I2C3_IRQHandler,Default_Handler

   .weak      I2C4_IRQHandler
   .thumb_set I2C4_IRQHandler,Default_Handler

   .weak      SC0_IRQHandler
   .thumb_set SC0_IRQHandler,Default_Handler

   .weak      SC1_IRQHandler
   .thumb_set SC1_IRQHandler,Default_Handler

   .weak      SC2_IRQHandler
   .thumb_set SC2_IRQHandler,Default_Handler

   .weak      SC3_IRQHandler
   .thumb_set SC3_IRQHandler,Default_Handler

   .weak      SC4_IRQHandler
   .thumb_set SC4_IRQHandler,Default_Handler

   .weak      SC5_IRQHandler
   .thumb_set SC5_IRQHandler,Default_Handler

   .weak      CAN0_IRQHandler
   .thumb_set CAN0_IRQHandler,Default_Handler

   .weak      CAN1_IRQHandler
   .thumb_set CAN1_IRQHandler,Default_Handler

   .weak      I2S0_IRQHandler
   .thumb_set I2S0_IRQHandler,Default_Handler

   .weak      I2S1_IRQHandler
   .thumb_set I2S1_IRQHandler,Default_Handler

   .weak      SD_IRQHandler
   .thumb_set SD_IRQHandler,Default_Handler

   .weak      PS2D_IRQHandler
   .thumb_set PS2D_IRQHandler,Default_Handler

   .weak      CAP_IRQHandler
   .thumb_set CAP_IRQHandler,Default_Handler

   .weak      CRYPTO_IRQHandler
   .thumb_set CRYPTO_IRQHandler,Default_Handler

   .weak      CRC_IRQHandler
   .thumb_set CRC_IRQHandler,Default_Handler

