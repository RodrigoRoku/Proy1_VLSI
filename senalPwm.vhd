library ieee;
use ieee.std_logic_1164.all;

entity senalPwm is
	port(	clk	:in std_logic;
			duty	:in integer;
			pwm 	:out std_logic);
end entity;


architecture bhv of senalPwm is
	signal conteo	:integer range 0 to 1000;
begin
	process(clk)
		begin
				if(rising_edge(clk)) then
					if(conteo = 1000) then
						conteo <= 0;
					else
						conteo <= conteo + 1;
					end if;
					
					if (conteo <= duty) then
						pwm <= '1';
					else
						pwm <= '0';
					end if;
					
				end if;
	end process;
end architecture;