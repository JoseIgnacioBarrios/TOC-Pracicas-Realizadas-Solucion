----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2019 11:28:16
-- Design Name: 
-- Module Name: controller - Behavioral
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



entity controller is
    port (
      clk      : in  std_logic;         -- Input clock
      reset    : in  std_logic;         -- General reset
      inicio   : in  std_logic;         -- Start of algorithm
		parar    : in  std_logic;
		status   : in std_logic_vector(1 downto 0); 
		control  : out std_logic_vector(4 downto 0)
      );
end controller;

architecture Behavioral of controller is
		type t_st is (s0, s1, s2, s3, s4,s5);
		signal current_state, next_state : t_st;
		signal acierto, seg_fin    : std_logic;

		constant c_patron_1     : std_logic_vector(4 downto 0) := "10000";
		constant c_patron_0     : std_logic_vector(4 downto 0) := "01000";
		constant c_load_regs    : std_logic_vector(4 downto 0) := "00100";
		constant c_ce_conts  	: std_logic_vector(4 downto 0) := "00010";
		constant c_ce_seg		   : std_logic_vector(4 downto 0) := "00001";
begin
  (acierto, seg_fin) <= status;
 --------------------------------------------------------------------------------------
 -- Proceso Síncrono básico de toda máquina de estados.
 ------------------------------------------------------------------------------------
 
  p_sincrono : process (clk, reset) is
  begin
    if reset = '1' then
      current_state <= s0;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process  p_sincrono;
 
 --------------------------------------------------------------------------------------
 -- Proceso combinacional de toma de decisión de estado siguiente
 ------------------------------------------------------------------------------------
 p_next_state : process (current_state, inicio, acierto, seg_fin, parar) is
 begin
  case current_state is
      when s0 =>
       if inicio='1' then
			next_state<=s1;
		 else
			next_state<=s0;
		end if;
      when s1 =>
			next_state<=s2;
      when s2 =>
			if parar='1' then
				next_state<=s3;
			else
				next_state<=s2;
			end if;
      when s3 =>
			if acierto='0' then
				next_state<=s4;
			else
				next_state<=s5;
			end if;
		when s4 =>
			if seg_fin='0' then
				next_state<=current_state;
			else
				next_state<=s0;
			end if;
		when s5 =>
			if seg_fin='0' then
				next_state<=current_state;
			else
				next_state<=s0;
			end if;
       when others => null;
    end case;
 
 end process p_next_state;
 
 --------------------------------------------------------------------------------------
 -- Proceso combinacional de cálculo de salida de máquina Moore. Sólo depende de current_state
 -- Se usan constantes "one-hot" para configurar la salida de control.
 ------------------------------------------------------------------------------------
 p_outputs : process (current_state) is
 begin
 control<= (others => '0');
 case current_state is
      when s0 =>
			control<= c_patron_0;
      when s1 =>
			control<= c_load_regs ;
      when s2 =>
			 control<= c_ce_conts;
      when s3 =>
			 control<= (others => '0');
      when s4 =>
			control<= c_patron_1 or c_ce_seg;
      when s5 =>
			control<= c_patron_1 or c_patron_0 or c_ce_seg;
       when others => null;
    end case;
 end process p_outputs;


end Behavioral;


