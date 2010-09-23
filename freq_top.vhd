-------------------------------------------------------------------------------
-- Title      : 频率计的顶层文件
-- Project    : 精度为100Hz频率计
-------------------------------------------------------------------------------
-- File       : freq_top.vhd
-- Author     :   <lijunpeng@gmail.com>
-- Company    : 
-- Created    : 2010-09-07
-- Last update: 2010-09-07
-- Platform   : Xilinx Spartan 3E XC3S500E
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 元件:  clkdiv分频器 counter计数器
--                    latch锁存器 decoder译码器 x7segbc 数码管显示
-- 本项目低位用数码管显示，高位用LED显示（8421BCD)
-------------------------------------------------------------------------------
-- Copyright (c) 2010 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2010-09-07  1.0      lijunpeng	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;

entity freq_top is
  
  port (
    clk_50Mhz   : in  std_logic;        --标准50mhz
    clr_all     : in  std_logic;        --全局清零
    sig_test_in : in  std_logic;        --待测频率
    a_to_g      : out std_logic_vector(6 downto 0);
    an          : out std_logic_vector(3 downto 0);
    dp          : out std_logic;
    LED         : out std_logic_vector (7 downto 0)
    );

end freq_top;

architecture behav_freq_top of freq_top is
  component clkdiv
    port (
      clk       : in  std_logic;
      clr       : in  std_logic;
      clk_190hz : out std_logic;
      en_door   : out std_logic;
      en_latch  : out std_logic;
      rst       : out std_logic);
  end component;
  
  component counter
    port (
      clr                : in  std_logic;
      rst                : in  std_logic;
      door_in            : in  std_logic;
      signal_in          : in  std_logic;
      result_cnt_out     : out std_logic_vector(13 downto 0);
      led_result_cnt_out : out std_logic_vector(7 downto 0));

  end component;
  
  component latch
    port (
      lock_in        : in  std_logic;
      clr            : in  std_logic;
      cnt_to_latch   : in  std_logic_vector(13 downto 0);
      latch_out_seg  : out std_logic_vector(13 downto 0);
      cnt20_to_latch : in  std_logic_vector(7 downto 0);
      latch_out_led  : out std_logic_vector(7 downto 0));
  end component;

  component decoder
    port (
      b  : in  std_logic_vector(13 downto 0);
      b1 : in  std_logic_vector(7 downto 0);
      p1 : out std_logic_vector(7 downto 0);
      p  : out std_logic_vector(16 downto 0));
  end component;
  
  component x7segbc
    port (
      x      : in  std_logic_vector(15 downto 0);
      cclk   : in  std_logic;
      clr    : in  std_logic;
      a_to_g : out std_logic_vector(6 downto 0);
      an     : out std_logic_vector(3 downto 0);
      dp     : out std_logic);
  end component;

  signal clk_1hz_tmp          : std_logic;  -- 分频1Hz连接en_control
  signal clk_190hz_tmp        : std_logic;  -- 分频190Hz连????码????砟康?  
  signal en_latch_tmp         : std_logic;  -- 1hz,2分频使能??接??latch
  signal en_door_tmp          : std_logic;
  signal rst_clkdiv_to_cnt    : std_logic;  -- 清零信号
  signal cnt_out_cnt_tmp      : std_logic;
  signal cnt_ci_tmp           : std_logic;
  signal cnt_to_latch_tmp     : std_logic_vector(13 downto 0);
  signal cnt20_to_latch_tmp   : std_logic_vector(7 downto 0);
  signal cnt20_latch_BCD_temp : std_logic_vector(7 downto 0);
  signal latch_to_bcd_tmp     : std_logic_vector(13 downto 0);
  signal bcd_to_x7seg_tmp     : std_logic_vector(16 downto 0);
  
begin  -- behav_frep_top

  U1 : clkdiv port map (
    clk       => clk_50Mhz,
    clr       => clr_all,
    clk_190hz => clk_190hz_tmp,
    en_door   => en_door_tmp,
    en_latch  => en_latch_tmp,
    rst       => rst_clkdiv_to_cnt);
  
  U2 : counter port map (
    clr                => clr_all,
    rst                => rst_clkdiv_to_cnt,
    door_in            => en_door_tmp,
    signal_in          => sig_test_in,
    result_cnt_out     => cnt_to_latch_tmp,
    led_result_cnt_out => cnt20_to_latch_tmp);

  U3 : latch port map (
    lock_in        => en_latch_tmp,
    clr            => clr_all,
    cnt_to_latch   => cnt_to_latch_tmp,
    latch_out_seg  => latch_to_bcd_tmp,
    cnt20_to_latch => cnt20_to_latch_tmp,
    latch_out_led  => cnt20_latch_BCD_temp);
  
  U4 : decoder port map (
    b  => latch_to_bcd_tmp,
    b1 => cnt20_latch_BCD_temp,
    p1 => LED,
    p  => bcd_to_x7seg_tmp);
  
  U5 : x7segbc port map (
    x      => bcd_to_x7seg_tmp(15 downto 0),
    cclk   => clk_190hz_tmp,
    clr    => clr_all,
    a_to_g => a_to_g,
    an     => an,
    dp     => dp);

end behav_freq_top;
