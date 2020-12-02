library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity conv7_BCD_2Displays is
  port (x       : in  std_logic_vector (7 downto 0);
        display : out std_logic_vector (13 downto 0));
end conv7_BCD_2Displays;

architecture beh of conv7_BCD_2Displays is
	signal disp_decenas, disp_unidades : std_logic_vector (6 downto 0);
	signal binario_decenas, binario_unidades: std_logic_vector (3 downto 0);
	signal BCD: std_logic_vector (11 downto 0);
	constant c_99 : std_logic_vector (7 downto 0):= "01100011";
	
  component Bin8toBCD3 is
  port (binario       : in  std_logic_vector (7 downto 0);
        bcd3       	: out std_logic_vector (11 downto 0));
  end component;
begin
	---------------------------------------------------------------
	-- Un display tiene los bits de encendido de display puestos así
	-- disp(7 downto 0) - > g/f/e/d/c/b/a
	------------------------------------------------
	conversor_b: Bin8toBCD3 port map(x,BCD);
	display<= disp_decenas & disp_unidades;
	
	p_conversor_BCD: process (x, BCD) is
	begin
		if x > c_99 then
			binario_decenas  <="1111"; -- Si me paso de 99 sale FF en los displays
			binario_unidades <="1111";
		else
		  binario_decenas   <=BCD(7 downto 4);
		  binario_unidades  <=BCD(3 downto 0);
		end if;
	
	end process;

	  with binario_decenas select
		 disp_decenas <=
		 "0000110"            when "0001",
		 "1011011"            when "0010",
		 "1001111"            when "0011",
		 "1100110"            when "0100",
		 "1101101"            when "0101",
		 "1111101"            when "0110",
		 "0000111"            when "0111",
		 "1111111"            when "1000",
		 "1101111"            when "1001",
		 "1110111"            when "1010",
		 "1111100"            when "1011",
		 "0111001"            when "1100",
		 "1011110"            when "1101",
		 "1111001"            when "1110",
		 "1110001"            when "1111",
		 "0111111"            when others;

	
	 with binario_unidades select
			 disp_unidades <=
			 "0000110"            when "0001",
			 "1011011"            when "0010",
			 "1001111"            when "0011",
			 "1100110"            when "0100",
			 "1101101"            when "0101",
			 "1111101"            when "0110",
			 "0000111"            when "0111",
			 "1111111"            when "1000",
			 "1101111"            when "1001",
			 "1110111"            when "1010",
			 "1111100"            when "1011",
			 "0111001"            when "1100",
			 "1011110"            when "1101",
			 "1111001"            when "1110",
			 "1110001"            when "1111",
			 "0111111"            when others;


end beh;



