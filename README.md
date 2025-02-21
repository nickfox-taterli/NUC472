# NuTiny-SDK-NUC472 开发板移植项目

## 项目简介

前段时间在咸鱼捡垃圾的时候，偶然淘到了一块只要十几元的M4开发板——**NuTiny-SDK-NUC472**，主芯片是 **NUC472HI8AE**。这块板子虽然年代有点久远，但功能还挺丰富的，带以太网、USB、CAN总线、UART、SPI、I²C 等外设，感觉性价比超高！虽然官方早就停止更新资料了，官网也明确写着“不建议用于新设计”，但作为一个不信邪的垃圾佬，我觉得这板子还能再战！于是，我把它移植到了 **CLion** 里，方便用现代的开发环境来折腾它。

## 开发板特性

- **主芯片**: NUC472HI8AE
- **内核**: ARM® Cortex®-M4，带浮点运算单元和 DSP
- **主频**: 最高 84 MHz
- **工作电压**: 2.5V ~ 5.5V
- **存储**:
  - 512 KB Flash ROM (和 Data Flash 共用)
  - 64 KB SRAM
- **外设**:
  - 12位 ADC (最多 16 通道，最快速度 1 MSPS)
  - 16位 PWM (最多 16 通道)
  - 4 通道 32 位定时器
  - 实时时钟 (RTC)
  - 10/100Mbps 以太网 (支持 RMII 和 MII)
  - USB 2.0 OTG 和 USB 2.0 设备
  - 最多 2 通道 CAN 总线
  - 最多 6 通道支持 LIN 和 RS-485 的串口
  - UART x 12
  - 最多 4 通道 SPI 接口
  - 最多 5 通道 I²C (最高支持 1 MHz)
  - 最多 6 通道智能卡接口
  - 最多 2 通道 I²S
  - 最多 2 通道编码器接口

板子本身的功能比较简单，主要就是以太网、USB 和几个 LED，但芯片的功能还是挺强大的，适合用来折腾和学习。

## 开发环境

- **IDE**: CLion
- **调试工具**: OpenOCD (依赖 [OpenOCD-Nuvoton](https://github.com/OpenNuvoton/OpenOCD-Nuvoton) 移植版本)

## 项目结构

- **Docs**: 放了原理图、芯片手册之类的资料，都是从网上扒拉来的。
- **Src**: 项目源代码。
- **CMakeLists.txt**: CMake 配置文件，用来构建项目。

## 参考资料

- [NUC472HI8AE 芯片介绍](https://www.nuvoton.com/products/microcontrollers/arm-cortex-m4-mcus/nuc400-series/nuc472hi8ae/)
- [OpenOCD-Nuvoton 移植版本](https://github.com/OpenNuvoton/OpenOCD-Nuvoton)

## 注意事项

- 这块板子现在基本只能在咸鱼这种二手市场淘到了，官方早就停产了，资料也不更新了，所以用起来可能会有点折腾。
- 官方明确说了不建议用于新设计，所以建议大家还是以学习和实验为主，别用在正经项目里哈。