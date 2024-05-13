library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sensor is
	port(	clk,rst,echo: 	in std_logic;
			start:			in std_logic;
			duty: 			out integer;
			trig: 			out std_logic;
			disp0, disp1, disp2: 	out std_logic_vector(6 downto 0);
			disp3, disp4, disp5: 	out std_logic_vector(6 downto 0)
			);
end entity;

architecture bhv of sensor is
	
	--FSM
	type 	 maquinaEstados is (s0,s1,s2,s3,s4,s5);
	signal nextState: maquinaEstados;
	signal clkState: std_logic;
	
	--señales enable para los modulos
	
	signal en_distance, en_trigger, en_duty: std_logic;
	
	--Distancias
	signal distancia ,distanciaMax, distanciaActual: integer; 
	
	--Relojes
	signal clkl1, clkl2, tr: std_logic;
	
	--Displays
	signal hex0, hex1, hex2, hex3, hex4, hex5: integer;
	
	--Ciclo de trabajo
	signal dty, dtyCalc  : integer; -- dtyCalc es la que sale del modulo, dty es la que guarda el valor de duty entre estados
	signal done: std_logic;
	
	
begin
	--Reloj para la maquina de estados
	
	clkS: entity work.divf(bhv) generic map(5) port map(clk, clkState);
	
	--Mandar señal de trigger
	u2: entity work.clkTrigger(bhv) port map(clk, clkl2);
	u3: entity work.senalTrigger(bhv) port map(clkl2, en_trigger ,rst, echo, tr);
	trig <= tr;
	
	--Medir distancia
	u1: entity work.divf(bhv) generic map(25) port map(clk, clkl1); -- 1Mhz para que cuente en micro segundos
	u4: entity work.calcDistance(bhv) port map(en_distance, echo, clkl1 ,tr,rst, distancia);
	
	--Displays
	display0: entity work.ss7(bhv) port map(hex0, disp0);
	display1: entity work.ss7(bhv) port map(hex1, disp1);
	display2: entity work.ss7(bhv) port map(hex2, disp2);
	
	display3: entity work.ss7(bhv) port map(hex3, disp3);
	display4: entity work.ss7(bhv) port map(hex4, disp4);
	display5: entity work.ss7(bhv) port map(hex5, disp5);
	
	vel: entity work.calcDuty(bhv) port map( clkState ,en_duty, rst, distanciaMax, distanciaActual, done, dtyCalc);
		
	hex0 <= distanciaMax mod 10;
	hex1 <= (distanciaMax mod 100) / 10;
	hex2 <= distanciaMax / 100;
	
	hex3 <= distanciaActual mod 10;
	hex4 <= (distanciaActual mod 100) / 10;
	hex5 <= distanciaActual / 100;
	
	
	
	--Ciclo de trabajo
	duty <= dty;
	
	process(clkState)
	begin
	
		if(rst = '1') then
		
			nextState <= s0;
			en_distance <= '0';
			en_trigger <= '0';
			distanciaMax <= 0;
			distanciaActual <= 0;
			en_duty <= '0';
			dty <= 0;
			
		else
		
			if(rising_edge(clkState)) then
			
				case nextState is
			
				when s0 =>
					en_distance <= '0';
					en_trigger <= '0';
					distanciaMax <= 0;
					distanciaActual <= 0;
					en_duty <= '0';
					dty <= 0;
					if(start = '1') then
						nextState <= s1;
					end if;
				
				--Comienza medicion de distancia Maxima, solo se pasa por estos estados 1 vez!
				when s1 => 
					en_trigger 	<= '1';
					en_distance <= '0';
					distanciaMax <= 0;
					distanciaActual <= 0;
					en_duty <= '0';
					dty <= 0;
					if(echo = '1') then
						nextState <= s2;
					end if;
				
				when s2 =>
					en_trigger 	<= '1';
					en_distance <= '1';
					distanciaActual <= 0;
					en_duty <= '0';
					dty <= 0;
					if(echo = '0') then
						distanciaMax <= distancia;
						nextState <= s3;
					else 
						distanciaMax <= 0;
					end if;
					
				--Comienza ciclo de medicion de distancia actual
				when s3 =>
					en_trigger 	<= '1';
					en_distance <= '0';
					distanciaMax <= distanciaMax;
					en_duty <= '0';
					dty <= dty;
					distanciaActual <= distanciaActual;
					if(echo = '1') then
						nextState <= s4;
					end if;
					
				when s4 =>
					en_trigger 	<= '1';
					en_distance <= '1';
					distanciaMax <= distanciaMax;
					en_duty <= '0';
					dty <= dty;
					
					if(echo = '0') then
						distanciaActual <= distancia;
						nextState <= s5;
					else 
						distanciaActual <= distanciaActual;
					end if;
					
				--Medicion del ciclo de trabajo (velocidad) para el motor
				
				when s5 =>
					en_trigger 	<= '1';
					en_distance <= '0';
					distanciaMax <= distanciaMax;
					distanciaActual <= distanciaActual;
					en_duty <= '1';
					--dty <= dtyCalc;
					--nextState <= s3;
					
					if(done = '1') then
						dty <= dtyCalc;
						nextState <= s3;
					else
						dty <= dty;
					end if;
					
					
				end case;
				
			end if;
			
		end if;
	end process;
	
	
	
end architecture;
