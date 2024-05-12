library ieee;
use ieee.std_logic_1164.all;

entity calcDuty is
	port(	clk, en, rst: 							in std_logic; 
			distMax, disAct : 	in integer;
			done: 					out std_logic;
			duty:									out integer);
end entity;

architecture bhv of calcDuty is

	signal velocidad, distMaxHalf, pendiente: integer;

	
begin

	duty <= velocidad;
	distMaxHalf <= distMax/2;
	pendiente <= 1000 / (distMax - distMaxHalf);

process(clk)
begin
	if (rst = '1') then
		--distMaxHalf <= 0;
		--pendiente <= 0;
		velocidad <= 0;
		done <= '0';
	else
	
	if(rising_edge(clk)) then
			
		if (en = '1') then
		
			if (disAct > distMax) then
			
				velocidad <= 0;
				done <= '1';
				
			else
					
				if (disAct >= distMaxHalf) then
					velocidad <= (pendiente * (distMax - disAct));
				else
					velocidad <= ((pendiente * (distMaxHalf + disAct)) - 1000);
				end if;
				done <= '1';
			end if;
			
		else
			--distMaxHalf <= 0;
			velocidad <= 0;
			--pendiente <= 0;
			done <= '0';
		end if;
	end if;
	end if;
	
end process;
end architecture;

