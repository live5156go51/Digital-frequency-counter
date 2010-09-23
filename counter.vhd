--¼ÆÊýÆ÷
--
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.STD_LOGIC_ARITH.all;
entity counter is
  
  port (
    clr                : in  std_logic;
    rst                : in  std_logic;
    door_in            : in  std_logic;
    signal_in          : in  std_logic;
    result_cnt_out     : out std_logic_vector(13 downto 0);
    led_result_cnt_out : out std_logic_vector(7 downto 0));

end counter;

architecture behav_counter of counter is
  
  signal result_cnt_out_tmp     : std_logic_vector(3 downto 0);
  signal cnt_cnt_tmp            : std_logic;
  signal cnt_to_cnt_tmp         : std_logic;
  signal second_result_cnt_out_tmp : std_logic_vector(13 downto 0);
  signal result_ci_tmp          : std_logic;
  signal led_result_cnt_out_tmp : std_logic_vector(7 downto 0);
  
begin  -- behav_cnt_100_div

  process (clr, rst, door_in, signal_in)
  begin  -- process
    if (rst = '1' or clr = '1') then
      result_cnt_out_tmp <= (others => '0');
    elsif signal_in'event and signal_in = '1' then
      if door_in = '1' then
        result_cnt_out_tmp <= result_cnt_out_tmp + 1;
        if result_cnt_out_tmp < X"4" then
          result_cnt_out_tmp <= result_cnt_out_tmp + 1;
          cnt_cnt_tmp        <= '0';
        elsif result_cnt_out_tmp < X"9" then
          result_cnt_out_tmp <= result_cnt_out_tmp + 1;
          cnt_cnt_tmp        <= '1';
        elsif result_cnt_out_tmp = X"9" then
          result_cnt_out_tmp <= (others => '0');
          cnt_cnt_tmp        <= '0';
        end if;
      end if;
    end if;
  end process;

  cnt_to_cnt_tmp <= cnt_cnt_tmp;

  process (clr, rst, cnt_to_cnt_tmp)
  begin  -- process
    if (clr = '1' or rst = '1') then
      second_result_cnt_out_tmp <= (others => '0');
      result_ci_tmp          <= '1';
    elsif cnt_to_cnt_tmp'event and cnt_to_cnt_tmp = '1' then
      if door_in = '1' then
        if (result_cnt_out_tmp = X"270F") then        -- X"270F" = 9999
          second_result_cnt_out_tmp <= (others => '0');  --when 9999 then cnt=0
          result_ci_tmp          <= '1';  --when 9999 then ci->'1' !!!
        elsif (second_result_cnt_out_tmp < X"1388") then          --X"1388"=5000
          result_ci_tmp          <= '1';
          second_result_cnt_out_tmp <= second_result_cnt_out_tmp+1;
        elsif (second_result_cnt_out_tmp < X"270F") then
          result_ci_tmp          <= '0';
          second_result_cnt_out_tmp <= second_result_cnt_out_tmp+1;  -- cnt<9999,keep counting
        end if;
      end if;
    end if;
  end process;

  result_cnt_out <= second_result_cnt_out_tmp;

  process (clr, rst, result_ci_tmp)
  begin  -- process
    if (clr = '1' or rst = '1') then
      led_result_cnt_out_tmp <= (others => '0');
      
    elsif (result_ci_tmp' event and result_ci_tmp = '1') then  --from former counter's Ci signal!!
      if door_in = '1' then
        led_result_cnt_out_tmp <= led_result_cnt_out_tmp+1;  -- cnt<9999,keep counting
      end if;

    end if;
  end process;

  led_result_cnt_out <= led_result_cnt_out_tmp;  --drive LED
  
end behav_counter;
