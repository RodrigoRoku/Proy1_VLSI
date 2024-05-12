library ieee;
use ieee.std_logic_1164.all;

entity senalTrigger is
	port(	clk,en ,rst, echo:	in std_logic;
			salida:			out std_logic);
end entity;

architecture bhv of senalTrigger is

begin
	process(clk)
		begin
		if(en = '1') then
			if( rst='1') then 
				salida <= '0';
			end if;
			
			if(echo = '1') then 
				salida <= '0';
			else
				salida <= clk; 
			end if; 
		else
			salida <= '0';
		end if;
			
		end process;
end architecture;