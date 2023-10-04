library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity simstructure_TB is
end simstructure_TB;

architecture Behavioral of simstructure_TB is
    Component sim_structure
        Port(
            lock_code_1: in std_logic_vector(1 downto 0);
            lock_code_2: in std_logic_vector(1 downto 0);
            lock_code_3: in std_logic_vector(1 downto 0);
            lock_code_4: in std_logic_vector(1 downto 0);
            unlock_code_1: in std_logic_vector(1 downto 0);
            unlock_code_2: in std_logic_vector(1 downto 0);
            unlock_code_3: in std_logic_vector(1 downto 0);
            unlock_code_4: in std_logic_vector(1 downto 0);
            unlock_button: in std_logic;
            lock_button: in std_logic;
            reset: in std_logic;
            clk: in std_logic;
            AN: out std_logic_vector(7 downto 0);
            led_locked: out std_logic;      --indicates the system is locked
            led_unlocked: out std_logic;    --indicates the system is unlocked
            led_status: out std_logic_vector(2 downto 0);
            LED7: out std_logic_vector(7 downto 0); --output the turns the leds on
            state_light: out Integer range 0 to 7
        );
   end Component;
   
   --signals for simulation
     signal lock_code_1: std_logic_vector(1 downto 0);
     signal lock_code_2: std_logic_vector(1 downto 0);
     signal lock_code_3: std_logic_vector(1 downto 0);
     signal lock_code_4: std_logic_vector(1 downto 0);
     signal unlock_code_1: std_logic_vector(1 downto 0);
     signal unlock_code_2: std_logic_vector(1 downto 0);
     signal unlock_code_3: std_logic_vector(1 downto 0);
     signal unlock_code_4: std_logic_vector(1 downto 0);
     signal unlock_button: std_logic;
     signal lock_button: std_logic;
     signal reset: std_logic;
     signal clk: std_logic;
     signal AN: std_logic_vector(7 downto 0);
     signal led_locked: std_logic;      --indicates the system is locked
     signal led_unlocked: std_logic;    --indicates the system is unlocked
     signal led_status: std_logic_vector(2 downto 0);
     signal LED7: std_logic_vector(7 downto 0); --output the turns the leds on
     signal state_light: Integer range 0 to 7;
   
begin
    DUT: sim_structure Port Map
      ( 
        lock_code_1 => lock_code_1,
        lock_code_2 => lock_code_2,
        lock_code_3 => lock_code_3,
        lock_code_4 => lock_code_4,
        unlock_code_1 => unlock_code_1,
        unlock_code_2 => unlock_code_2,
        unlock_code_3 => unlock_code_3,
        unlock_code_4 => unlock_code_4,
        unlock_button => unlock_button,
        lock_button => lock_button,
        reset => reset,
        clk => clk,
        AN => AN,
        led_locked => led_locked,
        led_unlocked => led_unlocked,
        led_status => led_status,
        LED7 => LED7,
        state_light => state_light
      );
      
      --creating testbench clock with process
    cycle: Process
        begin
             clk <= '0';
             wait for 5ns;
             clk <= '1';
             wait for 5ns;
    end Process;
    
    Stimulus: Process
        begin
            --testing lock case (state 1)
            lock_code_1 <= "11";
            lock_code_2 <= "10";    
            lock_code_3 <= "01";    
            lock_code_4 <= "00";
            wait for 100 ns;
            lock_button <= '1';
            wait for 50 ns;
            lock_button <= '0';
            wait for 100 ns;
            
            --testing invalid lock case (state 4)
            lock_button <= '1';
            wait for 50 ns;
            lock_button <= '0';
            wait for 100 ns;
            --results good
            
             --testing unlock (state 2 and 3)
            unlock_code_1 <= "11";
            unlock_code_2 <= "10";    
            unlock_code_3 <= "01";    
            unlock_code_4 <= "01";
            wait for 100ns;
            unlock_button <= '1';
            wait for 40ns;
            unlock_button <= '0';
            wait for 100ns;
            --results: passed "successful and failed" unlock status
            
            
            
            --general reset at the end (state 0)
            reset <= '1';
            wait for 50 ns;
            reset <= '0';
            wait for 50 ns;
            --results: good
            
            --testing invalid unlock(state 5)
            unlock_code_1 <= "10";
            unlock_code_2 <= "10";    
            unlock_code_3 <= "10";    
            unlock_code_4 <= "10";
            wait for 100ns;
            unlock_button <= '1';
            wait for 100ns;
            unlock_button <= '0';
            wait for 100ns;
            --results good
        
        --ending the process
        assert false report "Test: OK" severity failure;
    end Process;
end Behavioral;
