library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity keyless_entry is
    Port(
        clk: in std_logic;
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
        led_locked: out std_logic;      --indicates the system is locked
        led_unlocked: out std_logic;    --indicates the system is unlocked
        led_status: out std_logic_vector(2 downto 0);
        lock_code_storage_1: inout std_logic_vector(1 downto 0);
        lock_code_storage_2: inout std_logic_vector(1 downto 0);
        lock_code_storage_3: inout std_logic_vector(1 downto 0);
        lock_code_storage_4: inout std_logic_vector(1 downto 0);
        unlock_code_storage_1: out std_logic_vector(1 downto 0);
        unlock_code_storage_2: out std_logic_vector(1 downto 0);
        unlock_code_storage_3: out std_logic_vector(1 downto 0);
        unlock_code_storage_4: out std_logic_vector(1 downto 0);
        state_out: out Integer range 0 to 7
--        start_output: out std_logic --meant for debugging
    );
end keyless_entry;

architecture Behavioral of keyless_entry is
    signal state: Integer range 0 to 7;
    signal next_state: Integer range 0 to 7;
    signal start: std_logic;
    signal count: Integer := 0; --counter for slwclk
    signal slowclock: std_logic;
    
    --signals for acting as memory
        signal storage_lock_1: std_logic_vector(1 downto 0);
        signal storage_lock_2: std_logic_vector(1 downto 0);
        signal storage_lock_3: std_logic_vector(1 downto 0);
        signal storage_lock_4: std_logic_vector(1 downto 0);
        signal storage_unlock_1: std_logic_vector(1 downto 0);
        signal storage_unlock_2: std_logic_vector(1 downto 0);
        signal storage_unlock_3: std_logic_vector(1 downto 0);
        signal storage_unlock_4: std_logic_vector(1 downto 0);
        
    --signals to not have to put the stuff commented out above in the constraint file
--       signal lock_code_storage_1:  std_logic_vector(1 downto 0);
--       signal lock_code_storage_2:  std_logic_vector(1 downto 0);
--       signal lock_code_storage_3:  std_logic_vector(1 downto 0);
--       signal lock_code_storage_4:  std_logic_vector(1 downto 0);
--       signal unlock_code_storage_1:  std_logic_vector(1 downto 0);
--       signal unlock_code_storage_2:  std_logic_vector(1 downto 0);
--       signal unlock_code_storage_3:  std_logic_vector(1 downto 0);
--       signal unlock_code_storage_4:  std_logic_vector(1 downto 0);
       
begin


 
     -- change 50000000 to 1 when simulating
    --process that will act as buff so there's delay between inputs(minimize bounce)
     debounce: Process(clk)
        begin
                if((rising_edge(clk)) and (start = '1')) then
                     if(count = 50000000) then -- 0.5 sec delay based off 100MHZ clk before next input can be taken
                            slowclock <= '1';
                            count <= 0; --reset counter
                     else
                            count <= count + 1;
                     end if;
                end if;
                if(slowclock = '1') then
                    slowclock <= '0';
                end if;
     end Process debounce;   
     
     --Process that will tranist the state to the nextstate
     transit: Process(slowclock)
        begin
           if(rising_edge(slowclock)) then
            state <= next_state;
           end if;
     end Process ;
     
     --dont want this to trigger off clock because then it will reset "start" back to 0 too fast
     starter: Process(lock_button, unlock_button, reset, state, clk)
        begin
            if(lock_button = '1' or unlock_button = '1' or reset = '1' or state = 1 or state = 2) then
                start <= '1';
             
            elsif(state = next_state) then
                start <= '0';    
            end if;
     end Process starter;
     
    --process that holds conditions for entering states
    Process(lock_button, unlock_button, reset, clk)
      begin
        if(state = next_state) then -- to act as a debounce (already in the next state)
            --condition for entering state 0 (reset state = unlocked state) - green 
            if(reset = '1') then  
                next_state <= 0;
            end if;
                
            --condition for entering state 1 (locked state) - no led
            if(lock_button = '1' and (state = 0 or state = 7 or state = 5)) then
                next_state <= 1;
            end if;
            
            --condition for entering state 2 (unlocked state) -- no led
            if(unlock_button = '1' and (state = 6 or state = 3 or state = 4)  and   --making sure codes match
                  unlock_code_1 = lock_code_storage_1 and
                  unlock_code_2 = lock_code_storage_2 and
                  unlock_code_3 = lock_code_storage_3 and
                  unlock_code_4 = lock_code_storage_4) then
                    next_state <= 2;
            end if;
                  
            --condition for entering state 3 (failed unlock - remain locked) - red
            if((unlock_button = '1' and (state = 6 or state = 4)) and   --checking if codes dont match
                  (unlock_code_1 /= lock_code_storage_1 or
                  unlock_code_2 /= lock_code_storage_2 or
                  unlock_code_3 /= lock_code_storage_3 or
                  unlock_code_4 /= lock_code_storage_4)) then
                    next_state <= 3;
           end if;
            
            --condition for entering state 4 (invalid lock - remain locked) - blue
            if(lock_button = '1' and (state = 6 or state = 3)) then
                    next_state <= 4;
            end if;
            
            --condition for entering state 5 (invalid unlock - remain unlocked) - yellow
            if(unlock_button = '1' and (state = 7 or state = 0))  then
                    next_state <= 5;
            end if;
            
            if(state = 1) then
                next_state <= 6;
            end if;
            
            if(state = 2) then
                next_state <= 7;       
            end if;
        end if;
    end Process;
    
    
    
    --process holding each state's actions
    Process(state)
      begin
            case state is
                 when 0 => -- reset state
                      led_unlocked <= '1'; --indicate system is unlocked
                      led_locked <= '0'; 
                      led_status <= "010"; --outputs green
                      state_out <= 0;
                      
                 when 1 =>  --successful locked state
                    --led status
                      led_unlocked <= '0'; --indicate system is locked
                      led_locked <= '1';
                      led_status <= "000"; --outputs black/nothing
                      state_out <= 1;
                 
                 when 2 =>  --successful unlocked state
                      led_unlocked <= '1'; --indicate system is unlocked
                      led_locked <= '0'; 
                      led_status <= "000"; --outputs black/nothing
                      state_out <= 2;
                      
                 when 3 =>  --failed unlock operation
                      led_unlocked <= '0'; --indicate system is locked
                      led_locked <= '1';
                      led_status <= "100"; --outputs red
                      state_out <= 3;
                 
                 when 4 => --invalid lock operation
                      led_unlocked <= '0'; --indicate system is locked
                      led_locked <= '1';
                      led_status <= "001"; --outputs blue
                      state_out <= 4;
                 
                 when 5 =>  --invalid unlock operation
                      led_unlocked <= '1'; --indicate system is unlocked
                      led_locked <= '0'; 
                      led_status <= "110"; --outputs yellow
                      state_out <= 5;
                 
                 when 6 => --idle state for state 1
                      led_status <= "000"; --outputs black/nothing
                      state_out <= 6;
                      
                 when 7 => --idle state for state 2
                      led_status <= "000"; --outputs black/nothing
                      state_out <= 7;
                           
            end case;             
    end Process;
    
    --storing the lock codes
      storage_lock_1 <= "00" when state = 0 else
                        lock_code_1 when state = 1;
                        
      storage_lock_2 <= "00" when state = 0 else
                        lock_code_2 when state = 1;
                        
      storage_lock_3 <= "00" when state = 0 else
                            lock_code_3 when state = 1;
                            
      storage_lock_4 <= "00" when state = 0 else
                        lock_code_4 when state = 1;
      
      storage_unlock_1 <= "00" when state = 0 else
                        unlock_code_1 when state = 2;
                        
      storage_unlock_2 <= "00" when state = 0 else
                        unlock_code_2 when state = 2;
      
      storage_unlock_3 <= "00" when state = 0 else
                       unlock_code_3 when state = 2;
        
      storage_unlock_4 <= "00" when state = 0 else
                        unlock_code_4 when state = 2;
                        
                      
    --outputting the stored lock codes
    lock_code_storage_1 <= storage_lock_1;
    lock_code_storage_2 <= storage_lock_2;
    lock_code_storage_3 <= storage_lock_3;
    lock_code_storage_4 <= storage_lock_4;
    unlock_code_storage_1 <= storage_unlock_1;
    unlock_code_storage_2 <= storage_unlock_2;
    unlock_code_storage_3 <= storage_unlock_3;
    unlock_code_storage_4 <= storage_unlock_4;
    
    --remvoe when done testing (meant for debugging)
    --start_output <= start;
    
end Behavioral;