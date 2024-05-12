library ieee;
use ieee.std_logic_1164.all;

entity sensor is
	port(	clk,rst,echo: 	in std_logic;
			start:	in std_logic;
			trig: 			out std_logic;
			--led1, led2:		out std_logic;
			disp0, disp1, disp2: 	out std_logic_vector(6 downto 0));
end entity;

architecture bhv of sensor is
	
	signal clkl1, clkl2, tr: std_logic;
	--signal distancia: integer;
	signal distancia, hex0, hex1, hex2: integer;
begin

	--Mandar señal de trigger
	u2: entity work.clkTrigger(bhv) port map(clk, clkl2);
	u3: entity work.senalTrigger(bhv) port map(clkl2, start ,rst, echo, tr);
	trig <= tr;
	
	--Medir distancia
	u1: entity work.divf(bhv) generic map(25) port map(clk, clkl1); -- 1Mhz para que cuente en micro segundos
	u4: entity work.calcDistance(bhv) port map(start, echo, clkl1 ,tr,rst, distancia);
	
	--Displays
	display0: entity work.ss7(bhv) port map(hex0, disp0);
	display1: entity work.ss7(bhv) port map(hex1, disp1);
	display2: entity work.ss7(bhv) port map(hex2, disp2);
	
	
	hex0 <= distancia mod 10;
	hex1 <= (distancia mod 100) / 10;
	hex2 <= distancia / 100;
	
end architecture;
