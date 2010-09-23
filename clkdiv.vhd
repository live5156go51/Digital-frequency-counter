--
--分频器 门控、计数清零
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;

entity clkdiv is
  
  port (
    clk       : in  std_logic;
    clr       : in  std_logic;
    clk_190hz : out std_logic;
    en_door   : out std_logic;
    en_latch  : out std_logic;
    rst       : out std_logic);

end clkdiv;

architecture behav_clkdiv of clkdiv is
  
  signal q           : std_logic_vector(24 downto 0);
  signal count       : std_logic_vector(27 downto 0);  -- 分频1Hz
  signal clkdiv_tmp  : std_logic;
  signal clk_1hz_tmp : std_logic;
  signal clk_en_tmp  : std_logic;                      --门控
  
begin
-- behav_clkdiv
-- purpose: 标准50MHz
-- type   : combinational
-- inputs : clk
-- outputs: 
  process (clk, clr)
  begin  -- process
    if (clr = '1') then                 -- 外部清零
      q          <= (others => '0');
      count      <= (others => '0');
      clkdiv_tmp <= not clkdiv_tmp;
    elsif (rising_edge(clk)) then
      q <= q+1;
      if (count = X"17D7840") then      --x"17d7840"=25000000
        count      <= (others => '0');
        clkdiv_tmp <= not clkdiv_tmp;
      else
        count <= count+1;
      end if;
    end if;
  end process;
  clk_1hz_tmp <= clkdiv_tmp;            -- 1Hz
  clk_190hz   <= q(17);                 -- 190Hz

  process(clk_1hz_tmp)
  begin  -- process
    if clk_1hz_tmp'event and clk_1hz_tmp = '1' then
      clk_en_tmp <= not clk_en_tmp;
    end if;
  end process;

  ------ purpose: 产生计数器清零信号
  ------ type   : combinational
  ------ inputs : clk,clk_div_tmp
  ------ outputs: 
  process (clk_1hz_tmp, clk_en_tmp)
  begin  -- process
    if clk_1hz_tmp = '0' and clk_en_tmp = '0' then
    rst <= '1';
  else
    rst <= '0';
  end if;
end process;
en_door  <= clk_en_tmp;
en_latch <= not clk_en_tmp;

end behav_clkdiv;
