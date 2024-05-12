library ieee;
use ieee.std_logic_1164.all;

entity calcDistance is
	port(	en, echo,clkl1,tr,rst:		in std_logic;
			distancia:						out integer	);
end entity;

architecture bhv of calcDistance is 
	signal conteo: integer range 0 to 38000; 
begin
	process(clkl1, rst)
		begin
		if (en ='1') then
			if(rst = '1') then
				conteo <= 0;
			
			else
				if(rising_edge(clkl1)) then
				
					if(echo='1') then 
						conteo <= conteo +1;

					else
						conteo<= 0;
					end if;
					
											
				end if;

			end if;
		else
			conteo <= 0;
		end if;
			
		end process;
		
		process(echo)
		begin
		if (en = '1') then
			if(rst = '1') then
				distancia <= 0;
			else
				if(echo = '0') then
					distancia <= (conteo * 34)/2000;
				end if;
			end if;
		else 
			distancia <= 999;
		end if;
			
		end process;
end architecture;