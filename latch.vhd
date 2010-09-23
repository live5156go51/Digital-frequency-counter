library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;

entity latch is
  
  port (
    lock_in        : in  std_logic;
    clr            : in  std_logic;
    cnt_to_latch   : in  std_logic_vector(13 downto 0);
    latch_out_seg  : out std_logic_vector(13 downto 0);
    cnt20_to_latch : in  std_logic_vector(7 downto 0);
    latch_out_led  : out std_logic_vector(7 downto 0));
end latch;

architecture behav_latch of latch is

begin  -- behav_latch

  process (clr, lock_in, cnt_to_latch, cnt20_to_latch)
  begin  -- process
    if clr = '1' then
      latch_out_seg <= (others => '0');
      latch_out_led <= (others => '0');  --  Õ‚≤ø«Â¡„
    elsif lock_in'event and lock_in = '1' then
      latch_out_seg <= cnt_to_latch;
      latch_out_led <= cnt20_to_latch;
    end if;
  end process;
  
end behav_latch;
