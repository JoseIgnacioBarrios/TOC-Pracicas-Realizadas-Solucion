----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2019 16:30:18
-- Design Name: 
-- Module Name: multiplexor3a1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplexor3a1 is
generic(
		bits_entradas: positive := 32
	); 
	port( 
		entrada0	: in  std_logic_vector(bits_entradas-1 downto 0); 
		entrada1	: in  std_logic_vector(bits_entradas-1 downto 0);
		entrada2    : in  std_logic_vector(bits_entradas-1 downto 0);
		seleccion: in  std_logic_vector(1 downto 0); 
		salida	    : out std_logic_vector(bits_entradas-1 downto 0)  
	); 
end multiplexor3a1; 

architecture multiplexor3a1Arch of multiplexor3a1 is 

begin 

	salida <= entrada0 when (seleccion = "00") else 
	           entrada1 when (seleccion ="01")else
	           entrada2 ;
	
end multiplexor3a1Arch;
