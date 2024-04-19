library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity t_light is
    Port (
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;
        g1, g2, y1, y2, r1, r2 : out STD_LOGIC
    );
end t_light;

architecture Behavioral of t_light is
    type state is (s0, s1, s2, s3, s4, s5);
    signal p_state, n_state : state;
    signal sec_clock : STD_LOGIC := '0';
    signal counter : integer := 0;
    signal delay_counter : integer := 0;
    signal target_delay : integer := 3; -- Initial delay target for s0

begin
    -- Clock divider to generate 1-second from a 50 MHz clock
    process (clk, rst)
    begin
        if rst = '1' then
            counter <= 0;
            sec_clock <= '0';
        elsif (clk'event and clk='1') then
            if counter < 5000000/2 - 1 then
                counter <= counter + 1;
            else
                counter <= 0;
                sec_clock <= not sec_clock; -- Toggle sec_clock each half-second
            end if;
        end if;
    end process;

  
    process (sec_clock, rst)
    begin
        if rst = '1' then
            p_state <= s0;
            delay_counter <= 0;
        elsif (sec_clock'event and sec_clock='1') then
            if delay_counter < target_delay - 1 then
                delay_counter <= delay_counter + 1;
            else
                delay_counter <= 0;
                p_state <= n_state; 
            end if;
        end if;
    end process;


    process (p_state)
    begin
        case p_state is
            when s0 =>
                g1 <= '1'; g2 <= '0';
                y1 <= '0'; y2 <= '0';
                r1 <= '0'; r2 <= '1';
                n_state <= s1;
                target_delay <= 3; 
            when s1 =>
                g1 <= '0'; g2 <= '0';
                y1 <= '1'; y2 <= '0';
                r1 <= '0'; r2 <= '1';
                n_state <= s2;
                target_delay <= 2;
            when s2 =>
                g1 <= '0'; g2 <= '0';
                y1 <= '0'; y2 <= '0';
                r1 <= '1'; r2 <= '1';
                n_state <= s3;
                target_delay <= 1;
            when s3 =>
                g1 <= '0'; g2 <= '1';
                y1 <= '0'; y2 <= '0';
                r1 <= '1'; r2 <= '0';
                n_state <= s4;
                target_delay <= 3;
            when s4 =>
                g1 <= '0'; g2 <= '0';
                y1 <= '0'; y2 <= '1';
                r1 <= '1'; r2 <= '0';
                n_state <= s5;
                target_delay <= 2;
            when s5 =>
                g1 <= '0'; g2 <= '0';
                y1 <= '0'; y2 <= '0';
                r1 <= '1'; r2 <= '1';
                n_state <= s0;
                target_delay <= 1;
        end case;
    end process;
end Behavioral;
