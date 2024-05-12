library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pwm is
	port(	clk	:in std_logic;
			motor	:out std_logic);
end entity;


architecture bhv of pwm is

	signal clkl: std_logic;
	
begin	

	cl1: entity work.divf(bhv) generic map(2500) port map(clk, clkl);
	motor1: entity work.senal(bhv) port map(clkl, 400, motor);

	
end architecture;