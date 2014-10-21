model_permiso = "<?php  

class Permiso extends CI_Model{

	public function __construct(){

	$this->load->database();
	$this->load->model('usuario');
	$this->load->model('modulo');


	}
	//all
	public function get_records($num,$start){
		$this->db->select()->from('permisos')
		->where('status', 0)->group_by('id','ASC')
		->limit($num,$start);
		return $this->db->get();

	}


	public function verify_access($modulo_nombre, $accion){
		 $modulo = $this->modulo->find_by_name($modulo_nombre);

		if( empty($modulo) ){ redirect('/control'); }

		// traer role del user
		$role_user = $this->usuario->check_role_usuario($this->session->userdata('logged_in')['id']);

		if( $role_user < 1 || $role_user == \"\" ){ 
			$this->session->set_flashdata('error', 'No tiene acceso a esta opcion.');
			redirect('/control');  }

		// verificar permisos esa accion para ese rol
		$this->db->where('role_id' ,$role_user);
		$this->db->where('modulo' ,$modulo);
		$this->db->where('url' ,$accion);
		$this->db->limit(1);
		$c = $this->db->get('permisos');

		if($c->row('permiso')==1){
			return TRUE;
		}else{
			$this->session->set_flashdata('error', 'No tiene acceso a esta opcion.');
			redirect('/control');}
		
		$this->session->set_flashdata('error', 'No tiene acceso a esta opcion.');
			redirect('/control');
	}

	public function verify_access_ajax($modulo_nombre, $accion){
		 $modulo = $this->modulo->find_by_name($modulo_nombre);

		if( empty($modulo) ){ redirect('/control'); }

		// traer role del user
		$role_user = $this->usuario->check_role_usuario($this->session->userdata('logged_in')['id']);

		if( $role_user < 1 || $role_user == "" ){ 
			$this->session->set_flashdata('error', 'No tiene acceso a esta opcion.');
			redirect('/control');  }

		// verificar permisos esa accion para ese rol
		$this->db->where('role_id' ,$role_user);
		$this->db->where('modulo' ,$modulo);
		$this->db->where('url' ,$accion);
		$this->db->limit(1);
		$c = $this->db->get('permisos');

		if($c->row('permiso')==1){
			return TRUE;
		}else{
			return FALSE;
		}
		
		return FALSE;
	}



	public function check_permission($id, $modulo, $accion){

		// traer role del user
		$role_user = $this->usuario->check_role_usuario($id);

		if( $role_user < 1 || $role_user == "" ){ return FALSE; }

		// verificar permisos esa accion para ese rol
		$this->db->where('role_id' ,$role_user);
		$this->db->where('modulo' ,$modulo);
		$this->db->where('url' ,$accion);
		$this->db->limit(1);
		$c = $this->db->get('permisos');

		if($c->row('permiso')==1){return TRUE;}else{return FALSE;}
		
		return FALSE;
					
	}


	//Muestra el tipo de permiso por rol en /control/permisos
	public function show_permiso_rol($role_id, $modulo, $action){
		$this->db->where('role_id' ,$role_id);
		$this->db->where('modulo' ,$modulo);
		$this->db->where('url' ,$action);
		$this->db->limit(1);
		$c = $this->db->get('permisos');
	
		if($c->row('permiso')== 1){
			return TRUE;
		}else{
			$newpermiso = array( 'role_id' => $role_id, 
		 	'modulo' => $modulo, 
		 	'url' => $action, 
		 	'permiso' => 0, 
			);
			#save
			$this->permiso->add_record($newpermiso);
			return FALSE;
		}
		return FALSE;
	}


	//Muestra el tipo de parmiso por rol en /control/permisos
	public function modificar_permiso_rol($role_id, $modulo, $action, $nuevo_permiso){
		$this->db->where('role_id' ,$role_id);
		$this->db->where('modulo' ,$modulo);
		$this->db->where('url' ,$action);
		$this->db->limit(1);
		$c = $this->db->get('permisos');
		
		$edited = array( 'permiso' => $nuevo_permiso);
		$this->update_record($c->row('id'), $edited);
		return TRUE;
	}




	//detail
	public function get_record($id){
		$this->db->where('id' ,$id);
		$this->db->limit(1);
		$c = $this->db->get('permisos');

		return $c->row(); 
	}
	
	//total rows
	public function count_rows(){ 
		$this->db->select('id')->where('status', 0)->from('permisos');
		$query = $this->db->get();
		return $query->num_rows();
	}



		//add new
		public function add_record($data){ $this->db->insert('permisos', $data);
				

	}


		//update
		public function update_record($id, $data){

			$this->db->where('id', $id);
			$this->db->update('permisos', $data);

		}

		//destroy
		public function delete_record(){

			$this->db->where('id', $this->uri->segment(4));
			$this->db->delete('permisos');
		}


		/*
		public function traer_nombre($id){
					$this->db->where('permisos_categoria_id' ,$id);
					$this->db->limit(1);
					$c = $this->db->get('permisos');

					return $c->row('nombre'); 
				}
		
		*/

}

?>"

file_model_permiso = File.new("../application/models/permiso.php", "w+")
if file_model_permiso
   file_model_permiso.syswrite(model_permiso)
else
   puts "Unable to open file!"
end