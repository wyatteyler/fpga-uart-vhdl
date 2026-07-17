library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TX_uart is
	generic (
		CLKS_PER_BIT	:	integer := 1085
	);
	port(
		clk			:	in std_logic;
		rst			:	in std_logic;
		TX_start	:	in std_logic;
		TX_data_in	:	in std_logic_vector(7 downto 0);
		TX_line		:	out std_logic;
		TX_done		:	out std_logic
	);
end TX_uart;

architecture rtl of TX_uart is
type state_t is (IDLE, START, DATA, STOP);
signal current_state	:	state_t;
signal r_clk_count	:	integer range 0 to CLKS_PER_BIT - 1 := 0;
signal r_bit_count	:	unsigned(2 downto 0) := (others => '0');
signal r_shift		:	std_logic_vector(7 downto 0) := (others => '0');
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				current_state <= IDLE;
				TX_line <= '1';
				TX_done <= '0';
				r_clk_count <= 0;
				r_bit_count <= (others => '0');
				r_shift <= (others => '0');
			else
				case current_state is
					when IDLE =>
						TX_line <= '1';
						TX_done <= '0';
						r_clk_count <= 0;
						if TX_start = '1' then
							r_shift <= TX_data_in;
							r_bit_count <= (others => '0');
							current_state <= START;
						end if;
					when START =>
						TX_line <= '0';
						if r_clk_count = CLKS_PER_BIT - 1 then
							r_clk_count <= 0;
							current_state <= DATA;
						else
							r_clk_count <= r_clk_count + 1;
						end if;
					when DATA =>
						TX_line <= r_shift(0);
						if r_clk_count = CLKS_PER_BIT - 1 then
							r_clk_count <= 0;
							if r_bit_count = "111" then
								current_state <= STOP;
							else
								r_shift <= '0' & r_shift(7 downto 1);
								r_bit_count <= r_bit_count + 1;
							end if;
						else
							r_clk_count <= r_clk_count + 1;
						end if;
					when STOP =>
						TX_line <= '1';
						if r_clk_count = CLKS_PER_BIT - 1 then
							r_clk_count <= 0;
							TX_done <= '1';
							current_state <= IDLE;
						else
							r_clk_count <= r_clk_count + 1;
						end if;
				end case;
			end if;
		end if;
	end process;
end architecture rtl;
					
							
						