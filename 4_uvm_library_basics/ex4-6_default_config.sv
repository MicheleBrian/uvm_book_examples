/**********************************************************************
  Example 4-6: Configuration Mechanism (no configuration)

  To run:   %  irun -uvm ex4-6_default_config.sv
  OR:       %  irun -uvmhome $UVM_HOME ex4-6_default_config.sv
**********************************************************************/
package my_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class master_comp extends uvm_component;
  `uvm_component_utils(master_comp)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  task run_phase (uvm_phase phase);
    `uvm_info("MASTER", "run_phase: Executing.", UVM_LOW)
  endtask : run_phase
endclass : master_comp

class slave_comp extends uvm_component;
  `uvm_component_utils(slave_comp)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  task run_phase (uvm_phase phase);
    `uvm_info("SLAVE", "run_phase: Executing.", UVM_LOW)
  endtask : run_phase
endclass : slave_comp

class interface_comp extends uvm_component;
  master_comp master[];  // dynamic array of masters
  slave_comp  slave[];   // dynamic array of slaves
  int num_masters = 3;
  int num_slaves = 5;
  string if_name = "bus_uvc";

  `uvm_component_utils_begin(interface_comp)
     `uvm_field_string(if_name, UVM_DEFAULT)
     `uvm_field_int(num_masters, UVM_DEFAULT)
     `uvm_field_int(num_slaves, UVM_DEFAULT)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    master = new[num_masters];
    slave = new[num_slaves];
    foreach (master[i])
      master[i] = master_comp::type_id::create($sformatf("master[%0d]",i), this);
    foreach (slave[i])
      slave[i]  = slave_comp::type_id::create($sformatf("slave[%0d]",i), this);
  endfunction : build_phase
  task run_phase (uvm_phase phase);
   `uvm_info("UVC", {"run_phase: Hierarchy:\n",this.sprint()}, UVM_LOW)
   `uvm_info("UVC", $sformatf("%s has %0d master(s) and %0d slave(s)",
               if_name, num_masters, num_slaves), UVM_LOW)
  endtask : run_phase
endclass : interface_comp
endpackage : my_pkg

module test;
import uvm_pkg::*;
`include "uvm_macros.svh"

import my_pkg::*;

interface_comp my_uvc;

initial begin
// Create components
  my_uvc = interface_comp::type_id::create("my_uvc", null);
// Start UVM Phases
  run_test();
end

endmodule : test
