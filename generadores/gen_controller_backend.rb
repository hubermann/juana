controller_file = "<?php 

class "+@plural+" extends CI_Controller{


public function __construct(){

parent::__construct();
$this->load->model('"+@singular+"');"

if @imagenes == "2"
	controller_file << "$this->load->model('imagenes_"+@singular+"');"
end

controller_file <<"
$this->load->helper('url');
$this->load->library('session');

//Si no hay session redirige a Login
if(! $this->session->userdata('logged_in')){
redirect('dashboard');
}



}

public function index(){
	//Pagination
	$per_page = 4;
	$page = $this->uri->segment(3);
	if(!$page){ $start =0; $page =1; }else{ $start = ($page -1 ) * $per_page; }
		$data['pagination_links'] = \"\";
		$total_pages = ceil($this->"+@singular+"->count_rows() / $per_page);

		if ($total_pages > 1){ 
			for ($i=1;$i<=$total_pages;$i++){ 
			if ($page == $i) 
				//si muestro el índice de la página actual, no coloco enlace 
				$data['pagination_links'] .=  '<li class=\"active\"><a>'.$i.'</a></li>'; 
			else 
				//si el índice no corresponde con la página mostrada actualmente, coloco el enlace para ir a esa pagina 
				$data['pagination_links']  .= '<li><a href=\"'.base_url().'control/"+@plural+"/'.$i.'\" > '. $i .'</a></li>'; 
		} 
	}
	//End Pagination

	$data['title'] = '"+@plural+"';
	$data['menu'] = 'control/"+@plural+"/menu_"+@singular+"';
	$data['content'] = 'control/"+@plural+"/all';
	$data['query'] = $this->"+@singular+"->get_records($per_page,$start);

	$this->load->view('control/control_layout', $data);

}

//detail
public function detail(){

$data['title'] = '"+@singular+"';
$data['content'] = 'control/"+@plural+"/detail';
$data['menu'] = 'control/"+@plural+"/menu_"+@singular+"';
$data['query'] = $this->"+@singular+"->get_record($this->uri->segment(4));
$this->load->view('control/control_layout', $data);
}


//new
public function form_new(){
$this->load->helper('form');
$data['title'] = 'Nuevo "+@singular+"';
$data['content'] = 'control/"+@plural+"/new_"+@singular+"';
$data['menu'] = 'control/"+@plural+"/menu_"+@singular+"';
$this->load->view('control/control_layout', $data);
}

//create
public function create(){

	$this->load->helper('form');
	$this->load->library('form_validation');"

@campos_clean.each do |campo|
	if campo != "filename"
		controller_file << "\n$this->form_validation->set_rules('#{campo}', '#{campo.capitalize}', 'required');\n"
	end
end

controller_file <<"
	
	if ($this->form_validation->run() === FALSE){

		$this->load->helper('form');
		$data['title'] = 'Nuevo "+@plural+"';
		$data['content'] = 'control/"+@plural+"/new_"+@singular+"';
		$data['menu'] = 'control/"+@plural+"/menu_"+@singular+"';
		$this->load->view('control/control_layout', $data);

	}else{
		/*
		$this->load->helper('url');
		$slug = url_title($this->input->post('titulo'), 'dash', TRUE);
		*/"

#si lleva un adjunto
if @imagenes == "1"
controller_file <<"
		$file  = $this->upload_file();
		if($_FILES['filename']['size'] > 0){
			if ( $file['status'] == 0 ){
				$this->session->set_flashdata('error', $file['msg']);
			}
		}else{
			$file['filename'] = '';
		}
		"
end

#new array para guardar
controller_file <<"$new"+@singular+" = array("

#campos para el array encargado de guardar
@campos_clean.each do |campo|
	if campo != "filename"
		controller_file << " '#{campo}' => $this->input->post('#{campo}'), \n"
	end
	
end

#si lleva un adjunto
if @imagenes == "1"
	controller_file <<"'filename' => $file['filename'], \n"   
		
end

controller_file <<");
		#save
		$this->"+@singular+"->add_record($new"+@singular+");
		$this->session->set_flashdata('success', '"+@singular+" creado. <a href=\""+@plural+"/detail/'.$this->db->insert_id().'\">Ver</a>');
		redirect('control/"+@plural+"', 'refresh');

	}



}

//edit
public function editar(){
	$this->load->helper('form');
	$data['title']= 'Editar "+@singular+"';	
	$data['content'] = 'control/"+@plural+"/edit_"+@singular+"';
	$data['menu'] = 'control/"+@plural+"/menu_"+@singular+"';
	$data['query'] = $this->"+@singular+"->get_record($this->uri->segment(4));
	$this->load->view('control/control_layout', $data);
}

//update
public function update(){
	$this->load->helper('form');
	$this->load->library('form_validation'); " 	


@campos_clean.each do |campo|
	if campo != "filename"
		controller_file << "\n$this->form_validation->set_rules('#{campo}', '#{campo.capitalize}', 'required');\n"
	end
end


controller_file <<"

	$this->form_validation->set_message('required','El campo %s es requerido.');

	if ($this->form_validation->run() === FALSE){
		$this->load->helper('form');

		$data['title'] = 'Nuevo "+@singular+"';
		$data['content'] = 'control/"+@plural+"/edit_"+@singular+"';
		$data['menu'] = 'control/"+@plural+"/menu_"+@singular+"';
		$data['query'] = $this->"+@singular+"->get_record($this->input->post('id'));
		$this->load->view('control/control_layout', $data);
	}else{"

if @imagenes == "1"
controller_file <<"
		if($_FILES['filename']['size'] > 0){
		
			$file  = $this->upload_file();
		
			if ( $file['status'] != 0 )
				{
				//guardo
				$"+@singular+" = $this->"+@singular+"->get_record($this->input->post('id'));
					 $path = 'images-"+@plural+"/'.$"+@singular+"->filename;
					 if(is_link($path)){
						unlink($path);
					 }
				
				
				$data = array('filename' => $file['filename']);
				$this->"+@singular+"->update_record($this->input->post('id'), $data);
				}
		
		
}"
end


controller_file <<"		
		$id=  $this->input->post('id');

		$edited"+@singular+" = array(  "

#campos para el array de update
@campos_clean.each do |campo|
	if campo != "filename"
		controller_file << "\n'#{campo}' => $this->input->post('#{campo}'),\n"
	end
end			


controller_file <<");
		#save
		$this->session->set_flashdata('success', '"+@singular+" Actualizado!');
		$this->"+@singular+"->update_record($id, $edited"+@singular+");
		if($this->input->post('id')!=\"\"){
			redirect('control/"+@plural+"', 'refresh');
		}else{
			redirect('control/"+@plural+"', 'refresh');
		}



	}



}


//delete comfirm		
public function delete_comfirm(){
	$this->load->helper('form');
	$data['content'] = 'control/"+@plural+"/comfirm_delete';
	$data['title'] = 'Eliminar "+@singular+"';
	$data['menu'] = 'control/"+@plural+"/menu_"+@singular+"';
	$data['query'] = $data['query'] = $this->"+@singular+"->get_record($this->uri->segment(4));
	$this->load->view('control/control_layout', $data);


}

//delete
public function delete(){

	$this->load->helper('form');
	$this->load->library('form_validation');

	$this->form_validation->set_rules('comfirm', 'comfirm', 'required');
	$this->form_validation->set_message('required','Por favor, confirme para eliminar.');


	if ($this->form_validation->run() === FALSE){
		#validation failed
		$this->load->helper('form');

		$data['content'] = 'control/"+@plural+"/comfirm_delete';
		$data['title'] = 'Eliminar "+@singular+"';
		$data['menu'] = 'control/"+@plural+"/menu_"+@singular+"';
		$data['query'] = $this->"+@singular+"->get_record($this->input->post('id'));
		$this->load->view('control/control_layout', $data);
	}else{
		#validation passed
		$this->session->set_flashdata('success', '"+@singular+" eliminado!');

		$prod = $this->"+@singular+"->get_record($this->input->post('id'));
			$path = 'images-"+@plural+"/'.$prod->filename;
			if(is_link($path)){
				unlink($path);
			}
		

		$this->"+@singular+"->delete_record();
		redirect('control/"+@plural+"', 'refresh');
		

	}
}
"
if @imagenes == "1"
controller_file <<"
public function upload_file(){

	//1 = OK - 0 = Failure
	$file = array('status' => '', 'filename' => '', 'msg' => '' );


	//check ext.
	$file_extensions_allowed = array('image/gif', 'image/png', 'image/jpeg', 'image/jpg');
	$exts_humano = array('gif', 'png', 'jpeg', 'jpg');
	$exts_humano = implode(', ',$exts_humano);
	$ext = $_FILES['filename']['type'];
	\#$ext = strtolower($ext);
	if(!in_array($ext, $file_extensions_allowed)){
		$exts = implode(', ',$file_extensions_allowed);

		$file['msg'] .=\"<p>\".$_FILES['filename']['name'].\" <br />Puede subir archivos que tengan alguna de estas extenciones: \".$exts_humano.\"</p>\";

	}else{
		include(APPPATH.'libraries/class.upload.php');
		$yukle = new upload;
		$yukle->set_max_size(1900000);
		$yukle->set_directory('./images-"+@plural+"');
		$yukle->set_tmp_name($_FILES['filename']['tmp_name']);
		$yukle->set_file_size($_FILES['filename']['size']);
		$yukle->set_file_type($_FILES['filename']['type']);
		$random = substr(md5(rand()),0,6);
		$name_whitout_whitespaces = str_replace(\" \",\"-\",$_FILES['filename']['name']);
		$imagname=''.$random.'_'.$name_whitout_whitespaces;
		\#$thumbname='tn_'.$imagname;
		$yukle->set_file_name($imagname);


		$yukle->start_copy();


		if($yukle->is_ok()){
			\#$yukle->resize(600,0);
			\#$yukle->set_thumbnail_name('tn_'.$random.'_'.$name_whitout_whitespaces);
			\#$yukle->create_thumbnail();
			\#$yukle->set_thumbnail_size(180, 0);

			//UPLOAD ok
			$file['filename'] = $imagname;
			$file['status'] = 1;
		}
		else{
			$file['status'] = 0 ;
			$file['msg'] = 'Error al subir archivo';
		}

		//clean
		$yukle->set_tmp_name('');
		$yukle->set_file_size('');
		$yukle->set_file_type('');
		$imagname='';
	}//fin if(extencion)	


	return $file;
}
"
end
##IMAGENES MULTIPLES

if @imagenes == "2"
	controller_file <<"
	public function imagenes(){
	$this->load->helper('form');
	$data['content'] = 'control/"+@plural+"/imagenes';
	$data['title'] = 'Imagenes ';
	$data['menu'] = 'control/"+@plural+"/menu_"+@singular+"';
	$data['query_imagenes'] = $this->imagenes_"+@singular+"->imagenes_"+@singular+"($this->uri->segment(4));
	$this->load->view('control/control_layout', $data);
}


	public function add_imagen(){

	//adjunto
	if($_FILES['adjunto']['size'] > 0){

	$file  = $this->upload_file();

	if ( $file['status'] != 0 ){
		//guardo
		$nueva_imagen = array(  
			'"+@singular+"_id' => $this->input->post('id'),
			'filename' => $file['filename'],
		);
		#save
		$this->session->set_flashdata('success', 'Imagen cargada!');
		$this->imagenes_"+@singular+"->add_record($nueva_imagen);	
		redirect('control/"+@plural+"/imagenes/'.$this->input->post('id'));
	}


	}
	$this->session->set_flashdata('error', $file['msg']);
	redirect('control/"+@plural+"/imagenes/'.$this->input->post('id'));
}

public function delete_imagen(){
	$id_imagen = $this->uri->segment(4); 
	 
	$imagen = $this->imagenes_"+@singular+"->get_record($id_imagen);
	$path = 'images-"+@plural+"/'.$imagen->filename;
	unlink($path);
	
	$this->imagenes_"+@singular+"->delete_record($id_imagen);	
	#echo \"Eliminada : \".$imagen->filename;
}



/*******  FILE ADJUNTO  ********/
public function upload_file(){
	
	//1 = OK - 0 = Failure
	$file = array('status' => '', 'filename' => '', 'msg' => '' );
	
	array('image/jpeg','image/pjpeg', 'image/jpg', 'image/png', 'image/gif','image/bmp');
	//check extencion
	/*
	$file_extensions_allowed = array('application/pdf', 'application/msword', 'application/rtf', 'application/vnd.ms-excel','application/vnd.ms-powerpoint','application/zip','application/x-rar-compressed', 'text/plain');
	$exts_humano = array('PDF', 'WORD', 'RTF', 'EXCEL', 'PowerPoint', 'ZIP', 'RAR');
	*/
	$file_extensions_allowed = array('image/jpeg','image/pjpeg', 'image/jpg', 'image/png', 'image/gif','image/bmp');
	$exts_humano = array('JPG', 'JPEG', 'PNG', 'GIF');
	
	
	$exts_humano = implode(', ',$exts_humano);
	$ext = $_FILES['adjunto']['type'];
	\#$ext = strtolower($ext);
	if(!in_array($ext, $file_extensions_allowed)){
		$exts = implode(', ',$file_extensions_allowed);
		
	$file['msg'] .=\"<p>\".$_FILES['adjunto']['name'].\" <br />Puede subir archivos que tengan alguna de estas extenciones: \".$exts_humano.\"</p>\";
	$file['status'] = 0 ;
	}else{
		include(APPPATH.'libraries/class.upload.php');
		$yukle = new upload;
		$yukle->set_max_size(1900000);
		$yukle->set_directory('./images-"+@plural+"');
		$yukle->set_tmp_name($_FILES['adjunto']['tmp_name']);
		$yukle->set_file_size($_FILES['adjunto']['size']);
		$yukle->set_file_type($_FILES['adjunto']['type']);
		$random = substr(md5(rand()),0,6);
		$name_whitout_whitespaces = str_replace(\" \",\"-\",$_FILES['adjunto']['name']);
		$imagname=''.$random.'_'.$name_whitout_whitespaces;
		\#$thumbname='tn_'.$imagname;
		$yukle->set_file_name($imagname);
		
	
		$yukle->start_copy();
		
		
		if($yukle->is_ok()){
		\#$yukle->resize(600,0);
		\#$yukle->set_thumbnail_name('tn_'.$random.'_'.$name_whitout_whitespaces);
		\#$yukle->create_thumbnail();
		\#$yukle->set_thumbnail_size(180, 0);
		
			//UPLOAD ok
			$file['filename'] = $imagname;
			$file['status'] = 1;
		}
		else{
			$file['status'] = 0 ;
			$file['msg'] = 'Error al subir archivo';
		}
		
		//clean
		$yukle->set_tmp_name('');
		$yukle->set_file_size('');
		$yukle->set_file_type('');
		$imagname='';
	}//fin if(extencion)	
		
		
	return $file;
}"
end
controller_file <<"

} //end class

?>"


file_controller_file = File.new("../application/controllers/control/#{@plural}.php", "w+")
if file_controller_file
   file_controller_file.syswrite(controller_file)
else
   puts "Unable to open file!"
end
