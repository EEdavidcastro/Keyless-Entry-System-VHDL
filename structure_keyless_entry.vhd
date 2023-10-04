library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--strucutral file of Keyless Entry system

entity structure_keyless_entry is
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
        LED7: out std_logic_vector(7 downto 0) --output for the 7Seg
--        state_light: out std_logic_vector(7 downto 0); --meant for debugging
--        start_output: out std_logic   --meant for debugging
    );
end structure_keyless_entry;

architecture Behavioral of structure_keyless_entry is
  --signals for connecting the components
    --signal for connecting state logic
    signal signal_state: Integer range 0 to 7;  
    
    --will connect the stored numbers to sevseg display
    signal signal_lock_code_storage_1: std_logic_vector(1 downto 0);
    signal signal_lock_code_storage_2: std_logic_vector(1 downto 0);
    signal signal_lock_code_storage_3: std_logic_vector(1 downto 0);
    signal signal_lock_code_storage_4: std_logic_vector(1 downto 0);
    signal signal_unlock_code_storage_1: std_logic_vector(1 downto 0);
    signal signal_unlock_code_storage_2: std_logic_vector(1 downto 0);
    signal signal_unlock_code_storage_3: std_logic_vector(1 downto 0);
    signal signal_unlock_code_storage_4: std_logic_vector(1 downto 0);

    component keyless_entry
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
    end Component;
    
    Component SevSeg
       Port(
        lock_code_storage_1: in std_logic_vector(1 downto 0);
        lock_code_storage_2: in std_logic_vector(1 downto 0);
        lock_code_storage_3: in std_logic_vector(1 downto 0);
        lock_code_storage_4: in std_logic_vector(1 downto 0);
        unlock_code_storage_1: in std_logic_vector(1 downto 0);
        unlock_code_storage_2: in std_logic_vector(1 downto 0);
        unlock_code_storage_3: in std_logic_vector(1 downto 0);
        unlock_code_storage_4: in std_logic_vector(1 downto 0);
        AN: out std_logic_vector(7 downto 0);
        LED7: out std_logic_vector(7 downto 0);
        clk: in std_logic;
        state_input: in Integer range 0 to 7
        );
    end Component;
    
begin
    States: keyless_entry Port Map
    (
    clk => clk,
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
    led_locked => led_locked,
    led_unlocked => led_unlocked,
    led_status => led_status,
    lock_code_storage_1 => signal_lock_code_storage_1,
    lock_code_storage_2 => signal_lock_code_storage_2,
    lock_code_storage_3 => signal_lock_code_storage_3,
    lock_code_storage_4 => signal_lock_code_storage_4,
    unlock_code_storage_1 => signal_unlock_code_storage_1,
    unlock_code_storage_2 => signal_unlock_code_storage_2,
    unlock_code_storage_3 => signal_unlock_code_storage_3,
    unlock_code_storage_4 => signal_unlock_code_storage_4,
    state_out => signal_state
--    start_output => start_output --meant for debugging
    );

    SevenSegment: SevSeg Port Map
    (
    lock_code_storage_1 => signal_lock_code_storage_1,
    lock_code_storage_2 => signal_lock_code_storage_2,
    lock_code_storage_3 => signal_lock_code_storage_3,
    lock_code_storage_4 => signal_lock_code_storage_4,
    unlock_code_storage_1 => signal_unlock_code_storage_1,
    unlock_code_storage_2 => signal_unlock_code_storage_2,
    unlock_code_storage_3 => signal_unlock_code_storage_3,
    unlock_code_storage_4 => signal_unlock_code_storage_4,
    LED7 => LED7,
    AN => AN,
    clk => clk,
    state_input => signal_state
    );
    
    --for checking what state im in and outputting it for debugging
--    Process(signal_state)
--        begin
--            case signal_state is
--                when 0 =>
--                    state_light <= "00000001";
                    
--                when 1 =>
--                    state_light <= "00000010";
                    
--                when 2 =>
--                    state_light <= "00000100";
                
--                when 3 =>
--                    state_light <= "00001000";
                
--                when 4 =>
--                    state_light <= "00010000";
                
--                when 5 =>
--                    state_light <= "00100000";
                
--                when 6 =>
--                    state_light <= "01000000";
                
--                when 7 =>
--                    state_light <= "10000000";
                
--        end case;
--    end Process;
end Behavioral;
