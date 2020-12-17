----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2019 11:28:16
-- Design Name: 
-- Module Name: divisor_multi_frec - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity divisor_multi_frec is
  port (
    rst          : in  std_logic;          -- asynch reset
    clk_100mhz   : in  std_logic;          -- 100 MHz input clock
    clk_1hz      : out std_logic;          -- 1 Hz output clock
	 clk_5hz      : out std_logic;          -- 5 Hz output clock
	 clk_75hz     : out std_logic;          -- 75 Hz output clock
	 clk_100hz    : out std_logic           -- 125 Hz output clock
    );
end divisor_multi_frec;

architecture Behavioral of divisor_multi_frec is
  -- signal cntr_reg    : std_logic_vector(25 downto 0);
  -- Con una entrada de clk de 100MHz exactos se necesitan 26 bits para sacar 1Hz
  signal cntr_regA    : std_logic_vector(25 downto 0);
  signal cntr_regB    : std_logic_vector(24 downto 0);
  signal cntr_regC    : std_logic_vector(20 downto 0);
  signal cntr_regD    : std_logic_vector(19 downto 0);
  signal clk_1hz_reg   : std_logic;
  signal clk_5hz_reg   : std_logic;
  signal clk_75hz_reg  : std_logic;
  signal clk_100hz_reg : std_logic;
  
begin
-----------
-- Reloj de 1 Hz
------------
  p_cntrA : process(rst, clk_100mhz)
  begin
    if (rst = '1') then
      cntr_regA    <= (others => '0');
      clk_1hz_reg <= '0';
    elsif rising_edge(clk_100mhz) then
      --if (cntr_reg = "10111110101111000010000000") then
		-- Con una entrada de clk de 100MHz exactos se necesita este valor en bits para sacar 1Hz
		if (cntr_regA = "10111110101111000010000000") then
        clk_1hz_reg <= not clk_1hz_reg;
        cntr_regA    <= (others => '0');
      else
        cntr_regA    <= cntr_regA + 1;
        clk_1hz_reg <= clk_1hz_reg;
      end if;
    end if;
  end process p_cntrA;

-----------
-- Reloj de 5 Hz
------------
  p_cntrB : process(rst, clk_100mhz)
  begin
    if (rst = '1') then
      cntr_regB    <= (others => '0');
      clk_5hz_reg <= '0';
    elsif rising_edge(clk_100mhz) then
      --if (cntr_reg = "1001100010010110100000000") then
		-- Con una entrada de clk de 100MHz exactos se necesita este valor en bits para sacar 5Hz
		if (cntr_regB = "1001100010010110100000000") then
        clk_5hz_reg <= not clk_5hz_reg;
        cntr_regB    <= (others => '0');
      else
        cntr_regB    <= cntr_regB + 1;
        clk_5hz_reg <= clk_5hz_reg;
      end if;
    end if;
  end process p_cntrB;


-----------
-- Reloj de 75 Hz
------------
  p_cntrC : process(rst, clk_100mhz)
  begin
    if (rst = '1') then
      cntr_regC    <= (others => '0');
      clk_75hz_reg <= '0';
    elsif rising_edge(clk_100mhz) then
      --if (cntr_reg = "101000101100001010101") then
		-- Con una entrada de clk de 100MHz exactos se necesita este valor en bits para sacar 75Hz
		if (cntr_regC = "101000101100001010101") then
        clk_75hz_reg <= not clk_75hz_reg;
        cntr_regC    <= (others => '0');
      else
        cntr_regC    <= cntr_regC + 1;
        clk_75hz_reg <= clk_75hz_reg;
      end if;
    end if;
  end process p_cntrC;



-----------
-- Reloj de 100 Hz
------------
  p_cntrD : process(rst, clk_100mhz)
  begin
    if (rst = '1') then
      cntr_regD    <= (others => '0');
      clk_100hz_reg <= '0';
    elsif rising_edge(clk_100mhz) then
      --if (cntr_reg = "11110100001001000000") then
		-- Con una entrada de clk de 100MHz exactos se necesita este valor en bits para sacar 100Hz
		if (cntr_regD = "11110100001001000000") then
        clk_100hz_reg <= not clk_100hz_reg;
        cntr_regD    <= (others => '0');
      else
        cntr_regD    <= cntr_regD + 1;
        clk_100hz_reg <= clk_100hz_reg;
      end if;
    end if;
  end process p_cntrD;
----------------------------------------------------
----------------------------------------------------
  clk_1hz <= clk_1hz_reg;
  clk_5hz <= clk_5hz_reg;
  clk_75hz <= clk_75hz_reg;
  clk_100hz <= clk_100hz_reg;

end Behavioral;


