library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

package alu_operations is

  -- Integer arithmetic operations
  function f_ADD    ( s1, s2 : std_logic_vector(31 downto 0))
  return std_logic_vector;

  function f_AND    ( s1, s2 : std_logic_vector(31 downto 0))
  return std_logic_vector;

  function f_OR     ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic_vector;

  function f_SHL    ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic_vector;

  function f_SHRU    ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic_vector;

  function f_SUB    ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic_vector;

  function f_XOR    ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic_vector;

  function f_SLT ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic;                    

end package alu_operations;


package body alu_operations is

  -- Integer arithmetic operations
  function f_ADD    ( s1, s2 : std_logic_vector(31 downto 0))
  return std_logic_vector is
  begin
    return (s1 + s2);
  end function f_ADD;

  function f_AND    ( s1, s2 : std_logic_vector(31 downto 0))
  return std_logic_vector is
  variable t : std_logic_vector(31 downto 0);
  begin
    t := s1 and s2;
    return t;
  end function f_AND;

  function f_OR     ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic_vector is
  begin
    return (s1 or s2);
  end function f_OR;

  function f_SHL    ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic_vector is
  begin
    return SHL (s1, s2);
  end function f_SHL;

  function f_SHRU   ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic_vector is
  begin
    return ieee.std_logic_unsigned.SHR (s1, s2);
  end function f_SHRU;

  function f_SUB    ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic_vector is
  begin
    return (s1 - s2);
  end function f_SUB;

  function f_XOR    ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic_vector is
  begin
    return (s1 xor s2);
  end function f_XOR;

  function f_SLT ( s1, s2 : in std_logic_vector(31 downto 0))
  return std_logic is
  begin
    if (unsigned(s1) <= unsigned(s2)) then
      return '1';
    else
      return '0';
    end if;
  end function f_SLT;
end package body alu_operations;
