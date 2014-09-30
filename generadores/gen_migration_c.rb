controller_migration = "<?php defined(\"BASEPATH\") or exit(\"No direct script access allowed\");

class Migrate extends CI_Controller{
    /*
    public function index(){
    	
        $this->load->library(\"migration\");

      if(!$this->migration->version($this->uri->segment(2))){
          show_error($this->migration->error_string());
      }else{
      	echo 'Realizada la migracion '.$this->uri->segment(2);
      }   
    }
    */
}"

file_controller_migration = File.new("../application/controllers/migrate.php", "w+")
if file_controller_migration
   file_controller_migration.syswrite(controller_migration)
else
   puts "Unable to open file!"
end