
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity x7segbc is
  port (x      : in  std_logic_vector (15 downto 0);
        cclk   : in  std_logic;
        clr    : in  std_logic;
        a_to_g : out std_logic_vector (6 downto 0);
        an     : out std_logic_vector (3 downto 0);
        dp     : out std_logic);
end x7segbc;

architecture Behavioral of x7segbc is

  signal s     : std_logic_vector(1 downto 0);
  signal digit : std_logic_vector(3 downto 0);
  signal aen   : std_logic_vector(3 downto 0);

begin
  dp     <= '0';
  aen(2) <= '1';
  aen(1) <= '1';
  aen(0) <= '1';
  
  process(s)
  begin
    case s is
      when "00"   => digit <= x(3 downto 0);		--dp<= '0';
      when "01"   => digit <= x(7 downto 4);		--dp<= '1';
      when "10"   => digit <= x(11 downto 8);	--dp<= '0';
      when others => digit <= x(15 downto 12);	--dp<= '0';
    end case;
  end process;
  process(digit)
  begin
    case digit is
      when x"0"   => a_to_g <= "1111110";  --"0000001";
      when x"1"   => a_to_g <= "0110000";  --"1001111";
      when x"2"   => a_to_g <= "1101101";  --"0010010";
      when x"3"   => a_to_g <= "1111001";  --"0000110";
      when x"4"   => a_to_g <= "0110011";  --"1001100";
      when x"5"   => a_to_g <= "1011011";  --"0100100";
      when x"6"   => a_to_g <= "1011111";  --"0100000";
      when x"7"   => a_to_g <= "1110000";  --"0001111";
      when x"8"   => a_to_g <= "1111111";  --"0000000";
      when x"9"   => a_to_g <= "1111011";  --"0000100";
      when x"A"   => a_to_g <= "1110111";  --"0001000";
      when x"B"   => a_to_g <= "0011111";  --"1100000";
      when x"C"   => a_to_g <= "1001110";  --"0110001";
      when x"D"   => a_to_g <= "0111101";  --"1000010";
      when x"E"   => a_to_g <= "1001111";  --"0110000";
      when others => a_to_g <= "1000111";  --"0111000";
    end case;
  end process;
  process(aen)
  begin
    an <= "0000";
    if(aen(conv_integer(s)) = '1') then
      an(conv_integer(s)) <= '1';
    end if;
  end process;
  process(cclk, clr)
  begin
    if(clr = '1') then
      s <= "00";
    elsif(rising_edge(cclk)) then
      s <= s+"01";
    end if;
  end process;

end Behavioral;

