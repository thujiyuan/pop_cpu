----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:48:07 11/20/2016 
-- Design Name: 
-- Module Name:    PC - Behavioral 
-- ˵����clkʱ���źţ�һ�����䣬���ݵ�ǰ�Ƿ��Ѿ���ʼ������ǰ�Ƿ�����ͣ�׶�����PCout��ֵ
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
	Port(	clk : in STD_LOGIC;
         rwPause : in STD_LOGIC;
			passerPause: in STD_LOGIC;
			PCin: in STD_LOGIC_VECTOR(15 downto 0);
			PCout: out STD_LOGIC_VECTOR(15 downto 0));
end PC;

architecture PCBehavioral of PC is
    shared variable inited: boolean := false;
	shared variable paused: boolean := false;
    shared variable lastPC: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
begin
	process(rwPause, passerPause)
	begin
		if(rwPause = '0' and passerPause = '0') then
            paused := false;
        else 
            paused := true;
        end if;
	end process;

    process(clk, rwPause, passerPause, PCin)
    begin
        if(clk'event and clk = '1') then
            if(inited = false) then
                PCout <= "0000000000000000";
                lastPC := "0000000000000000";
		inited := true;
            elsif(inited = true and paused = false) then
                PCout <= PCin;
                lastPC := PCin;
            elsif(inited = true and paused = true) then
                PCout <= lastPC;
            end if;
        end if;
    end process;
end PCBehavioral;

