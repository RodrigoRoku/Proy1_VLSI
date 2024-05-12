library ieee;
use ieee.std_logic_1164.all;

--Manda la señal de 10microseg para el trigger

entity clkTrigger is
	port(	clk:	in std_logic;
			snl:	out std_logic);
end entity;

architecture bhv of clkTrigger is
	signal conteo: integer range 0 to 25000000;--
begin
	process(clk)
		begin
			if(rising_edge (clk)) then
				if(conteo <= 500 ) then -- Manda señal cada 10 micro segundos 500 / 25000000
					snl <= '1';
				else
					snl <= '0';
				end if;
					
				if(conteo= 25000000	) then  -- 25000000
					conteo <= 0;
				else
					conteo <=  conteo + 1;
				end if;
			end if;
		end process;
end architecture;