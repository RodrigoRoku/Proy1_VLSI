library ieee;
use ieee.std_logic_1164.all;

entity controladorMotor is
	port(	clk, rst, echo, start:		in std_logic;		
			trig, en_motor:				out std_logic;
			snlMotor:		out std_logic_vector(1 downto 0);
			disp0, disp1, disp2: 		out std_logic_vector(6 downto 0);
			disp3, disp4, disp5: 		out std_logic_vector(6 downto 0));
end entity;

architecture bhv of controladorMotor is
	signal clkl: std_logic; --Para el reloj del pwm
	signal duty: integer;
begin
	cl1: entity work.divf(bhv) generic map(250) port map(clk, clkl);
	--cl1: entity work.divf(bhv) generic map(25000) port map(clk, clkl);
	
	sensor1: entity work.sensor(bhv) port map(clk, rst, echo, start, duty, trig, disp0, disp1, disp2, disp3, disp4, disp5);
	
	pwm1: entity work.senalPwm(bhv) port map(clkl, duty, snlMotor(1));
		
	snlMotor(0) <= '0';
	
	en_motor <= '1';
	
end architecture;