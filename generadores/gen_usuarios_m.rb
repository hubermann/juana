model_dashboard = "<?php  

class Usuario extends CI_Model{

	public function __construct(){

	$this->load->database();

	}
	//all
	public function get_records($num,$start){
		$this->db->select()->from('usuarios')
		->where('status', 0)
		->order_by('id','ASC')
		->limit($num,$start);

		return $this->db->get();

	}

	function check_role_usuario($id){
		$this->db->where('id' ,$id);
		$this->db->limit(1);
		$c = $this->db->get('usuarios');

		return $c->row('role_id');

	}





	function check_credentials($email, $password){

		$this->db->where(array('email' => $email));
       		$query = $this->db->get('usuarios', 1, 0);

       		if ($query->num_rows != 1) return FALSE;
			
	       		$db_salt = $query->row('salt'); 
	       		echo 'hash:'.$db_hash = $query->row('password'); 
	       		if ($db_hash === hash('sha512', $db_salt.$password))
				{
					// Contraseña correcta (creo session)
					$sess_array = array('id' => $query->row('id'),'email' => $query->row('email'),'role_id' => $query->row('role_id'));
					$this->session->set_userdata('logged_in', $sess_array);
					return TRUE;
				}
		//return false por defecto
		return FALSE;
	}


	//Cerrar session
	public function logout(){
    	$this->session->unset_userdata('logged_in');
			redirect('/dashboard', 'refresh');
	}



	//detail
	public function get_record($id){
		$this->db->where('id' ,$id);
		$this->db->limit(1);
		$c = $this->db->get('usuarios');

		return $c->row(); 
	}
	
	//total rows
	public function count_rows(){ 
		$this->db->select('id')->where('status', 0)->from('usuarios');
		$query = $this->db->get();
		return $query->num_rows();
	}



		//add new
		public function add_record($data){ $this->db->insert('usuarios', $data);
				

	}


		//update
		public function update_record($id, $data){

			$this->db->where('id', $id);
			$this->db->update('usuarios', $data);

		}

		//destroy
		public function delete_record(){

			$this->db->where('id', $this->uri->segment(4));
			$this->db->delete('usuarios');
		}


		/*
		public function traer_nombre($id){
					$this->db->where('usuarios_categoria_id' ,$id);
					$this->db->limit(1);
					$c = $this->db->get('usuarios');

					return $c->row('nombre'); 
				}
		
		*/

}

?>"

file_model_dashboard = File.new("../application/models/usuario.php", "w+")
if file_model_dashboard
   file_model_dashboard.syswrite(model_dashboard)
else
   puts "Unable to open file!"
end