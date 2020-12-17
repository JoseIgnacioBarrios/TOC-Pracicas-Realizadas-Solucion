----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2019 11:28:16
-- Design Name: 
-- Module Name: gen_patrones - Behavioral
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

entity gen_patrones is
  port(clk           : in  std_logic;   -- Input clock
       reset         : in  std_logic;   -- General reset
       pattern       : in  std_logic_vector(1 downto 0);
       leds	      	: out  std_logic_vector(9 downto 0)    
       );
end gen_patrones;

architecture Behavioral of gen_patrones is
	type ESTADOS is (s0,s1,s2,s3,s4);
	signal current_state, next_state : ESTADOS;
	signal load : std_logic;
	signal selector : std_logic_vector(1 downto 0);
	signal atraer: std_logic_vector(19 downto 0);
	signal mala_suerte: std_logic_vector(9 downto 0);
	signal premio: std_logic_vector(9 downto 0);
	signal mux_output: std_logic_vector(9 downto 0);
begin

	SINCRONO: process (clk, reset)
		begin
		
		if reset='1' then
			current_state<=s0;
		elsif rising_edge(clk) then
			current_state<=next_state;
		end if;
	end process SINCRONO;
	
	COMB: process (current_state, pattern)
		begin
		
		case current_state is
		when s0=>
				load<='0';
				selector<="00";
				if pattern="00" then
					next_state<=current_state;
				else
					next_state<=s1;
				end if;
		when s1=>
				load<='1';
				selector<="00";
				if pattern="00" then
					next_state<=s0;
				elsif pattern="01" then
					next_state<=s2;
				elsif pattern="10" then
					next_state<=s3;
				elsif pattern="11" then
					next_state<=s4;
				end if;	
		when s2=>
				load<='0';
				selector<="01";
				if pattern="00" then
					next_state<=s0;
				elsif pattern="01" then
					next_state<=current_state;
				else
					next_state<=s1;
				end if;
		when s3=>
				load<='0';
				selector<="10";
				if pattern="00" then
					next_state<=s0;
				elsif pattern="10" then
					next_state<=current_state;
				else
					next_state<=s1;
				end if;				
		when s4=>
				load<='0';
				selector<="11";
				if pattern="11" then
					next_state<=current_state;
				else
					next_state<=s0;
				end if;
		when others => 
				load<='0';
				selector<="00";
				next_state<=s0;
		end case;
		end process COMB;
		
------------------------------------------------------------------------------
   --Registros de la máquina	
------------------------------------------------------------------------------	
-----------------------------------------------------------------------------
-- Registro
-----------------------------------------------------------------------------
		reg_atraer : process (clk, reset,load) is
			variable aux : std_logic;
		begin
			if reset = '1' then
				atraer <= "00000000001111111111"; -- Inicializar con reset.
			elsif rising_edge(clk) then
				if load= '1' then
					atraer <= "00000000001111111111";
				else
					aux:=atraer(0);
					for i in 0 to 18 loop
						atraer(i)<=atraer(i+1);
					end loop;
					atraer(19)<=aux;
				end if;
			end if;
		end process reg_atraer;
-----------------------------------------------------------------------------
-- Registro
-----------------------------------------------------------------------------
		reg_mala_suerte : process (clk, reset,load) is
		begin
			if reset = '1' then
				mala_suerte <= "0101010101"; -- Inicializar con reset.
			elsif rising_edge(clk) then
				if load= '1' then
					mala_suerte <= "0101010101";
				else
					mala_suerte<= not(mala_suerte);
				end if;
			end if;
		end process reg_mala_suerte;
-----------------------------------------------------------------------------
-- Registro
-----------------------------------------------------------------------------
		reg_premio : process (clk, reset,load) is
		begin
			if reset = '1' then
				premio <= "0000000000"; -- Inicializar con reset.
			elsif rising_edge(clk) then
				if load= '1' then
					premio <= "0000000000";
				else
					premio<= not(premio);
				end if;
			end if;
		end process reg_premio;
-----------------------------------------------------------------------------
-- MUX de SALIDA
-----------------------------------------------------------------------------
		p_mux : process (atraer,mala_suerte,premio, selector) is
			begin
			if selector = "00" then
				mux_output <= (others => '0'); 
			elsif selector = "01" then
				mux_output <= atraer(19 downto 10);
			elsif selector = "10" then
				mux_output <= mala_suerte;
			elsif selector = "11" then
				mux_output <= premio;	
			end if;
		end process p_mux;
		
		leds<=mux_output;
end Behavioral;
