model_dashboard = "<?php  

class Useradmins_m extends CI_Model{


	
		public function try_login($email = NULL, $password = NULL){
       
       		//consulto BD con los datos
       		$this->db->where(array('email' => $email, 'password' => $password));
       		$query = $this->db->get('useradmin', 1, 0);

       		if ($query->num_rows != 1) return FALSE;

				$row = $query->row();
        
				$sess_array = array('id' => $row->id,'email' => $row->email);
 				
				$this->session->set_userdata('logged_in', $sess_array);

				return TRUE;
	
			}
	
		
		//Cerrar session
		public function logout(){
        	$this->session->unset_userdata('logged_in');
   			redirect('/dashboard', 'refresh');
    	}
    


}
?>"

file_model_dashboard = File.new("../application/models/useradmins_m.php", "w+")
if file_model_dashboard
   file_model_dashboard.syswrite(model_dashboard)
else
   puts "Unable to open file!"
end