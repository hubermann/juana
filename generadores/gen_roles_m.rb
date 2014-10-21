model_roles = "<?php  

class Rol extends CI_Model{

	public function __construct(){

	$this->load->database();

	}
	//all
	public function get_records(){
		$this->db->select()->from('roles')->where('status', 0)->order_by('nombre','ASC');
		return $this->db->get();

	}




	//detail
	public function get_record($id){
		$this->db->where('id' ,$id);
		$this->db->limit(1);
		$c = $this->db->get('roles');

		return $c->row(); 
	}
	
	//total rows
	public function count_rows(){ 
		$this->db->select('id')->where('status', 0)->from('roles');
		$query = $this->db->get();
		return $query->num_rows();
	}



		//add new
		public function add_record($data){ $this->db->insert('roles', $data);
				

	}


		//update
		public function update_record($id, $data){

			$this->db->where('id', $id);
			$this->db->update('roles', $data);

		}

		//destroy
		public function delete_record(){

			$this->db->where('id', $this->uri->segment(4));
			$this->db->delete('roles');
		}


		
		public function traer_nombre($id){
					$this->db->where('id' ,$id);
					$this->db->limit(1);
					$c = $this->db->get('roles');

					return $c->row('nombre'); 
				}
		
		

}

?>"

file_model_roles = File.new("../application/models/rol.php", "w+")
if file_model_roles
   file_model_roles.syswrite(model_roles)
else
   puts "Unable to open file!"
end