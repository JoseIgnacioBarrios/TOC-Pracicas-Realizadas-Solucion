----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2019 11:28:16
-- Design Name: 
-- Module Name: tragaperras - Behavioral
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


entity tragaperras is
  port(clk           : in  std_logic;   -- Input clock
       reset         : in  std_logic;   -- General reset
       inicio        : in  std_logic;   -- Start of game
       parar        	: in  std_logic;   -- 
       leds	      	: out  std_logic_vector(9 downto 0);
       display: out STD_LOGIC_VECTOR(6 downto 0);
       display_enable: out STD_LOGIC_VECTOR(3 downto 0) 
       );
end tragaperras;

architecture structural of tragaperras is
  signal control : std_logic_vector(4 downto 0);   -- Control signals
  signal status  : std_logic_vector(1 downto 0);   -- Status signals
  signal inicio_debounced, parar_debounced : std_logic;
  signal garbage : std_logic_vector(3 downto 0);
  signal num1 , num2 : std_logic_vector (3 downto 0);
  
  -- Las señales de Control bajan de la UC para dar órdenes al CD.
  -- Las señales de status suben a la UC para que tome decisiones de transición.
  
   component controller
    port (
      clk      : in  std_logic;         -- Input clock
      reset    : in  std_logic;         -- General reset
      inicio   : in  std_logic;         -- Start of algorithm
		parar    : in  std_logic;
		status   : in std_logic_vector(1 downto 0); 
		control  : out std_logic_vector(4 downto 0)
      );
  end component;

  component datapath
    port (
      clk      			: in  std_logic;    -- Input clock
      reset    			: in  std_logic;    -- General reset
		control 			   : in  std_logic_vector(4 downto 0);		
      status  				: out std_logic_vector(1 downto 0);
		leds					: out std_logic_vector(9 downto 0); 
		 num1: out std_logic_vector (3 downto 0);
		 num2 : out std_logic_vector (3 downto 0) 
      );
  end component;
  
  component debouncer is
  port (
    rst             : in  std_logic;
    clk             : in  std_logic;
    x               : in  std_logic;
    xdeb            : out std_logic;
    xdebfallingedge : out std_logic;
    xdebrisingedge  : out std_logic
    );
  end component debouncer;
  
    component displays is
  port (
    rst             : in  std_logic;
    clk             : in  std_logic;
        digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_2 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_3 : in  STD_LOGIC_VECTOR (3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
       );
  end component displays;
begin
	
	
	
  uc : controller port map (
    clk      => clk,                    -- Input clock
    reset    =>  reset,                  -- General reset
	 inicio	 =>  (inicio_debounced),
	 parar    =>  (parar_debounced),
	 status   => status,
	 control  => control
    );

  dp : datapath port map
    (clk     => clk,              -- Input clock
     reset   =>  (reset),            -- General reset
	  control => control, 
	  status  => status,
	  leds	=> leds,
	  num1 => num1,
	  num2 => num2
     );

	debounce_inicio: debouncer port map (
	 rst =>  (reset),              
    clk => clk,            
    x => inicio,              
    xdeb => inicio_debounced,            
    xdebfallingedge => garbage(0), 
    xdebrisingedge =>  garbage(1) 
	);
	
	debounce_parar: debouncer port map (
	 rst =>  (reset),              
    clk => clk,            
    x => parar,              
    xdeb => parar_debounced,            
    xdebfallingedge => garbage(2), 
    xdebrisingedge =>  garbage(3) 
	);
	
	displa: displays port map(
		 rst =>  (reset),              
         clk => clk,
         digito_0 => num1,
         digito_1 => num2,
         digito_2 => "0000",
         digito_3 => "0000",
         display => display,
         display_enable => display_enable
         );
	
end structural;

