----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2019 11:28:16
-- Design Name: 
-- Module Name: datapath - Behavioral
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

entity datapath is
    port (
      clk      			: in  std_logic;    -- Input clock
      reset    			: in  std_logic;    -- General reset
		control 			   : in  std_logic_vector(4 downto 0);		
      status  				: out std_logic_vector(1 downto 0); 
		leds					: out std_logic_vector(9 downto 0);  
		 num1: out std_logic_vector (3 downto 0);
		 num2 : out std_logic_vector (3 downto 0)
      );
end datapath;

architecture Behavioral of datapath is
	signal patron : std_logic_vector (1 downto 0);
	signal load_regs,ce_conts,ce_seg : std_logic;
	signal acierto,seg_fin : std_logic;
	signal clock_1Hz, clock_5Hz,clock_75Hz,clock_100Hz : std_logic;
	signal cont1,cont2,seg,cont1_aux,cont2_aux : std_logic_vector(3 downto 0);
	signal mem_write : std_logic_vector(0 downto 0);
	signal mem_data_in : std_logic_vector (3 downto 0);
	signal address_1, address_2 : std_logic_vector (5 downto 0);
	signal num_aux_1 , num_aux_2 : std_logic_vector (3 downto 0);
	
	
  component gen_patrones
		port(clk           : in  std_logic;   -- Input clock
			reset           : in  std_logic;   -- General reset
			pattern         : in  std_logic_vector(1 downto 0);
			leds	          : out  std_logic_vector(9 downto 0)    
			);
	end component;
	
	component divisor_multi_frec
		  port (
			 rst          : in  std_logic;          -- asynch reset
			 clk_100mhz   : in  std_logic;          -- 100 MHz input clock
			 clk_1hz      : out std_logic;          -- 1 Hz output clock
			 clk_5hz      : out std_logic;          -- 5 Hz output clock
			 clk_75hz     : out std_logic;          -- 75 Hz output clock
			 clk_100hz    : out std_logic           -- 125 Hz output clock
			 );
	end component divisor_multi_frec;
	
	component conv7
		port (x       : in  std_logic_vector (3 downto 0);
				display : out std_logic_vector (6 downto 0));
		end component conv7;
	
	
	COMPONENT blk_mem_tragaperras
	  PORT (
		 clka : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 clkb : IN STD_LOGIC;
		 web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addrb : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 dinb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 doutb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	  );
	END COMPONENT;

begin

	(patron(1),patron(0),load_regs,ce_conts,ce_seg)<=control; -- control(4) es patron(1).
	 status <= (acierto & seg_fin);-- status(1) es acierto y  status(0) es seg_fin
	 mem_data_in<="0000";
	 mem_write<="0";
	 address_1<="00" & cont1;
	 address_2<="00" & cont2;
	 num1 <= cont1;
	 num2 <= cont2;
	 
  gp : gen_patrones port map (
    clk      => clock_5Hz,              -- Input clock
    reset    => reset,                  -- General reset
	 pattern	 => patron,
	 leds     => leds
    );
	 
	dfm : divisor_multi_frec port map (
    rst         => reset,        
    clk_100mhz  => clk,                  
	 clk_1hz	    => clock_1Hz,
	 clk_5hz     => clock_5Hz,
	 clk_75hz	 => clock_75Hz,
	 clk_100hz   => clock_100Hz
    );


	bram: blk_mem_tragaperras port map(
		clka => clk,
		wea => mem_write,
		addra => address_1,
		dina => mem_data_in,
		douta => num_aux_1,
		clkb => clk,
		web => mem_write,
		addrb => address_2,
		dinb => mem_data_in,
		doutb => num_aux_2	
	
	);
	
	----------------------------
	
----------------------

  p_cont1 : process (clock_75Hz, reset, load_regs,ce_conts) is
  
	  begin
		 if reset = '1' then
			cont1 <= (others => '0');
		 elsif rising_edge(clock_75Hz) then
			if load_regs = '1' then
			  cont1  <= (others => '0');
			else
				if (ce_conts='1')  then
					if (cont1 ="1001")  then
						cont1  <= (others => '0');
					else
						cont1<=cont1 +1;
					end if;
				end if;	
			end if;
		 end if;
	  end process p_cont1;
 
---------------------

  p_cont2 : process (clock_100Hz, reset, load_regs,ce_conts) is
  
	  begin
		 if reset = '1' then
			cont2 <= (others => '0');
		 elsif rising_edge(clock_100Hz) then
			if load_regs = '1' then
			  cont2  <= (others => '0');
			else
				if (ce_conts='1')  then
					if (cont2 ="1001")  then
						cont2  <= (others => '0');
					else
						cont2<=cont2 +1;
					end if;
				end if;	
			end if;
		 end if;
	  end process p_cont2;
 
----------------------
  p_seg : process (clock_1Hz, reset, load_regs,ce_seg) is
  
	  begin
		 if reset = '1' or  load_regs = '1' then
			seg <= (others => '0');
		 elsif rising_edge(clock_1Hz) then
			--if load_regs = '1' then
			  --seg  <= (others => '0');
			if ce_seg='1' then
			  seg<=seg+1;
			end if;
		 end if;
	  end process p_seg;

-------------------------------------------------
-- Comparadores
-----------------------------------
   p_comp_conts : process (num_aux_1, num_aux_2) is
  
	  begin
--	   cont1_aux <= num_aux_1;
--	   cont2_aux <= num_aux_2;
			if cont1 = cont2 then
				acierto<= '1';
			else
				acierto<= '0';
			end if;			
	  end process p_comp_conts;
-----------------------------------------------------------------------	  
	p_comp_seg : process (seg) is
  
	  begin
			if seg >= "1010" then
				seg_fin<='1';
			else
				seg_fin<='0';
			end if;	
	  end process p_comp_seg; 
	  

end Behavioral;


