-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\lab2_first_part\Sybsystem_FixPoint.vhd
-- Created: 2023-01-12 00:13:00
-- 
-- Generated by MATLAB 9.12 and HDL Coder 3.20
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 1
-- Target subsystem base rate: 1
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        1
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- o_VALID                       ce_out        1
-- o_MAGNITUDE                   ce_out        1
-- o_PHASE                       ce_out        1
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Sybsystem_FixPoint
-- Source Path: lab2_first_part/Sybsystem_FixPoint
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.Sybsystem_FixPoint_pkg.ALL;

ENTITY Sybsystem_FixPoint IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        i_VALID                           :   IN    std_logic;
        i_COMPLEX_re                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En15
        i_COMPLEX_im                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En15
        ce_out                            :   OUT   std_logic;
        o_VALID                           :   OUT   std_logic;
        o_MAGNITUDE                       :   OUT   std_logic_vector(32 DOWNTO 0);  -- sfix33_En15
        o_PHASE                           :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En13
        );
END Sybsystem_FixPoint;


ARCHITECTURE rtl OF Sybsystem_FixPoint IS

  -- Component Declarations
  COMPONENT Sqrt
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          din                             :   IN    std_logic_vector(63 DOWNTO 0);  -- sfix64_En30
          dout                            :   OUT   std_logic_vector(32 DOWNTO 0)  -- sfix33_En15
          );
  END COMPONENT;

  COMPONENT atan2_cordic_nw
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          y_in                            :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En15
          x_in                            :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En15
          angle                           :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En29
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Sqrt
    USE ENTITY work.Sqrt(rtl);

  FOR ALL : atan2_cordic_nw
    USE ENTITY work.atan2_cordic_nw(rtl);

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 33);  -- ufix1 [34]
  SIGNAL i_VALID_1                        : std_logic;
  SIGNAL i_COMPLEX_re_signed              : signed(31 DOWNTO 0);  -- sfix32_En15
  SIGNAL i_COMPLEX_im_signed              : signed(31 DOWNTO 0);  -- sfix32_En15
  SIGNAL Product1_out1                    : signed(63 DOWNTO 0);  -- sfix64_En30
  SIGNAL Product_out1                     : signed(63 DOWNTO 0);  -- sfix64_En30
  SIGNAL Add_out1                         : signed(63 DOWNTO 0);  -- sfix64_En30
  SIGNAL Sqrt_out1                        : std_logic_vector(32 DOWNTO 0);  -- ufix33
  SIGNAL Atan2_out1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Atan2_out1_signed                : signed(31 DOWNTO 0);  -- sfix32_En29
  SIGNAL alpha16_13_out1                  : signed(15 DOWNTO 0);  -- sfix16_En13
  SIGNAL delayMatch1_reg                  : vector_of_signed16(0 TO 19);  -- sfix16 [20]
  SIGNAL alpha16_13_out1_1                : signed(15 DOWNTO 0);  -- sfix16_En13

BEGIN
  u_Sqrt : Sqrt
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              din => std_logic_vector(Add_out1),  -- sfix64_En30
              dout => Sqrt_out1  -- sfix33_En15
              );

  u_Atan2_inst : atan2_cordic_nw
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              y_in => i_COMPLEX_im,  -- sfix32_En15
              x_in => i_COMPLEX_re,  -- sfix32_En15
              angle => Atan2_out1  -- sfix32_En29
              );

  enb <= clk_enable;

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= i_VALID;
        delayMatch_reg(1 TO 33) <= delayMatch_reg(0 TO 32);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  i_VALID_1 <= delayMatch_reg(33);

  i_COMPLEX_re_signed <= signed(i_COMPLEX_re);

  Product1_out1 <= i_COMPLEX_re_signed * i_COMPLEX_re_signed;

  i_COMPLEX_im_signed <= signed(i_COMPLEX_im);

  Product_out1 <= i_COMPLEX_im_signed * i_COMPLEX_im_signed;

  Add_out1 <= Product1_out1 + Product_out1;

  Atan2_out1_signed <= signed(Atan2_out1);

  alpha16_13_out1 <= Atan2_out1_signed(31 DOWNTO 16) + ('0' & (Atan2_out1_signed(15) AND (( NOT Atan2_out1_signed(31)) OR (Atan2_out1_signed(14) OR Atan2_out1_signed(13) OR Atan2_out1_signed(12) OR Atan2_out1_signed(11) OR Atan2_out1_signed(10) OR Atan2_out1_signed(9) OR Atan2_out1_signed(8) OR Atan2_out1_signed(7) OR Atan2_out1_signed(6) OR Atan2_out1_signed(5) OR Atan2_out1_signed(4) OR Atan2_out1_signed(3) OR Atan2_out1_signed(2) OR Atan2_out1_signed(1) OR Atan2_out1_signed(0)))));

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => to_signed(16#0000#, 16));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        delayMatch1_reg(0) <= alpha16_13_out1;
        delayMatch1_reg(1 TO 19) <= delayMatch1_reg(0 TO 18);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  alpha16_13_out1_1 <= delayMatch1_reg(19);

  o_PHASE <= std_logic_vector(alpha16_13_out1_1);

  ce_out <= clk_enable;

  o_VALID <= i_VALID_1;

  o_MAGNITUDE <= Sqrt_out1;

END rtl;

