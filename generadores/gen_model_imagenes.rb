model = "<?php  

class Imagenes_#{@singular} extends CI_Model{

	public function __construct(){

	$this->load->database();

	}
	//all
	public function get_records($num,$start){
		$this->db->select()->from('imagenes_#{@plural}')->limit($num,$start);
		return $this->db->get();

	}
	
	
	
	function view_all($id){
		
		$this->db->where('#{@singular}_id', $id);
		return  $this->db->get('imagenes_#{@plural}');
		
		
		}
		
	//all by publiccacion
	public function imagenes_#{@singular}($id_#{@singular}){

		$this->db->select()->from('imagenes_#{@plural}')->where('#{@singular}_id',$id_#{@singular});
		return $this->db->get();

	}

	//detail
	public function get_record($id){
		$this->db->where('id' ,$id);
		$this->db->limit(1);
		$c = $this->db->get('imagenes_#{@plural}');

		return $c->row(); 
	}
	
	public function get_records_menu(){
			$this->db->select()->from('imagenes_#{@plural}')->order_by('id','ASC');
			return $this->db->get();
	
		}
	
	//total rows
	public function count_rows(){ 
		$this->db->select('id')->from('imagenes_#{@plural}');
		$query = $this->db->get();
		return $query->num_rows();
	}



		//add new
		public function add_record($data){ 
		
		$this->db->insert('imagenes_#{@plural}', $data);
		}


		//update
		public function update_record($id, $data){

			$this->db->where('id', $id);
			$this->db->update('imagenes_#{@plural}', $data);

		}

		//destroy
		public function delete_record($id_imagen){

			$this->db->where('id', $id_imagen);
			$this->db->delete('imagenes_#{@plural}');
		}
		
		




}


?>"

file_model = File.new("../application/models/imagenes_"+@singular+".php", "w+")
if file_model
   file_model.syswrite(model)
else
   puts "Unable to open file!"
end