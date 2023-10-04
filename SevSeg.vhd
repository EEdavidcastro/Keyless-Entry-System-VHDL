library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevSeg is
   Port(
        lock_code_storage_1: in std_logic_vector(1 downto 0);
        lock_code_storage_2: in std_logic_vector(1 downto 0);
        lock_code_storage_3: in std_logic_vector(1 downto 0);
        lock_code_storage_4: in std_logic_vector(1 downto 0);
        unlock_code_storage_1: in std_logic_vector(1 downto 0);
        unlock_code_storage_2: in std_logic_vector(1 downto 0);
        unlock_code_storage_3: in std_logic_vector(1 downto 0);
        unlock_code_storage_4: in std_logic_vector(1 downto 0);
        LED7: out std_logic_vector(7 downto 0); --output for the LEDS
        AN: out std_logic_vector(7 downto 0);   --decides what sevenseg is on
        clk: in std_logic;
        state_input: in Integer range 0 to 7
    );
end SevSeg;

architecture Behavioral of SevSeg is
    --signals for tranlsating Binary to number on SevSeg
    signal Bin: std_logic_vector(3 downto 0);
    
    --creating a type for the states 
    type eg_state_type is (s0, s1, s2, s3, s4, s5, s6, s7);     
    
    --signals for states
    signal state_reg, state_next: eg_state_type;    --for FSM states
    
begin

--internal clock is at 100MHZ
--wanna refresh at 60 Hz which is 0.016 sec
-- there are 8 sevseg therefore we want each on for 0.002 sec
-- 0.002 sec = 500 HZ
-- 100MHZ/550 HZ = 200,000
-- therefore have to count up to 200,000
--for simulation change counter to 1
    timer: Process(clk)
        variable counter: integer := 0;          -- setting counter to implement a cycle
        begin
            if(rising_edge(clk)) then
                if(counter = 200000) then
                    state_reg <= state_next;
                    counter := 0;
                else
                    counter := counter + 1;
                end if;
            end if;
    end Process timer;
   

   --on simulation the AN will appear wrong because we have the LED refreshing right to left here and not basesd off numbers     
   --Process for switching the 7SEG Light (AN)
   LED: Process(state_reg)
       begin
          if(state_input = 1) then       
            case state_reg is
                   when  s0 =>
                       Bin <= "00" & lock_code_storage_4;
                       AN <= "11111110";    --enabling first LED
                       state_next <= s1; --incrementing to next state
                
                       
                   when  s1 =>
                       Bin <= "00" & lock_code_storage_3;
                       AN <= "11111101";    --enabling second LED
                       state_next <= s2; --incrementing to next state
              
                       
                   when  s2 =>
                       Bin <= "00" & lock_code_storage_2;
                       AN <= "11111011";    --enabling third LEDS
                       state_next <= s3; --incrementing to next state
                 
                       
                   when  s3 =>
                       Bin <= "00" & lock_code_storage_1; 
                       AN <= "11110111";    --enabling fourth LED
                       state_next <= s4; --incrementing to next state
                  
                       
                   when  s4 =>
                       Bin <= "1100";       -- display C
                       AN <= "11101111";    --enabling fifth LED
                       state_next <= s5; --incrementing to next state
            
                       
                   when  s5 =>
                       Bin <= "1100";       -- display C
                       AN <= "11011111";    --enabling sixth LED
                       state_next <= s6; --incrementing to next state  
     
                       
                   when  s6 =>
                       Bin <= "1100";       -- display C
                       AN <= "10111111";    --enabling seventh LED
                       state_next <= s7; --incrementing to next state
                       
                   when  s7 =>
                       Bin <= "1100";       -- display C
                       AN <= "01111111";    --enabling 8th LED         
                       state_next <= s0; --incrementing to next state   
              end case;
       
          elsif(state_input = 6) then       
            case state_reg is
                   when  s0 =>
                       Bin <= "00" & lock_code_storage_4;
                       AN <= "11111110";    --enabling first LED
                       state_next <= s1; --incrementing to next state
                
                       
                   when  s1 =>
                       Bin <= "00" & lock_code_storage_3;
                       AN <= "11111101";    --enabling second LED
                       state_next <= s2; --incrementing to next state
              
                       
                   when  s2 =>
                       Bin <= "00" & lock_code_storage_2;
                       AN <= "11111011";    --enabling third LEDS
                       state_next <= s3; --incrementing to next state
                 
                       
                   when  s3 =>
                       Bin <= "00" & lock_code_storage_1; 
                       AN <= "11110111";    --enabling fourth LED
                       state_next <= s4; --incrementing to next state
                  
                       
                   when  s4 =>
                       Bin <= "1100";       -- display C
                       AN <= "11101111";    --enabling fifth LED
                       state_next <= s5; --incrementing to next state
            
                       
                   when  s5 =>
                       Bin <= "1100";       -- display C
                       AN <= "11011111";    --enabling sixth LED
                       state_next <= s6; --incrementing to next state  
     
                       
                   when  s6 =>
                       Bin <= "1100";       -- display C
                       AN <= "10111111";    --enabling seventh LED
                       state_next <= s7; --incrementing to next state
                       
                   when  s7 =>
                       Bin <= "1100";       -- display C
                       AN <= "01111111";    --enabling 8th LED         
                       state_next <= s0; --incrementing to next state   
              end case;
       
          elsif(state_input = 2) then
            case state_reg is
                   when  s0 =>
                       Bin <= "1010";       -- display A
                       AN <= "11111110";    --enabling first LED
                       state_next <= s1; --incrementing to next state
                
                       
                   when  s1 =>
                       Bin <= "1010";       -- display A
                       AN <= "11111101";    --enabling second LED
                       state_next <= s2; --incrementing to next state
              
                       
                   when  s2 =>
                       Bin <= "1010";       -- display A
                       AN <= "11111011";    --enabling third LEDS
                       state_next <= s3; --incrementing to next state
                 
                       
                   when  s3 =>
                       Bin <= "1010";       -- display A
                       AN <= "11110111";    --enabling fourth LED
                       state_next <= s4; --incrementing to next state
                  
                       
                   when  s4 =>
                       Bin <= "00" & unlock_code_storage_4;
                       AN <= "11101111";    --enabling fifth LED
                       state_next <= s5; --incrementing to next state
            
                       
                   when  s5 =>
                       Bin <= "00" & unlock_code_storage_3;
                       AN <= "11011111";    --enabling sixth LED
                       state_next <= s6; --incrementing to next state  
     
                       
                   when  s6 =>
                       Bin <= "00" & unlock_code_storage_2;
                       AN <= "10111111";    --enabling seventh LED
                       state_next <= s7; --incrementing to next state
                       
                   when  s7 =>
                       Bin <= "00" & unlock_code_storage_1;
                       AN <= "01111111";    --enabling 8th LED         
                       state_next <= s0; --incrementing to next state   
              end case;
          
          elsif(state_input = 7) then
            case state_reg is
                   when  s0 =>
                       Bin <= "1010";       -- display A
                       AN <= "11111110";    --enabling first LED
                       state_next <= s1; --incrementing to next state
                
                       
                   when  s1 =>
                       Bin <= "1010";       -- display A
                       AN <= "11111101";    --enabling second LED
                       state_next <= s2; --incrementing to next state
              
                       
                   when  s2 =>
                       Bin <= "1010";       -- display A
                       AN <= "11111011";    --enabling third LEDS
                       state_next <= s3; --incrementing to next state
                 
                       
                   when  s3 =>
                       Bin <= "1010";       -- display A
                       AN <= "11110111";    --enabling fourth LED
                       state_next <= s4; --incrementing to next state
                  
                       
                   when  s4 =>
                       Bin <= "00" & unlock_code_storage_4;
                       AN <= "11101111";    --enabling fifth LED
                       state_next <= s5; --incrementing to next state
            
                       
                   when  s5 =>
                       Bin <= "00" & unlock_code_storage_3;
                       AN <= "11011111";    --enabling sixth LED
                       state_next <= s6; --incrementing to next state  
     
                       
                   when  s6 =>
                       Bin <= "00" & unlock_code_storage_2;
                       AN <= "10111111";    --enabling seventh LED
                       state_next <= s7; --incrementing to next state
                       
                   when  s7 =>
                       Bin <= "00" & unlock_code_storage_1;
                       AN <= "01111111";    --enabling 8th LED         
                       state_next <= s0; --incrementing to next state   
              end case;
          
          elsif(state_input = 3) then       
            case state_reg is
                   when  s0 =>
                       Bin <= "00" & lock_code_storage_4;
                       AN <= "11111110";    --enabling first LED
                       state_next <= s1; --incrementing to next state
                
                       
                   when  s1 =>
                       Bin <= "00" & lock_code_storage_3;
                       AN <= "11111101";    --enabling second LED
                       state_next <= s2; --incrementing to next state
              
                       
                   when  s2 =>
                       Bin <= "00" & lock_code_storage_2;
                       AN <= "11111011";    --enabling third LEDS
                       state_next <= s3; --incrementing to next state
                 
                       
                   when  s3 =>
                       Bin <= "00" & lock_code_storage_1; 
                       AN <= "11110111";    --enabling fourth LED
                       state_next <= s4; --incrementing to next state
                  
                       
                   when  s4 =>
                       Bin <= "1100";       -- display C
                       AN <= "11101111";    --enabling fifth LED
                       state_next <= s5; --incrementing to next state
            
                       
                   when  s5 =>
                       Bin <= "1100";       -- display C
                       AN <= "11011111";    --enabling sixth LED
                       state_next <= s6; --incrementing to next state  
     
                       
                   when  s6 =>
                       Bin <= "1100";       -- display C
                       AN <= "10111111";    --enabling seventh LED
                       state_next <= s7; --incrementing to next state
                       
                   when  s7 =>
                       Bin <= "1100";       -- display C
                       AN <= "01111111";    --enabling 8th LED         
                       state_next <= s0; --incrementing to next state   
              end case;
              
        elsif(state_input = 4) then       
            case state_reg is
                   when  s0 =>
                       Bin <= "00" & lock_code_storage_4;
                       AN <= "11111110";    --enabling first LED
                       state_next <= s1; --incrementing to next state
                
                       
                   when  s1 =>
                       Bin <= "00" & lock_code_storage_3;
                       AN <= "11111101";    --enabling second LED
                       state_next <= s2; --incrementing to next state
              
                       
                   when  s2 =>
                       Bin <= "00" & lock_code_storage_2;
                       AN <= "11111011";    --enabling third LEDS
                       state_next <= s3; --incrementing to next state
                 
                       
                   when  s3 =>
                       Bin <= "00" & lock_code_storage_1; 
                       AN <= "11110111";    --enabling fourth LED
                       state_next <= s4; --incrementing to next state
                  
                       
                   when  s4 =>
                       Bin <= "1100";       -- display C
                       AN <= "11101111";    --enabling fifth LED
                       state_next <= s5; --incrementing to next state
            
                       
                   when  s5 =>
                       Bin <= "1100";       -- display C
                       AN <= "11011111";    --enabling sixth LED
                       state_next <= s6; --incrementing to next state  
     
                       
                   when  s6 =>
                       Bin <= "1100";       -- display C
                       AN <= "10111111";    --enabling seventh LED
                       state_next <= s7; --incrementing to next state
                       
                   when  s7 =>
                       Bin <= "1100";       -- display C
                       AN <= "01111111";    --enabling 8th LED         
                       state_next <= s0; --incrementing to next state   
              end case;
              
         elsif(state_input = 5) then
            case state_reg is
                   when  s0 =>
                       Bin <= "1010";       -- display A
                       AN <= "11111110";    --enabling first LED
                       state_next <= s1; --incrementing to next state
                
                       
                   when  s1 =>
                       Bin <= "1010";       -- display A
                       AN <= "11111101";    --enabling second LED
                       state_next <= s2; --incrementing to next state
              
                       
                   when  s2 =>
                       Bin <= "1010";       -- display A
                       AN <= "11111011";    --enabling third LEDS
                       state_next <= s3; --incrementing to next state
                 
                       
                   when  s3 =>
                       Bin <= "1010";       -- display A
                       AN <= "11110111";    --enabling fourth LED
                       state_next <= s4; --incrementing to next state
                  
                       
                   when  s4 =>
                       Bin <= "00" & unlock_code_storage_4;
                       AN <= "11101111";    --enabling fifth LED
                       state_next <= s5; --incrementing to next state
            
                       
                   when  s5 =>
                       Bin <= "00" & unlock_code_storage_3;
                       AN <= "11011111";    --enabling sixth LED
                       state_next <= s6; --incrementing to next state  
     
                       
                   when  s6 =>
                       Bin <= "00" & unlock_code_storage_2;
                       AN <= "10111111";    --enabling seventh LED
                       state_next <= s7; --incrementing to next state
                       
                   when  s7 =>
                       Bin <= "00" & unlock_code_storage_1;
                       AN <= "01111111";    --enabling 8th LED         
                       state_next <= s0; --incrementing to next state   
              end case;
              
         else      
              case state_reg is
                   when  s0 =>
                       Bin <= "00" & lock_code_storage_4;
                       AN <= "11111110";    --enabling first LED
                       state_next <= s1; --incrementing to next state
                
                       
                   when  s1 =>
                       Bin <= "00" & lock_code_storage_3;
                       AN <= "11111101";    --enabling second LED
                       state_next <= s2; --incrementing to next state
              
                       
                   when  s2 =>
                       Bin <= "00" & lock_code_storage_2;
                       AN <= "11111011";    --enabling third LEDS
                       state_next <= s3; --incrementing to next state
                 
                       
                   when  s3 =>
                       Bin <= "00" & lock_code_storage_1; 
                       AN <= "11110111";    --enabling fourth LED
                       state_next <= s4; --incrementing to next state
                  
                       
                   when  s4 =>
                       Bin <= "00" & unlock_code_storage_4;
                       AN <= "11101111";    --enabling fifth LED
                       state_next <= s5; --incrementing to next state
            
                       
                   when  s5 =>
                       Bin <= "00" & unlock_code_storage_3;
                       AN <= "11011111";    --enabling sixth LED
                       state_next <= s6; --incrementing to next state  
     
                       
                   when  s6 =>
                       Bin <= "00" & unlock_code_storage_2;
                       AN <= "10111111";    --enabling seventh LED
                       state_next <= s7; --incrementing to next state
                       
                   when  s7 =>
                       Bin <= "00" & unlock_code_storage_1;
                       AN <= "01111111";    --enabling 8th LED         
                       state_next <= s0; --incrementing to next state   
              end case;
         end if;     
   end Process LED;             
   
    --output that results from each input
    --LED7 = | CA | CB | CC | CD | CE | CF | CG | DP 
          LED7 <= "00000011" when Bin <= "0000" else   -- display 0 (03- hex)
                  "10011111" when Bin <= "0001" else   -- display 1 (9F- hex)
                  "00100101" when Bin <= "0010" else   -- display 2 (25- hex)
                  "00001101" when Bin <= "0011" else   -- display 3 (0D- hex)
                  "00010001" when Bin <= "1010" else   -- display A
                  "01100011" when Bin <= "1100" else   -- display C
                  "11111111";

end Behavioral;