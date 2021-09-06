library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulo_60_counter is
port(
	rst_n : in std_logic;-- active low synchronous reset
	clk : in std_logic;-- system clock
	clr_n : in std_logic;-- active low synchronous clear
	load_en : in std_logic;-- parallel load active high
	setting : in std_logic_vector(6 downto 0);-- load value
	cnt_en_1 : in std_logic;-- enable count 1
	cnt_en_2 : in std_logic;-- enable count 2
	max_count : out std_logic;-- maximum count flag
	count : out std_logic_vector(6 downto 0)-- BCD count
);
end modulo_60_counter;

architecture behavior of modulo_60_counter is

begin
	p1: process(rst_n,clk,clr_n,load_en,setting, cnt_en_1, cnt_en_2)
	
	variable counter_ones : integer := 0;
	variable counter_tens : integer := 0;
	
	begin
		if rising_edge(clk) then
			if (rst_n = '0') or (clr_n = '0') then
				counter_ones := 0;
				counter_tens := 0;
			elsif (load_en = '1') then
				counter_ones := to_integer(unsigned(setting(3 downto 0)));
				counter_tens := to_integer(unsigned(setting(6 downto 4)));
			elsif (cnt_en_2 = '1') then
				if (cnt_en_1 = '1') then
					if (counter_ones < 9) then
						counter_ones := counter_ones + 1; 
					elsif (counter_ones >= 9) then
						if (counter_tens >= 5) then
							counter_tens := 0;
						else
							counter_tens := counter_tens + 1;
						end if;
						counter_ones := 0;
						
					end if;
				end if;
			end if;
		end if;
		
		if (counter_tens = 5) and (counter_ones = 9) then
			max_count <= '1';
		else
			max_count <= '0';
		end if;
	
		count <= std_logic_vector(to_unsigned(counter_tens, 3)) & std_logic_vector(to_unsigned(counter_ones, 4));
	end process;
end behavior;