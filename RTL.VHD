library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity simple_passthrough is
    Port (
        i_clk  : in STD_LOGIC;
        i_rst  : in STD_LOGIC;
        i_btn  : in STD_LOGIC;
        i_data : in STD_LOGIC_VECTOR(7 downto 0);
        o_data : out STD_LOGIC_VECTOR(7 downto 0) 
    );
end simple_passthrough;

architecture Behavioral of simple_passthrough is
    signal tmp : unsigned(25 downto 0);  -- 宣告為 unsigned 型別
    signal slow_clk: STD_LOGIC;
    signal shift_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');  -- 移位暫存器
begin
    process (i_clk, i_rst)
    begin
        if i_rst = '0' then
            tmp <= (others => '0');
        elsif rising_edge(i_clk) then
            tmp <= tmp + 1;
        end if;
    end process;
    slow_clk <= tmp(24);
    
    process (i_clk, i_rst)
    begin
        if i_rst = '0' then
            shift_reg <= (others => '0');
        elsif rising_edge(i_clk) then
           if i_btn ='1' then
              shift_reg <= i_data;
           else
              shift_reg <=shift_reg ;
           end if;
        end if;
    end process;
    
    process(slow_clk, i_rst)
    begin
        if i_rst = '0' then
            o_data <= (others=>'0');
        elsif rising_edge(slow_clk) then
            o_data <=  shift_reg;
        end if;
    end process;
end Behavioral;
