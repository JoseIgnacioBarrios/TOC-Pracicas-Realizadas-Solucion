
library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;


entity Bin8toBCD3 is
    port ( binario  : in  std_logic_vector (7 downto 0) ;
           bcd3 : out std_logic_vector (11 downto 0) 
           ) ;
end Bin8toBCD3 ;

architecture arc_Bin8toBCD3 of Bin8toBCD3 is

begin
  

process ( binario )
    variable hex_src : std_logic_vector (7 downto 0) ;
    variable bcd     : std_logic_vector (11 downto 0) ;
begin
    hex_src := binario ;
    bcd     := (others => '0') ;

    for i in 0 to 7 loop
        if bcd(3 downto 0) > "0100" then
            bcd(3 downto 0) := bcd(3 downto 0) + "0011" ;
        end if ;
        if bcd(7 downto 4) > "0100" then
            bcd(7 downto 4) := bcd(7 downto 4) + "0011" ;
        end if ;
        if bcd(11 downto 8) > "0100" then
            bcd(11 downto 8) := bcd(11 downto 8) + "0011" ;
        end if ;

        bcd := bcd(10 downto 0) & hex_src(7) ; -- shift bcd + 1 new entry
        hex_src := hex_src(6 downto 0) & '0' ; -- shift src + pad with 0
    end loop ;

    bcd3 <= bcd;

end process ;
	 
end arc_Bin8toBCD3 ;