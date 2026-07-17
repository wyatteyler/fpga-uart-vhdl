library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RX_uart is
	generic (
		CLKS_PER_BIT	:	integer := 1085
	);
	port (
		clk				:	in std_logic;
		rst				:	in std_logic;
		RX_line			:	in std_logic;
		RX_data_valid	:	out std_logic;
		RX_data_byte	:	out std_logic_vector(7 downto 0)
	);
end RX_uart;

architecture rtl of RX_uart is
type state_t is (IDLE, START, DATA, STOP);
signal current_state	:	state_t;
signal RX_sync1, RX_sync2	:	std_logic := '1';
signal r_clk_count		:	integer range 0 to CLKS_PER_BIT - 1 := 0;
signal r_bit_count		:	unsigned(2 downto 0) := (others => '0');
signal r_shift			:	std_logic_vector(7 downto 0) := (others => '0');
begin
	p_sync	:	process(clk)
	begin
		if rising_edge(clk) then
			RX_sync1 <= RX_line;
			RX_sync2 <= RX_sync1;
		end if;
	end process p_sync;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				current_state <= IDLE;
				r_clk_count <= 0;
				r_bit_count <= (others => '0');
				r_shift <= (others => '0');
				RX_data_valid <= '0';
			else
				case current_state is
					when IDLE =>
						RX_data_valid <= '0';
						r_bit_count <= (others => '0');
						if RX_sync2 = '0' then
							current_state <= START;
						else
							current_state <= IDLE;
						end if;
					when START =>
						if r_clk_count = (CLKS_PER_BIT - 1) / 2 then
							r_clk_count <= 0;
							if RX_sync2 = '0' then
								current_state <= DATA;
							else
								current_state <= IDLE;
							end if;
						else 
							r_clk_count <= r_clk_count + 1;
							current_state <= START;
						end if;
					when DATA =>
						if r_clk_count = CLKS_PER_BIT - 1 then
							r_clk_count <= 0;
							r_shift(to_integer(r_bit_count)) <= RX_sync2;
							if r_bit_count = "111" then
								current_state <= STOP;
							else
								r_bit_count <= r_bit_count + 1;
								current_state <= DATA;
							end if;
						else
							r_clk_count <= r_clk_count + 1;
							current_state <= DATA;
						end if;
					when STOP =>
						if r_clk_count = CLKS_PER_BIT - 1 then
							r_clk_count <= 0;
							RX_data_valid <= '1';
							current_state <= IDLE;
						else
							r_clk_count <= r_clk_count + 1;
							current_state <= STOP;
						end if;
				end case;
			end if;
		end if;
	end process;
	RX_data_byte <= r_shift;
end architecture rtl;
						
				
					